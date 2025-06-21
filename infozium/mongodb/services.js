require("./db");
const User = require("./models/user.model");
const Post = require("./models/post.model");
const UserDetails = require("./models/userDetails.model");

async function createUSer() {
  const user = new User({ username: "xyz" });

  // if(err){
  //     console.log("ERR "+err);
  // }
  const userData = await user.save();
  console.log(userData);
}
//createUSer()

async function createPost() {
  const post = new Post({
    title: "post 2",
    username:"abc"
   
  });

  const postData = await post.save();
  console.log(postData);
   const id = "6242d0fe0144f5a814a30cfd";

   const userById = await User.findById(id);

   userById.post.push(post);
   await userById.save();
}
//createPost()

async function findUser() {
  const users = await User.find({}).populate("post");
  //const users = await User.find({});
  console.log(JSON.stringify(users));
}
//findUser()

async function findPost() {
  const users = await Post.find({});
  console.log(JSON.stringify(users));
}
//findPost()

const a = {
  user_id: 47363,
  champion_index: 0,
  champion_purchased: true,
  bodytypelist: [
    { SelectbodyType: "Cloth", CurrentType: 3, HasColorChangeOption: false },
    { SelectbodyType: "Hair", CurrentType: 0, HasColorChangeOption: true },
    { SelectbodyType: "Shield", CurrentType: 1, HasColorChangeOption: false },
    { SelectbodyType: "Weapon", CurrentType: 5, HasColorChangeOption: false },
    { SelectbodyType: "Shoes", CurrentType: 0, HasColorChangeOption: true },
  ],
};

async function createUserDetails() {
  const userdetails = new UserDetails(a);
  await userdetails.save();
  
  console.log(userdetails);
}
//createUserDetails();

async function findUserDetails(){
var userdetails =await UserDetails.find({});
console.log(userdetails);
}
//findUserDetails();


User.aggregate( [
  {
     $lookup: {
        from: "posts",
        localField: "username",    // field in the orders collection
        foreignField: "username",  // field in the items collection
        as: "username"
     }
  }
]).then((data)=>{
  console.log(JSON.stringify(data))
})
//console.log(JSON.stringify(users))