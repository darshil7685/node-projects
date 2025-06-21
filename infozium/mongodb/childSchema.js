require("./db")
const  mongoose  = require("mongoose");

//const mongoose=require("mongoose");
const Schema=mongoose.Schema;

const childSchema = new Schema({ name: 'string' });

const parentSchema = new Schema({
  // Array of subdocuments
  children: [childSchema],
  // Single nested subdocuments. Caveat: single nested subdocs only work
  
  child: childSchema
});

const Parent=new mongoose.model("Parent",parentSchema);
const Child =new mongoose.model("Child",childSchema);

const parent=new Parent({
    children:[{name:"abc"},{name:"abc"}],
    child:{name:"abc"}
})

//parent.save();

const child=new Child({name:"a"});
// child.save(async(err,data)=>{
//     const id = "624eb61f9c39cd9450913e5c";

//     const userById = await Parent.findById(id);
//     console.log(userById)
//     userById.child.push(child);
// })

const id = "624eb61f9c39cd9450913e5c";

const userById = Parent.findById(id);
const parent1=new Parent();
parent1.children.id('624eb61f9c39cd9450913e5d').remove();
console.log(userById)

