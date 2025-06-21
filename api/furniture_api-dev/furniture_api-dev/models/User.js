const mongoose = require('mongoose')


const userSchema = new mongoose.Schema({
    phone_number: { type: Number },
    email: { type: String },
    gender: { type: String, enum: ['male', 'female', 'others'] },
    password: { type: String, select: false },
    user_type: { type: String,enum:["user","customer"]}
}, {
    timestamps: true,
    versionKey: false
});

module.exports = mongoose.model('User', userSchema)