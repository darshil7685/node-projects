
import fs from "fs"


let dataBuffer = fs.readFileSync('compnies.pdf');
console.log(" dataBuffer dataBuffer dataBuffer", dataBuffer)

// pdf(dataBuffer).then(function(data) {
//     // number of pages
//     console.log(data.numpages);
//     // number of rendered pages
//     console.log(data.numrender);
//     // PDF info
//     console.log(data.info);
//     // PDF metadata
//     console.log(data.metadata); 
//    console.log(data.version);
//     // PDF text
//     console.log(data.text); 
        
// }).catch(function(err){
//     console.log(err);
// });