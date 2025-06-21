import axios from 'axios';

const url ="https://jsonplaceholder.typicode.com/todos/1";
interface Todo{
    id:number;
    title:string;
    completed:boolean;
}
axios.get(url).then(response =>{
    const todo = response.data as Todo;
    const id = todo.id;
    const title = todo.title;
    const completed = todo.completed;
    //print(id,title,completed);
})
const print=(id:number,title:string,completed:boolean)=>{
    console.log({id,title,completed});
}

//Destruring 
const forecast={
date:new Date(),
weather:"sunny"
}
const weather=(forecast:{date:Date,weather:string})=>{
    console.log(forecast.date);
    console.log(forecast.weather)
}
const weather1=({date,weather}:{date:Date,weather:string})=>{
    console.log(date);
    console.log(weather)
}
//weather(forecast)
//weather1(forecast)

//array types
const Dates=[new Date(),'2020-5-8']
const date:(Date | string)[]=[] 
const dates=[];
dates.push("2020");
dates.push(new Date())
//console.log(dates)

//tuples
const drink:[string,boolean,number]=["a",true,40]
//drink[0]=80
type a=[number,boolean]
const b:a=[2020,false]
//console.log(b)

//interface as annotations
interface Vehicle{
    name:string,
    year:number,
    broken:boolean
}
const civic={
    name:"civic",
    year:2002,
    broken:false
}
const prinvehicle=(vehicle:Vehicle):void=>{
    console.log(`Name:${vehicle.name}`);
}
prinvehicle(civic)