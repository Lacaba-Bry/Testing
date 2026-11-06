# CareFur Boarding SMS (TextBee)

When staff create a booking (new or returning customer), the `create-booking` Supabase Edge Function generates one access code for email, SMS and the admin confirmation page. The SMS is sent to `owners.phone` (falling back to `users.phone` or the new customer phone) when it is a valid Philippine mobile number.

## Configuration

1. Create/rotate a TextBee key at https://textbee.dev/. Ensure the registered Android handset is **online**, with SMS permission enabled, mobile service and sufficient SMS balance.
2. In Supabase Dashboard > Edge Functions > Secrets, add `TEXTBEE_API_KEY` (the *real*, current key). Optionally add `TEXTBEE_DEVICE_ID` if you wish to specify a device. Do not prefix these with `VITE_`.
3. Deploy the updated function, from the repository root: `npx supabase functions deploy create-booking --project-ref YOUR_PROJECT_REF` (log in and link project as needed).
4. Ensure phone numbers are saved in the owner record. The function accepts 09XXXXXXXXX, 9XXXXXXXXX, 639XXXXXXXXX and +639XXXXXXXXX; it converts them to +639XXXXXXXXX.
5. Create a test booking for a number you control; verify `sms.status` in the create-booking response and then check TextBee Messaging History for actual delivery.

**Important:** A successful TextBee API call means the message has been **queued**, not that it reached the recipient. Offline phones may leave the message pending. Missing/invalid numbers, API failures and email failures do **not** cancel a successfully-created booking; admins see the separate statuses.

If you previously stored `TEXTBEE_API_KEY` only in `.env.local`, that **does not configure your deployed Supabase function**. Move it to Supabase Edge Function secrets and remove it from any frontend build environment. Never commit real API keys.
