const { DataTypes } = require("sequelize")

module.exports = (sequelize) => {
    const Comment = sequelize.define("comment", {
        comment: {
            type: DataTypes.TEXT
        }
    }, { timestamps: false })
    return Comment;
}

