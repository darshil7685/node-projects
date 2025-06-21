let pdf = require("html-pdf");
let path = require("path");
let fs=require("fs")
let func = require('../utils/utility-functions');
let moment=require("moment")
let nodemailer=require("nodemailer")
const hbs=require("handlebars")

module.exports={
    pdfDownloadStones:pdfDownloadStones
}
function pdfDownloadStones(sessionObject,body,callback){
    var startTime = moment();
    sails.logger.log(func.logCons.LOG_LEVEL_INFO, func.logCons.LOG_ENTER + 'PdfDownloadService.pdfDownloadStones()', sessionObject);
    fs.readFile('assets/apidoc/stonedata.html','utf8',(err,html)=>{
                if(err){
                     sails.logger.log(func.logCons.LOG_LEVEL_ERROR, 'Error while reading html file, error = ' + err, sessionObject);
                    sails.logger.log(func.logCons.LOG_LEVEL_ERROR, func.logCons.LOG_EXIT + 'PdfDownloadService.pdfDownloadStones() with error, responseTime=' + func.getResponseTime(startTime), sessionObject);
                    callback(err)
                }else{ 
                        body["isRFS"]=(!body["isRFS"])?true:false
                        let systemDateTime=new Date()
                         body["systemDate"]=moment(systemDateTime).format("DD/MM/YYYY")
                         body["systemTime"]=moment(systemDateTime).format("HH:mm:ss")
                      //let result=hbs.compile(html)({data:body["gridData"],summary:body["summaryGridData"],businessSummaryStoneDetailsPrintObject:businessSummaryStoneDetailsPrintObject})
                    let result=hbs.compile(html)({businessSummaryStoneDetailsPrintObject:body}) 
                    let filename="stoneData "+moment(new Date()).format('DD-MM-YYYY h-mm-ss.SSS')+".pdf"
                    let options = {
                         "format": "A4",  
                         "orientation": "portrait",      
                         "header": {
                         "height": "20mm"
                         },
                         "footer": {
                         "height": "20mm",
                        },
                    };
                    pdf.create(result,options).toFile(`assets/apidoc/files/${filename}`,function (err, data) {
                         if (err) {
                            console.log(err)
                            sails.logger.log(func.logCons.LOG_LEVEL_ERROR, 'Error while generating pdf, error = ' + err, sessionObject);
                            sails.logger.log(func.logCons.LOG_LEVEL_ERROR, func.logCons.LOG_EXIT + 'PdfDownloadService.pdfDownloadStones() with error, responseTime=' + func.getResponseTime(startTime), sessionObject);
                            callback(err)
                         } else {
                             sails.logger.log(func.logCons.LOG_LEVEL_INFO, func.logCons.LOG_EXIT + 'PdfDownloadService.pdfDownloadStones() with success, responseTime=' + func.getResponseTime(startTime), sessionObject);
                            callback(null,data)
                         }
                    })
                }
            })     
}