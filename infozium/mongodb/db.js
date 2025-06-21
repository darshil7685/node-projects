const mongoose = require("mongoose");
//const uri = "mongodb+srv://dp7685:dp7685@cluster0.7jmeu.mongodb.net/practice?retryWrites=true&w=majority";
const url = "mongodb://localhost:27017/practice";
try {
  const connection=mongoose.connect(url)
    // { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true },
    //utoIncrement.initialize(connection);
     console.log("db connected")
  
} catch (err) {
  console.log("could not connect" + err);
}
