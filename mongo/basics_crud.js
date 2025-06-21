db.practice.find({
    "config_type": "super_config",
    "config_name": "column_filters",
   
})
    .projection({})
    .sort({ _id: -1 })
    .limit(100)


//   db.practice.update({"team" : "Engloand"},{$pull:{"players.root.bowler":false }})

// db.practice.insert({
//     "config_type":"super_config",
//     "config_name":"column_filters",
//         "values":[{
//             "tab_name":"gms",
//             "attributes":[{
//                 "a":1,
//                 "b":2
//             }]
//         },
//         {
//             "tab_name":"pms",
//             "attributes":[{
//                 "x":14,
//                 "y":24
//             }]
//         }]

// })
// db.practice.deleteOne({"config_type" : "super_config",
//  	"config_name" : "column_filters"})


// db.practice.update({"config_type" : "super_config",
// 	"config_name" : "column_filters"},
// {$pull:  {values:{tab_name:{$in:["gms"]}}}} )



// db.practice.update({
//     "config_type": "super_config",
//     "config_name": "column_filters"
// },
//     { $push: { values: [{ "tab_name": "css", "attributes": [{ "a": 1 }] }, { "tab_name": "ams", "attributes": [{ "a": 1 }] }] } },{})




