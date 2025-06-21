require("./db");
const { User, Blog, Comment } = require("./model");
const mongoose = require("mongoose");

async function addUser() {
  const user = await new User({
    _id: new mongoose.Types.ObjectId(),
    name: "a1",
    email: "a@gmail.com",
  },{new :true});

  user.save((err, data) => {
    if (err) console.log("ERROR "+err);
    console.log("datadata",data);
  });
}

addUser();

async function findUserAndUpdate(){
  User.findByIdAndUpdate({_id:"6672ecd11e48a1d204f4eb02"},{$set:{name:"Alis"}},{new:true},(err,user)=>{
    if(err) {
      console.log(("err",err))
    }else{
      user.name='jbu'
      user.save()
      console.log("user",user)
    }
  })
}
// findUserAndUpdate()

async function addBlog() {
  const user_id = "6246b795968f609093e98e6e";
  const blog = await new Blog({
    title: "abc",
    body: "Blog by abc",
    user: "6246b795968f609093e98e6e",
  });

  blog.save(async (err, data) => {
    if (err) console.log(err);
    console.log(data);
    const userById = await User.findById(user_id);

    userById.blogs.push(blog);
    userById.save();
  });
}
//addBlog();

async function addComment() {
  const user_id = "6246b795968f609093e98e6e";
  const blog_id = "6246b9b11582fd7d793b8570";
  const comment = await new Comment({
    body: "Comment by abc",
    user: user_id,
    blog: blog_id,
  });

  comment.save(async (err, data) => {
    if (err) console.log(err);
    console.log(data);
    const blogById = await Blog.findById(blog_id);

    blogById.comments.push(comment);
    blogById.save();
  });
}

//addComment();

function userPopulate() {
  User.find({})
    .select({ name: 1, email: 1, _id: 0 })
    .populate({
      path: "blogs", // populate blogs
      select: { title: 1, body: 1, _id: 0 },
      populate: {
        path: "comments", // in blogs, populate comments
        select: { body: 1, _id: 0 },
      },
    })
    .then((user) => {
      console.log(JSON.stringify(user,null,2));
    });
}
// userPopulate();

function userLookup(){
  Blog.aggregate([
    {
      $lookup:{
        from:'authors',
        localField:'user',
        foreignField:'_id',
        as:'user_info'
      }
    },
  {
    $unwind: "$user_info"
  },
  {
    $lookup:{
      from:'comments',
      localField:'comments',
      foreignField:'_id',
      as:'comment_info'
    }
  },
  {
    $project:{
      title:1,
      body:1,
      comment_info:{body:1},
      'user_info.name':1
      // 'user_info.email':1
    }
  }
  ]).then((blog)=>{
    console.log(JSON.stringify(blog,null,2));
  })
}
// userLookup()

function commentsLookup(){
  Comment.aggregate([
    {
      $lookup:{
        from:'authors',
        localField:'user',
        foreignField:'_id',
        as:'user_info'
      }
    },
    {
        $unwind:"$user_info"  
    },{
      $lookup:{
        from:'blogs',
        localField:'blog',
        foreignField:'_id',
        as:'blog_info'
      }
    },{
      $unwind:"$blog_info"
    },{
      $project:{
        body:1,
        "user_info.name":1,
        "user_info.email":1,
        "blog_info.title":1
      }
    }
  ]).then((comments)=>{
    console.log("comments",comments);
  })
}
// commentsLookup()


function projection(){
  User.find({},{projection:{_id:1,name:1}}).then((users)=>{
    return users
  })
}
// console.log(projection())
function commentPopulate(){
// Comment.find()
//   .populate('authors')
//   .populate('blog')
//   .then((user) => {
//     console.log(JSON.stringify(user));
//   });
  Comment.find()
  // .populate('user')
  .populate('blog')
  .then((user) => {
    console.log(JSON.stringify(user,null,2));
  });
}

// commentPopulate()