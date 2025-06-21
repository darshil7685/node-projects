import http from "http"
 
const options = { 
  hostname: 'jsonplaceholder.typicode.com', 
  path: '/posts', 
  method: 'GET'
}; 
 
const req = http.request(options, (res) => { 
  let data = ''; 
  res.on('data', (chunk) => { 
    data += chunk; 
    console.log("chunkchunkchunk",chunk)
  }); 
  res.on('end', () => { 
    console.log(JSON.parse(data)); 
  }); 
  res.on('error',(err)=>{
    console.log("err",err);
  })
}); 
 
req.end(); 






