const dbConfig = require("./db.config.js")
const { Sequelize } = require("sequelize");
const req = require("express/lib/request");

const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
    host: dbConfig.HOST,
    dialect: dbConfig.dialect,
    pool: {
        max: dbConfig.pool.max,
        min: dbConfig.pool.min,
        acquire: dbConfig.pool.acquire,
        idle: dbConfig.pool.idle
    }
});

const db = {}

db.Sequelize = Sequelize;
db.sequelize = sequelize;

//db.User = require('../models/user.model.js')(sequelize);
db.Comment = require('../models/comment.model.js')(sequelize);
db.User = require('../models/user1.model.js')(sequelize);
// db.User.hasMany(db.Comment, { as: "comments" });
// db.Comment.belongsTo(db.User, {
//     foreignkey: "user_id",
//     as: "User"
// })

//one to many 
db.Comment.belongsTo(db.User, { foreignKey: 'userId', as: 'user' });
db.User.hasMany(db.Comment)

module.exports = db;
