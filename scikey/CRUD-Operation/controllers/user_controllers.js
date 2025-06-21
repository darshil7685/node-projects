const dbConfig=require("../config/dbConfig");
const mssql =require("mssql")
const nodemailer=require("nodemailer");
const res = require("express/lib/response");
const Excel = require('exceljs')

module.exports={getEmployeeData,deleteEmployee,upsertEmployee,mailto}
async function getEmployeeData(req,res,next){
    try{
        console.log("emp_id",req.body.emp_id)
        let dbConnection=await mssql.connect(dbConfig)
 
        let emp_id=req.body.emp_id == undefined?null:req.body.emp_id;
        // if(req.body.emp_id == undefined){
        // response = await dbConnection.request().execute('demoDbo.usp_employee_details_getData');
        // }else{
        // response = await dbConnection.request().input("emp_id",req.body.emp_id).execute('demoDbo.usp_employee_details_getData');
        // }
        let response = await dbConnection.request().input("emp_id",emp_id).execute('demoDbo.usp_employee_details_getData');

        console.log(response.recordset)
        if(response.recordset.length == 0){
            return res.status(200).json({status:false,message: "Data not fount"})
        }
        return res.status(200).json({status:true,data:response.recordset});
    }catch(err){
        console.log(err)
        return res.status(500).json({status:false,message:"Internal Server Error"});
    }
}

async function deleteEmployee(req,res,next){
    try{
        if(!req.body.emp_id){
            return res.status(400).json({status:false,message:"Please provide emp_id"})
        }
        console.log("emp_id",req.body.emp_id)
        let dbConnection=await mssql.connect(dbConfig)
        let response = await dbConnection.request().input("emp_id",req.body.emp_id).execute('demoDbo.usp_employee_details_delete');
        console.log(response)
        if(response.recordset == undefined){
        return res.status(200).json({status:true,message:"Deleted Successfully"});
        }
        return res.status(404).json({status:false,message:response.recordset[0].error});
    }catch(err){
        console.log(err)
        return res.status(500).json({status:false,message:"Internal Server Error"});
    }
}

async function upsertEmployee(req,res,next){
    try{
        const {emp_name,emp_salary,emp_designation,manager_id}=req.body
        console.log("emp_id",req.body.emp_id)
        let dbConnection=await mssql.connect(dbConfig)

        let emp_id=req.body.emp_id == undefined?null:req.body.emp_id;
        // if(emp_id == undefined){
        //     response = await dbConnection.request().input("emp_name",emp_name).input("emp_salary",emp_salary).input("emp_designation",emp_designation).input("manager_id",manager_id).execute('demoDbo.usp_employee_details_upsert');
        // }else{
        //     response = await dbConnection.request().input("emp_id",emp_id).input("emp_name",emp_name).input("emp_salary",emp_salary).input("emp_designation",emp_designation).input("manager_id",manager_id).execute('demoDbo.usp_employee_details_upsert');
        // }
        let response = await dbConnection.request().input("emp_id",emp_id).input("emp_name",emp_name).input("emp_salary",emp_salary).input("emp_designation",emp_designation).input("manager_id",manager_id).execute('demoDbo.usp_employee_details_upsert');

        console.log(response)

        if(response.recordset == undefined){
            return res.status(200).json({status:true,message:"Your request fullfilled"});            
        }
        return res.status(400).json({status:false,message:response.recordset[0].error});        
    }catch(err){
        console.log(err)
        return res.status(500).json({status:false,message:"Internal Server Error"});
    }
}


var transporter = nodemailer.createTransport({
    host:"smtp.gmail.com",
    secure: true, 
    port: 587,
    secureConnection: false,
    auth: {
        user: 'deeprathod699@gmail.com',
        pass: '9925659098',
    }
    });

async function mailto(req,res,next){
    try{
        console.log("API /mailto called")
        var mailOptions = {
            from: 'deeprathod699@gmail.com',
            to: 'djpansuriya6555@gmail.com',
            subject: 'Sending Email using Node.js',
            text: 'Hello'
        };
      transporter.sendMail(mailOptions, function(error, info){
        if (error) {
          console.log(error);
             return res.status(400).json({status:false,message:error})
        } else {
          console.log('Email sent: ' + info);
          return res.status(200).json({status:true,message:info})
        }
      }); 
    }catch(error){
         console.log(error)
        return res.status(500).json({status:false,message:"Internal Server Error"});
    }
}

let ejs = require("ejs");
let pdf = require("html-pdf");
let path = require("path");
let students = [
    {name: "Joy",
     email: "joy@example.com",
     city: "New York",
     country: "USA",
    a:"a",
    b:"b"},
    {name: "John",
     email: "John@example.com",
     city: "San Francisco",
     country: "USA"},
    {name: "Clark",
     email: "Clark@example.com",
     city: "Seattle",
     country: "USA"},
    {name: "Watson",
     email: "Watson@example.com",
     city: "Boston",
     country: "USA"},
    {name: "Tony",
     email: "Tony@example.com",
     city: "Los Angels",
     country: "USA"
 },
 {name: "John",
  email: "John@example.com",
  city: "San Francisco",
  country: "USA"},
 {name: "Clark",
  email: "Clark@example.com",
  city: "Seattle",
  country: "USA"},
 {name: "Watson",
  email: "Watson@example.com",
  city: "Boston",
  country: "USA"},
 {name: "Tony",
  email: "Tony@example.com",
  city: "Los Angels",
  country: "USA"
},
{name: "John",
 email: "John@example.com",
 city: "San Francisco",
 country: "USA"},
{name: "Clark",
 email: "Clark@example.com",
 city: "Seattle",
 country: "USA"},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "John",
 email: "John@example.com",
 city: "San Francisco",
 country: "USA"},
{name: "Clark",
 email: "Clark@example.com",
 city: "Seattle",
 country: "USA"},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "John",
 email: "John@example.com",
 city: "San Francisco",
 country: "USA"},
{name: "Clark",
 email: "Clark@example.com",
 city: "Seattle",
 country: "USA"},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "John",
 email: "John@example.com",
 city: "San Francisco",
 country: "USA"},
{name: "Clark",
 email: "Clark@example.com",
 city: "Seattle",
 country: "USA"},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
},
{name: "Watson",
 email: "Watson@example.com",
 city: "Boston",
 country: "USA"},
{name: "Tony",
 email: "Tony@example.com",
 city: "Los Angels",
 country: "USA"
}
];
const fs=require("fs")
const hbs=require("handlebars")
// function generatepdf(){
//      ejs.renderFile("pdf1.ejs", {students: students}, (err, data) => {
//     if (err) {
//           console.log(err);
//     } else {
//         let options = {
//             "height": "11.25in",
//             "width": "8.5in",
//             "format": "A4",
//             "header": {
//                 "height": "20mm"
//             },
//             "footer": {
//                 "height": "20mm",
//             },
//         };
//         pdf.create(data, options).toFile("report.pdf", function (err, data) {
//             if (err) {
//                 console.log(err);
//             } else {
//                 console.log("File created successfully");
//             }
//         });
//     }
// });
//  }

 //generatepdf()
let student=[{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},{
    name:"John",
    age:33,
    address:"NYC"
},
]
//  function generatepdf1(){
//     fs.readFile('data.html','utf8',(err,html)=>{
//           if(err){
//          console.log(err)
//           }else{
//         //console.log(html)
//           let result=hbs.compile(html)({data: student})
//          //console.log(result)
//         let options = {
//            "height": "11.25in",
//            "width": "8.5in",
//            "format": "A4",
//            "header": {
//                "height": "20mm"
//            },
//            "footer": {
//                "height": "20mm",
//            },
//        };
//        pdf.create(result, options).toFile('report.pdf', function (err, data) {
//            if (err) {
//                console.log(err);
//            } else {
//                console.log("File created successfully");
//            }
//        });
//    }
// });
// }
//generatepdf1()
let moment =require("moment")
let body=require("./data.json")
body["data"]["gridData"].forEach((obj)=>{
    Object.keys(obj).forEach((key)=>{
        if(typeof obj[key] == 'number' && !Number.isInteger(obj[key])){
            obj[key]=obj[key].toFixed(2)                        
        }
    })
})
function pdfDownloadStones(){
    var startTime = moment();
     ejs.renderFile('stonedata1.html',{businessSummaryStoneDetailsPrintObject:body["data"],print_mapping:body["print_mapping"]},(err,html)=>{
                if(err){
                     console.log(err)
                }else{ 
                        // body["isRFS"]=(!body["isRFS"])?true:false
                        // let systemDateTime=new Date()
                        //  body["systemDate"]=moment(systemDateTime).format("DD/MM/YYYY")
                        //  body["systemTime"]=moment(systemDateTime).format("HH:mm:ss")
                      //let result=hbs.compile(html)({data:body["gridData"],summary:body["summaryGridData"],businessSummaryStoneDetailsPrintObject:businessSummaryStoneDetailsPrintObject})
                    // let result=hbs.compile(html)({businessSummaryStoneDetailsPrintObject:body}) 
                    // let filename="stoneData "+moment(new Date()).format('DD-MM-YYYY h-mm-ss.SSS')+".pdf"
                    let filename="stoneData"+".pdf"
                    let options = {
                         "format": "A4",  
                         "orientation": "landscape",      
                         "header": {
                         "height": "20mm"
                         },
                         "footer": {
                         "height": "20mm",
                        },
                    };
                    pdf.create(html,options).toFile(`${filename}`,function (err, data) {
                         if (err) {
                            console.log(err)
                             callback(err)
                         } else {
                            console.log(data)
                          }
                    })
                }
            })     
}
pdfDownloadStones()