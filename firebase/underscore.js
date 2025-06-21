import _ from "underscore"

var employees = [
    {
        "id":100,
        "name":"Soni",
        "designation":"SE",
        "salary":25000
    },
    {
        "id":1,
        "name":"Soni",
        "designation":"SE",
        "salary":25000
    },
    {
        "id":2,
        "name":"Rohit",
        "designation":"SE",
        "salary":35000
    },
    {
        "id":3,
        "name":"Akanksha",
        "designation":"Manager",
        "salary":45000
    },
    {
        "id":4,
        "name":"Mohan",
        "designation":"SE",
        "salary":30000
    },
    {
        "id":5,
        "name":"Gita",
        "designation":"SE",
        "salary":35000
    },
    {
        "id":6,
        "name":"Gita",
        "designation":"SE",
        "salary":35000
    }
]
let emp=[
    {
        "id":5,
        "name":"Gita",
        "designation":"SE",
        "salary":35000
    }
]
let result = _.reject(employees,ele=>{
    return ele.id==5
})
// console.log(result);
// console.log(_.pluck(result,'name'))

// console.log(_.indexBy(employees,'name'))
// console.log(_.countBy(employees,ele=>{
//     return ele.designation =="SSE" ?'SSE':'Other'
// }));

// console.log(_.sample(employees,2));

// console.log(_.partition(employees,isOdd));

// console.log(_.groupBy(employees,'designation'));

// console.log(_.union(employees,emp))
console.log(employees.concat(emp));
// console.log(_.uniq([1,2,1,3,3],false));

