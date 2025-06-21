// let rows = 5;

// // pattern variable carries the final pattern in string format
// let pattern = "";

// // outer loop runs for `rows` no. of times
// for (let n = 1; n <= rows; n++) {
//    // inner loop runs for n
//    for (let num = 1; num <= n; num++) {
//       pattern += num;
//    }

//    // Add a new line character after contents of each line
//    pattern += "\n";
// }
// console.log(pattern);

let rows = 5;

// pattern variable carries the final pattern in string format
let pattern = "";

// outer loop runs for `rows` no. of times
for (let n = 1; n <= rows; n++) {
   for (let num = 1; num <= 5; num++) {
      // print star only if it is the boundary location
      if (n == 1 || n == rows) pattern += "*";
      else {
         if (num == 1 || num == 5) {
            pattern += "*";
         } else {
            pattern += " ";
         }
      }
   }
   pattern += "\n";
}
// console.log(pattern);




function jumpToIndex(arr,index){
   let currIndex=index
   while(index >=0 && index <= arr.length){
      let nextIndex = currIndex + arr[currIndex]
      console.log("nextIndex",nextIndex);
      
      if(nextIndex == arr.length-1){
         return true
      }
      if(nextIndex > arr.length-1){
         break
      }
      currIndex=nextIndex
   }
   return false
}

console.log(jumpToIndex([1,1,2],1))


