const { DataTypes } = require("sequelize")

module.exports = (sequelize) => {
    const User = sequelize.define("user", {
        username: {
            type: DataTypes.STRING
        },
        email: {
            type: DataTypes.STRING,
            unique: true,
            validate: {
                isEmail: { msg: "Enter Valid Email Adress" }
            }
        },
        age: {
            type: DataTypes.JSON
        }
    }, {
        indexes: [
            { unique: true, fields: ['username'] }
        ]
    })
    return User;
}
