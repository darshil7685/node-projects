const { DataTypes } = require("sequelize")

module.exports = (sequelize) => {
    const User = sequelize.define("user1", {
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
    }, { timestamps: false })
    return User;
}

