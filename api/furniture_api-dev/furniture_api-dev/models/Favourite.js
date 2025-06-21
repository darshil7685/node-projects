const mongoose = require('mongoose')


const favouriteSchema = new mongoose.Schema({
   productId: { type: mongoose.Schema.Types.ObjectId, ref: "Product" },
   userId : { type: mongoose.Schema.Types.ObjectId, ref: "Category" },

}, {
    timestamps: true,
    versionKey: false
});

module.exports = mongoose.model('Favourite', favouriteSchema)