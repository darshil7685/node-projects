const db = require("./db/db.js")
const router = require("express").Router();
const {logger} =require("./logger")

//logger.info("hello services")
async function createUser() {

    const user = await db.User.create({ username: "abc189d5lpf", email: "abc18gfdgd2dfgd1@gmail.com", age: { 1: "abc" } });
    console.log(user);
}
//createUser();
async function createComment() {
    const user = await db.Comment.create({ comment: "abc 3", user1Id: 1 });
    console.log(user);
}
//createComment();

async function findCommentAll() {
    const comment = await db.Comment.findAll({ include: 'user', required: true });
    console.log(comment)
}
//findCommentAll()
async function findUsersAll() {
    const user = await db.User.findAll({ include: ['comments'] });
    console.log(user)
}
//findUsersAll();


router.get('/users', async (req, res,next) => {
try{
    const users = await db.User.findAll({ include: ['comments'], required: true, attributes: { exclude: ['updatedAt', 'createdAt'] } });
    //console.log(users)

    logger.info(users);
    return res.json(users);
}catch(err){
    next(err);
}
})
router.get('/comments', async (req, res,next) => {
    try{
    const comment = await db.Comment.findAll({ include: ['user'] });
    //console.log(comment)
    return res.json(comment);
    }catch(err){
        next(err);
    }
})

module.exports = router;