const mongoose = require('mongoose')


const categorySchema = new mongoose.Schema({
    category_name: { type: String },
   slug: { type:String},
   status: { type: String,default: 'true',enum: ['true', 'false'] },
   slug: { type:String}
}, {
    timestamps: true,
    versionKey: false
});

module.exports = mongoose.model('Category', categorySchema)