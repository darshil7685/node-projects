const mongoose=require("mongoose");

const Schema = mongoose.Schema;

const UserSchema = new Schema({
    _id: Schema.Types.ObjectId,
   name: String,
   email: {type:String,required:true},
   blogs: [{ 
      type: mongoose.Schema.Types.ObjectId,
      ref: "Blog"
   }]
});

const BlogSchema = new Schema({
   title: String,
   user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
   },
   body: String,
   comments: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: "Comment"
   }]
})

const CommentSchema = new Schema({
   user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
   },
   blog: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Blog"
   },
   body: String
})


UserSchema.pre('save',(next)=>{
   // if (!this.isModified('email')) return next();
   let user=this
   user.email="jklk@gmail.com"
   console.log("pre user added----- ",user)
   next()
})
UserSchema.post('save',async(doc)=>{
   console.log("post user added ",doc)
})

// Method to compare password
UserSchema.methods.matchemail= async function (email) {
   return await this.email == email
};


const User = mongoose.model("Author", UserSchema);
const Blog = mongoose.model("Blog", BlogSchema);
const Comment = mongoose.model("Comment", CommentSchema);

module.exports = {User, Blog, Comment}
