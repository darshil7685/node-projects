const mongoose=require("mongoose");
var userSchema = mongoose.Schema({
    username    : String,
    post : [{ type: mongoose.Schema.Types.ObjectId, ref: 'Post' }]
  }, {
    toJSON: {
      virtuals: true,
    }});

  module.exports = new mongoose.model("User",userSchema);