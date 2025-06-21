
const express = require('express')
const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser')
const app = express()

const { login, refresh } = require('./authentication')

app.use(bodyParser.json())
app.use(cookieParser())
const { verify } = require('./middleware')


ACCESS_TOKEN_SECRET = "swsh23hjddnns"
ACCESS_TOKEN_LIFE = 1200
REFRESH_TOKEN_SECRET = "dhw782wujnd99ahmmakhanjkajikhiwn2n"
REFRESH_TOKEN_LIFE = 86400

app.post('/login', login)
app.post('/refresh', verify, refresh)
app.get('/data', verify, (req, res) => {
    res.status(400).send("You can access data");
})
app.listen(3000, () => {
    console.log("server running")
})