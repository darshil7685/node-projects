const mongoose = require('mongoose')

module.exports.connectDB = () => {
    mongoose.connect('mongodb://127.0.0.1:27017/furniture-api', { useNewUrlParser: true, useUnifiedTopology: true })
    console.log('database connected')
}