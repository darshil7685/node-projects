const mongoose = require('mongoose')

module.exports.connectDB = () => {
    mongoose.connect('mongodb://127.0.0.1:27017/saloon_App', { useNewUrlParser: true, useUnifiedTopology: true })
    console.log('database connected')
}