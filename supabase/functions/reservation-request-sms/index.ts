// Supabase Database Webhook only: never call this function from the public browser.
// Deploy with --no-verify-jwt and protect via RESERVATION_WEBHOOK_SECRET.
import { createClient } from 'jsr:@supabase/supabase-js@2';

const json = (body: unknown, status=200) => new Response(JSON.stringify(body), {status,headers:{'Content-Type':'application/json','Cache-Control':'no-store'}});
function normalizePH(value: unknown): string | null {
  if(typeof value !== 'string') return null;
  const x=value.replace(/[\s().-]/g,'');
  if(/^09\d{9}$/.test(x)) return '+63'+x.slice(1);
  if(/^639\d{9}$/.test(x)) return '+'+x;
  if(/^\+639\d{9}$/.test(x)) return x;
  return null;
}
Deno.serve(async req => {
  if(req.method !== 'POST') return json({error:'POST only'},405);
  const webhookKey=Deno.env.get('RESERVATION_WEBHOOK_SECRET');
  if(!webhookKey || req.headers.get('x-carefur-webhook-secret') !== webhookKey) return json({error:'Unauthorized'},401);
  const url=Deno.env.get('SUPABASE_URL');
  const service=Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  const apiKey=Deno.env.get('TEXTBEE_API_KEY');
  const payInstructions=Deno.env.get('CAREFUR_PAYMENT_INSTRUCTIONS');
  if(!url || !service || !apiKey || !payInstructions) return json({error:'Missing server-side configuration'},500);
  let payload: {type?:string;record?:{id?:string}};
  try { payload=await req.json(); } catch { return json({error:'Invalid JSON'},400); }
  if(payload.type !== 'INSERT' || !payload.record?.id || !/^[0-9a-f-]{36}$/i.test(payload.record.id)) return json({error:'Invalid insert webhook'},400);
  const db=createClient(url,service,{auth:{persistSession:false,autoRefreshToken:false}});
  const id=payload.record.id;
  const {data:r,error:lookupError}=await db.from('reservation_requests')
    .select('id,request_code,owner_name,phone,pet_name,status').eq('id',id).maybeSingle();
  if(lookupError) return json({error:'Cannot find reservation'},500);
  if(!r || r.status!=='pending_payment') return json({ok:true,skipped:'Not pending'});
  // At-most-once enqueue: a duplicate webhook cannot send an extra SMS.
  const {error:claimError}=await db.from('reservation_sms_notifications')
    .insert({request_id:r.id,status:'sending'});
  if(claimError?.code==='23505') return json({ok:true,skipped:'Already processed'});
  if(claimError) return json({error:'Unable to record notification'},500);
  const phone=normalizePH(r.phone);
  let result='failed';let detail='';
  try {
    if(!phone) throw new Error('Missing or invalid Philippine mobile number');
    const message=[
      'CareFur - Snuggles Premium Pet Hotel',
      `Hello ${r.owner_name || 'Pet Owner'}, we received the reservation request for ${r.pet_name || 'your pet'}.`,
      `Request reference: ${r.request_code || r.id.slice(0,8)}`,
      'THIS IS NOT YET A CONFIRMED BOARDING.',
      `Payment instructions: ${payInstructions}`,
      'Your reservation is confirmed only after payment is verified and staff approves it.',
      'No boarding access code has been issued.'
    ].join('\n');
    const deviceId=Deno.env.get('TEXTBEE_DEVICE_ID')?.trim();
    const response=await fetch('https://api.textbee.dev/api/v1/gateway/send-sms',{
      method:'POST',headers:{'x-api-key':apiKey,'Content-Type':'application/json'},
      body:JSON.stringify({recipients:[phone],message,...(deviceId?{deviceId}:{})}),
      signal:AbortSignal.timeout(15000)
    });
    if(!response.ok) throw new Error(`TextBee HTTP ${response.status}`);
    result='queued';
  } catch(e) { detail=e instanceof Error ? e.message : 'Unknown error'; }
  const {error:saveError}=await db.from('reservation_sms_notifications')
    .update({status:result,error:detail || null,updated_at:new Date().toISOString()}).eq('request_id',r.id);
  if(saveError) console.error('SMS result logging failed',saveError.message);
  return result==='queued'?json({ok:true,status:result}):json({ok:false,status:result,error:detail},502);
});
