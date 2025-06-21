let ejs = require("ejs");
let pdf = require("html-pdf");
let path = require("path");
let fs=require("fs")
let moment=require("moment")
let nodemailer=require("nodemailer")
const hbs=require("handlebars")
let stoneData=require("./stoneData.json")
let data=require("./stone.json")
 const { responseGenerator } = require("../utils/utility-functions")
 let sData=require("./s.json")

module.exports={stoneDataPdf}
var transporter = nodemailer.createTransport({
    host:"smtp-mail.outlook.com",
    secure: false, 
    port: 587,
    secureConnection: false,
    auth: {
        user: 'sachi.shah@scikey.ai',
        pass: '101rameshw*',
    }
 });
 console.log(sails.path)
 function stoneDataPdf(req){
     return new Promise((resolve,reject)=>{
         let flag={
             is_all_column:false
         }
         let datetime={
             date:moment(new Date()).format("DD-MM-YYYY"),
             time:moment(new Date()).format(("HH:mm:ss"))
         }
         ejs.renderFile('C:/Users/Darsil.Pansuriya/OneDrive - SRKay Consulting Group/Desktop/training/assets/templates/stonedata1.html', 
            {stoneData: stoneData,flag:flag,datetime:datetime}, (err, data) => {
        if (err) {
              console.log(err)
              return reject(responseGenerator(true,'Error occured while creating table',null))
        } else {
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
            let filename="stone_data "+moment(new Date()).format('DD-MM-YYYY h-mm-ss.SSS')+".pdf"
            pdf.create(data, options).toFile(`C:/Users/Darsil.Pansuriya/OneDrive - SRKay Consulting Group/Desktop/training/assets/files/${filename}`,function (err, data) {
                if (err) {
                    console.log(err)
                    return reject(responseGenerator(true,'Error occured while creating pdf',null))
                   } else {
                 console.log(data)
                    console.log("File created successfully");
                    if(req.body.is_mail == 1){
                       let mailOptions = {
                            from: 'sachi.shah@scikey.ai',
                            to: 'Darsil.Pansuriya@scikey.ai,cse.180840131033@gmail.com',
                            subject: "stone data",
                            text: 'Details of stoneData',
                            attachments:[{
                                filename:path.basename(data.filename),
                                path:data.filename
                            }]
                        };
                        transporter.sendMail(mailOptions, function(error, info){
                            if (error) {
                                console.log(error); 
                                return reject(responseGenerator(true,'Error occured while mailing the info',null))
                            } else {
                              console.log('Email sent: ' + JSON.stringify(info));
                              return resolve(responseGenerator(false,null,null))
                            }
                          }); 
                    } else{
                      return resolve(responseGenerator(false,null,data.filename))
                    }
                }
            });
        }
    });
})
}

// function stoneDataPdf(req){
//     return new Promise((resolve,reject)=>{
//         console.log('/stoneDataPdf called')
//             fs.readFile('C:/Users/Darsil.Pansuriya/OneDrive - SRKay Consulting Group/Desktop/training/assets/templates/stonedata.html','utf8',(err,html)=>{
//                 if(err){
//                     console.log(err)
//                 }else{
//                     //console.log(html)
//                     let businessSummaryStoneDetailsPrintObject={
//                         "companyName":"SRK"
//                     }
//                     let result=hbs.compile(html)({data:sData["data"]["body"],businessSummaryStoneDetailsPrintObject:businessSummaryStoneDetailsPrintObject})
//                     //console.log(result)
//                     let filename="stone "+moment(new Date()).format('DD-MM-YYYY h-mm-ss.SSS')+".pdf"
//                     let options = {
//                          "format": "A4",  
//                          "orientation": "landscape",      
//                          "header": {
//                          "height": "20mm"
//                          },
//                          "footer": {
//                          "height": "20mm",
//                         },
//                     };
//                     pdf.create(result, options).toFile(`C:/Users/Darsil.Pansuriya/OneDrive - SRKay Consulting Group/Desktop/training/assets/files/${filename}`,function (err, data1) {
//                          if (err) {
//                             console.log(err)
//                             return reject(responseGenerator(true,'Error occured while creating pdf',null))
//                         } else {
//                             console.log(data1)
//                             return resolve(responseGenerator(false,null,data1))
//                         }
//                     })
//                 }
//             })     
//    });  
// }
    
    
   

