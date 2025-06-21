import "reflect-metadata";

import { createConnection, Brackets, SimpleConsoleLogger } from "typeorm";
import { User } from "./entity/User";
import { Admin } from "./entity/Admin";
import express, { NextFunction, Request, Response } from "express";
import { Profile } from "./entity/Profile";
import { Photo } from "./entity/Photo";
import bodyParser, { BodyParser } from "body-parser";
import { DbUtils } from "../DbUtils";
const app = express();
app.use(bodyParser.json());

app.post("/insertUser", insertUser);
app.get("/findUserById", findUser);
app.put("/updateUser", updateUser);
app.get("/getUserAndProfile", getUserAndProfile);
async function getUserAndProfile(req, res, next) {
  const { user_id } = req.body;
  const connection = await DbUtils.getConnection();
  const user = await connection
    .createQueryBuilder()
    .select(['u.id"User_Id"', "u.name'UserName'", 'p.gender"Gender"'])
    .from(User, "u")
    .leftJoin("u.profile", "p")
    .where("u.id=:id", { id: user_id })
    .getRawMany();
  if (user[0]) return res.send(user);
  else return res.send("may be data not available");
}
async function findUser(req: Request, res: Response, next: NextFunction) {
  const { user_id } = req.body;

  const connection = await DbUtils.getConnection();

  const data = await connection.manager.find(User, {
    relations: ["photos"],
    where: { id: user_id },
  });
  console.log(data);
  return res.send(data);
}
async function updateUser(req, res, next) {
  const { age, id } = req.body;
  const connection = await DbUtils.getConnection();
  const updatedData = await connection
    .createQueryBuilder()
    .update(User)
    .set({ age: age })
    .where("id=:id", { id: id })
    .execute();
  return res.send("updated");
}

async function insertUser(req, res, next) {
  const { name, password, age } = req.body;
  const connection = await DbUtils.getConnection();
  const user = new User();
  user.name = name;
  user.password = password;
  user.age = age;
  const userData = await connection.manager.save(user);
  return res.send(userData);
}

// createConnection()
//   .then((connection) => {
//     console.log("db connected");
//   })
//   .catch((error) => console.log(error));

//createConnection().then(async (connection) => {
// const user = new User();
// user.name = "a";
// user.password = "b";
// user.age = 12;
// await connection.manager.save(user);
//   const a = await connection.manager.find(User, { id: 2 });
//   await connection.manager.remove(a);
//   console.log(await connection.manager.find(User, { age: 12, name: "a" }));
//  const data = await connection
//   .getRepository(User)
//   .createQueryBuilder()
//   .update(User)
//   .set({ name: "adasd" })
//   .where({ id: 3 })
//   .execute();

// const data = await connection.getRepository(User).find();
// console.log(data);

// const admin = new Admin();
// admin.Admin_name = "admin0498845";
// admin.Admin_Role = "Admin";
// const adminn = await connection.manager.save(admin);
//const adminRepo = await connection.getRepository(Admin).save(admin);
// const adminrepo = await connection.getRepository(Admin);
// const admin1 = await adminrepo.find({ Admin_id: 6 });
// const adminDelete = await adminrepo.remove(admin1);
// console.log(adminDelete);

// const data1 = await connection
//   .createQueryBuilder()
//   .update(Admin)
//   .set({ IsActive: true })
//   .where("Admin_id= :id", { id: 8 })
//   .execute();
// console.log(data1);

// const data = await connection
//   .createQueryBuilder()
//   .select(["ad.Admin_Name", "ad.Admin_id"])
//   .from(Admin, "ad")
//   .where("ad.Admin_id IN (:...ids)", { ids: [3, 8, 9] })
//   .orderBy("ad.Admin_id", "ASC")
//   .getRawMany();
// console.log(data);
//});

//  const connection  = createConnection();
//  const data = connection.getRepository(User).find();

//Relations
//createConnection().then(async (connection) => {
//one to one
// const profile = new Profile();
// profile.gender = "male";
// profile.photo = "a.jpg";
// await connection.manager.save(profile);
// const user = new User();
// user.name = "smith";
// user.profile = profile;
// await connection.manager.save(user);
//const data = await connection.manager.find(User, { relations: ["profile"] });
//const data = await connection.manager.find(Profile, { relations: ["user"] });
// const users = await connection
//   .getRepository(User)
//   .createQueryBuilder("user")
//   .leftJoinAndSelect("user.profile", "profile")
//   .getMany();
// const profiles = await connection
//   .getRepository(Profile)
//   .createQueryBuilder("profile")
//   .leftJoinAndSelect("profile.user", "user")
//   .getMany();
// const profile1 = await connection
//   .getRepository(Profile)
//   .find(); /* this work only on find method eager:true in schemas*/
// console.log(profile1);
//one to many many to one
// const photo1 = new Photo();
// photo1.title = "a";
// await connection.manager.save(photo1);
// const photo2 = new Photo();
// photo2.title = "b";
// await connection.manager.save(photo2);
// const user = new User();
// user.name = "allen";
// user.photos = [photo1, photo2];
// await connection.manager.save(user);
// const users = await connection
//   .getRepository(User)
//   .find({ relations: ["photos", "profile"] });
// const photo = await connection
//   .getRepository(Photo)
//   .find({ relations: ["user"] });
// console.log(users);
//   const photoCount = await connection
//     .getRepository(Photo)
//     .createQueryBuilder("photo")
//     .select("photo.userId")
//     .addSelect("COUNT(photo.title)", "images")
//     .groupBy("photo.userId")
//     .getRawMany();
//   console.log(photoCount);
//working with relations add and remove data
// const photo2 = new Photo();
// photo2.title = "b";
// await connection.manager.save(photo2);
// const postRepository = connection.getRepository(User);
// const post = await postRepository.findOne(3, { relations: ["photos"] });
// post.photos.push(photo2);
// const dta = await postRepository.save(post);
// console.log(dta);
//using queryBuilder
//add and remove only on many to many and one to many
// const data = await connection
//   .createQueryBuilder()
//   .relation(User, "photos")
//   .of(3)
//   .add(photo2);
// await connection
//   .createQueryBuilder()
//   .relation(User, "photos")
//   .of(3)
//   .remove(16);
//set and set null for one to one and many to one
// const profile = new Profile();
// profile.gender = "male";
// profile.photo = "a.jpg";
// await connection.manager.save(profile);
// const data1 = await connection
//   .createQueryBuilder()
//   .relation(User, "profile")
//   .of(3)
//   .set(profile);
// await connection.createQueryBuilder().relation(User, "profile").of(8).set(11);
// await connection
//   .createQueryBuilder()
//   .relation(User, "profile")
//   .of(18)
//   .set(null);
//});

//Query Builder Select,insert,update,delete
//createConnection()
//  .then(async (Connection) => {
//SelectQueryBuilder
//get sigle user
// const singleUser = await Connection.createQueryBuilder()
//   .select("user")
//   .from(User, "user")
//   .where("user.id=5")
//   .getOne();
// const oneUser = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.id=:id", { id: 6 })
//   .getOne();
// const user = await Connection.manager
//   .createQueryBuilder(User, "user")
//   .where("user.id=8")
//   .getOne();
//get all users from table
// const users = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .getMany();
// console.log(users);
//where
// const smith = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.name=:name", { name: "smith" })
//   .orWhere("user.id=18")
//   .getOne();
// const allen = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.name=:name AND user.id=:id ", { name: "allen", id: 12 })
//   .getOne();
// const idsUser = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.id IN (:...ids)", { ids: [4, 6, 11] })
//   .getMany();
// const smith = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.name=:name", { name: "smith" })
//   .andWhere(
//     new Brackets((qb) => {
//       qb.where("user.id=4").orWhere("user.id=18");
//     })
//   )
//   .getOne();
//orderBy
// const inOrder = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.id IN (:...ids)", { ids: [4, 6, 11] })
//   .orderBy({ "user.id": "DESC", "user.name": "ASC" })
//   .getMany();
// const Order = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .where("user.id IN (:...ids)", { ids: [4, 6, 11] })
//   .orderBy("user.id", "ASC")
//   .offset(1)
//   .limit(3)
//   .getMany();
//relations joins
// const userLeftJoin = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .leftJoinAndSelect("user.photos", "photo", "photo.title=:title", {
//     title: "a",
//   })
//   .where("user.name=:name", { name: "allen" })
//   .getMany();
// const userInnerJoin = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .innerJoinAndSelect("user.photos", "photo", "photo.title=:title", {
//     title: "a",
//   })
//   .where("user.name=:name", { name: "allen" })
//   .getMany();
//if user has photo than return user not photos
// const user = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .innerJoin("user.photos", "photo")
//   .where("user.id=8")
//   .getOne();
// const users = await Connection.getRepository(User)
//   .createQueryBuilder("user")
//   .leftJoinAndSelect(Photo, "photo", "photo.userId=user.id")
//   .useIndex("my_index")
//   .skip(15)
//   .take(25)
//   .getMany();
//sub query
// const photos = await Connection.createQueryBuilder()
//   .select("photo.id", "id")
//   .addSelect((subQuery) => {
//     return subQuery.select("user.name", "name").from(User, "user").limit(1);
//   }, "name")
//   .from(Photo, "photo")
//   .orderBy("photo.id", "ASC")
//   .getRawMany();
//insert,update,delete
// await Connection.createQueryBuilder()
//   .insert()
//   .into(User)
//   .values([{ name: "jeff" }, { name: "abx" }])
//   .execute();
// await Connection.createQueryBuilder()
//   .update(User)
//   .set({ name: "jeff" })
//   .where("id=4")
//   .execute();
// await Connection.createQueryBuilder()
//   .delete()
//   .from(User)
//   .where("id=4")
//   .execute();

// })
// .catch((err) => {
//   console.log("Error in databse connection", err);
// });

app.listen(8000, () => {
  console.log("Server running at 8000");
});
