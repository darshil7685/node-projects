const mongoose=require("mongoose");
var postSchema = mongoose.Schema({
    title    : String,
    username:String,
    postBy : { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  }, {
    toJSON: {
      virtuals: true,
    }});

  module.exports = new mongoose.model("Post",postSchema);