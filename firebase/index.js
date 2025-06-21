// import firebase from "firebase";
// import fireStore from "firestore";
// // let fireStore=firebase.fireStore()

// const firebaseConfig = {
//   apiKey: "AIzaSyAk21_zB_baOUX1Vc7OpkZkiEqEMrTxm2M",
//   authDomain: "fir-22070.firebaseapp.com",
//   projectId: "fir-22070",
//   storageBucket: "fir-22070.appspot.com",
//   messagingSenderId: "389219590226",
//   databaseURL: "https://fir-22070-default-rtdb.asia-southeast1.firebasedatabase.app",
//   appId: "1:389219590226:web:5b8af4e8becaa872aabf8b",
//   measurementId: "G-VH0YZKDMMP"
// };

// let db= firebase.initiaizeApp(firebaseConfig)

// async function addUsers(){
//     let user={
//         username:"Alex",
//         password:"alex",
//         phone:9824470182,
//         location:"Surat"
//     }
//     let data = await fireStore.collection("users").doc().set(user)
//     console.log(data)
//     console.log("Successfully data added!")
// }

import xl from "excel4node";

var wb = new xl.Workbook();

var ws = wb.addWorksheet("Employee");
wb.addWorksheet("Employee12");
var style = wb.createStyle({
  font: {
    color: '#FF0800',
    size: 12,
    bold:true,
    fill: { 
      // bgColor: '#FFFF00',
      fgColor: '#CDDC39',
      type: 'pattern', 
      patternType: 'solid',

  }
  },
});
let data = [
  {
    EmpID: 1,
    Empname: "Akash kg Mehra",
    Department: "HR",
    Project: "P1",
    Address: "Hyderabad(HYD)",
    DOB: "1976-12-01",
    Gender: "M",
    a:"a",
    b:"b",
    c:"c",
    d:"d"
  },
  {
    EmpID: 2,
    Empname: "Ananya Mishrakg",
    Department: "Admin",
    Project: "P2",
    Address: "Delhi(DEL)",
    DOB: "1968-05-02",
    Gender: "F",
    a:"a",
    b:"b",
    c:"c",
    d:"d"
  },
  {
    EmpID: 3,
    Empname: "kgRohan Diwan",
    Department: "Account",
    Project: "P3",
    Address: "Mumbai(BOM)",
    DOB: "1980-01-01",
    Gender: "M",
    a:"a",
    b:"b",
    c:"c",
    d:"d"
  }
];

let header=[{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  // "":"",
  c:"C",
  d:"D" ,
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  // "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  // "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  // "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  // "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  // "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  // "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  // "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  // "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  // "":"",
  c:"C",
  d:"D"
},{
  EmpID: "Emp Id",
  Empname: "Emp Name",
  Department: "Department",
  Project: "Project",
  Address: "Address",
  // "":"",
  DOB: "Date of Birth",
  Gender: "Gender",
  a:"A",
  b:"B",
  // "":"",
  c:"C",
  d:"D"
}]
let breakpoints=["EmpID","a"]

// breakpoints.forEach((bk,bkIndex)=>{
//   let headers=[]
//   let headerKeys=(Object.keys(header))
//   for (let headerKey=0;headerKey<headerKeys.length;headerKey++){
    
//     if(headerKeys[headerKey] == breakpoints[bkIndex+1]) break
//     else
//     headers.push(headerKeys[headerKey] )
//   }
//   console.log(headers)
// })




var lastColumn =ws.lastUsedCol
var lastRow =ws.lastUsedRow

header.forEach((headerss,checkindex)=>{
  let headers=Object.values(headerss)
  let headerkeys=Object.keys(headerss)
  console.log("index",checkindex)
  console.log("lastColumn",lastColumn)
  console.log(lastRow,lastColumn)
  headers.forEach((header,index)=>{
    // console.log(header,index)
     ws.cell(lastRow,index+lastColumn).string(header)
  })
  data.forEach((obj,index)=>{
    headerkeys.forEach((key,keyIndex)=>{
      if(obj[key] && obj[key] !=="" && obj[key] !== null)
        ws.cell(1+lastRow+index,lastColumn+keyIndex).string((obj[key]).toString())
      else
        ws.cell(1+lastRow+index,lastColumn+keyIndex).string(("").toString())
    })
  })
  if(checkindex%2 == 0) {
    console.log("++++++++++++ ",ws.lastUsedCol);
    // lastColumn=Number(ws.lastUsedCol)+2
    lastColumn=((headerkeys).length)+3
  }
  else {
    console.log("============= ",ws.lastUsedCol);
    lastColumn=1
    lastRow = Number(ws.lastUsedRow)+3
  }
})

// console.log(ws.lastUsedRow,ws.lastUsedCol)
// let lastColumn =ws.lastUsedCol+2
// headers.forEach((header,index)=>{
//    ws.cell(1,index+lastColumn).string(header)
// })
// data.forEach((obj,index)=>{
//   headerkeys.forEach((key,keyIndex)=>{
//     if(obj[key] && obj[key] !=="" && obj[key] !== null)
//       ws.cell(2+index,lastColumn+keyIndex).string((obj[key]).toString())
//     else
//       ws.cell(2+index,lastColumn+keyIndex).string(("").toString())
//   })
// })

console.log(ws.lastUsedRow,ws.lastUsedCol)
var filename="a"+ ".xlsx"
wb.write(filename);

// console.log(Object.keys(wb.sheets[0]["rows"])) //get row list for last row in excel
// console.log(wb.sheets)
// wb.sheets.forEach((sheet)=>{
//   if(sheet.name ==="Employee"){
//     console.log(Object.keys(sheet.rows)) //get row list for last row in excel from perticular sheet
//   }
// })




import fs from "fs"

fs.readFile('companies.pdf','utf8',(err,data)=>{
    if(err) console.log("err",err);
    else console.log(("data",data));
})

import pdf from "pdf-parse"


// let dataBuffer = fs.readFileSync('compnies.pdf');
// console.log(" dataBuffer dataBuffer dataBuffer", dataBuffer)

