/** Load database lists in bounded batches to avoid the default 1,000-row API cap. */
export async function fetchAllPages(queryFactory, pageSize=500) {
  const all=[];
  for(let start=0;;start+=pageSize){
    const {data,error}=await queryFactory().range(start,start+pageSize-1);
    if(error) throw error;
    all.push(...(data||[]));
    if(!data||data.length<pageSize) return all;
  }
}
