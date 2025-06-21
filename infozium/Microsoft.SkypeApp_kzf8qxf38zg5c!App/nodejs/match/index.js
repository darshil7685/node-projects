const fs = require("fs-extra");
const db=require("./db");

const jsonData = fs.readJSONSync("./match_284.json");
//console.log(jsonData);


//console.log(jsonData.response.innings.batsmen.map(data=>data.name));
//console.log(jsonData["response"]["innings"][0]["batsmen"][1]["name"]);
const batsmen=[];
for(i in jsonData["response"]["innings"] )
for(j in jsonData["response"]["innings"][i]["batsmen"]){
    batsmen.push([jsonData["response"]["innings"][i]["batsmen"][j]["name"],jsonData["response"]["innings"][i]["batsmen"][j]["batsman_id"],jsonData["response"]["innings"][i]["batsmen"][j]["runs"],jsonData["response"]["innings"][i]["batsmen"][j]["balls_faced"],jsonData["response"]["innings"][i]["iid"]]);
}
//console.log(batsmen);
//db.query("INSERT INTO batsmen (name,batsman_id,runs,balls_faced,iid) VALUES ?",[batsmen],(err,result)=>{
//    if(err) throw err;
//    console.log(result);
//})

const bowlers=[];
for(i in jsonData["response"]["innings"] )
for(j in jsonData["response"]["innings"][i]["bowlers"]){
    bowlers.push([jsonData["response"]["innings"][i]["bowlers"][j]["name"],jsonData["response"]["innings"][i]["bowlers"][j]["bowler_id"],jsonData["response"]["innings"][i]["bowlers"][j]["overs"],jsonData["response"]["innings"][i]["bowlers"][j]["maidens"],jsonData["response"]["innings"][i]["iid"]]);
}
//console.log(bowlers);
//db.query("INSERT INTO bowlers (name,bowler_id,overs,maidens,iid) VALUES ?",[bowlers],(err,result)=>{
//    if(err) throw err;
//    console.log(result);
//})

const fielders=[];
for(i in jsonData["response"]["innings"] )
for(j in jsonData["response"]["innings"][i]["fielder"]){
    fielders.push([jsonData["response"]["innings"][i]["fielder"][j]["fielder_name"],jsonData["response"]["innings"][i]["fielder"][j]["fielder_id"],jsonData["response"]["innings"][i]["fielder"][j]["catches"],jsonData["response"]["innings"][i]["fielder"][j]["stumping"],jsonData["response"]["innings"][i]["iid"]]);

}
//console.log(fielders);
//db.query("INSERT INTO fielders(fielder_name,fielder_id,catches,stumping,iid) VALUES ?",[fielders],(err,result)=>{
//    if(err) throw err;
//    console.log(result);
//})
const extra_runs=[];
for(i in jsonData["response"]["innings"])
{
    extra_runs.push([jsonData["response"]["innings"][i]["extra_runs"]["byes"],jsonData["response"]["innings"][i]["extra_runs"]["legbyes"],jsonData["response"]["innings"][i]["extra_runs"]["wides"],jsonData["response"]["innings"][i]["extra_runs"]["noballs"],jsonData["response"]["innings"][i]["extra_runs"]["penalty"],jsonData["response"]["innings"][i]["extra_runs"]["total"],jsonData["response"]["innings"][i]["iid"]]);

}
//console.log(extra_runs)

//db.query("INSERT INTO extra_runs(byes,legbyes,wides,noballs,penalty,total,iid) VALUES ?",[extra_runs],(err,results)=>{
//    if(err) throw err;
//    console.log(results);
//})


