const mongoose = require('mongoose')


const productSchema = new mongoose.Schema({
    product_name: { type: String },
    price: { type: Number },
    images: [{ type: String }],
    categoryId: { type: mongoose.Schema.Types.ObjectId, ref: "Category" },


}, {
    timestamps: true,
    versionKey: false
});

module.exports = mongoose.model('Product', productSchema)