const express = require('express')
const morgan = require('morgan');
const { connectDB } = require('./mongoDB');
const bodyParser = require('body-Parser');
const routes = require('./routes')
const app = express();


app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.use(morgan('dev'))
    
app.use(express.static('./public'));

/** Api middleware */
app.use('/api', routes)

/**Error middleware */
app.use((error, req, res, next) => {
    res.status(error.status || 500).json({
        status: false,
        message: error.message
    })
})


connectDB()
app.listen(3000, (req, res) => {
    console.log("server start on port 3000")
});