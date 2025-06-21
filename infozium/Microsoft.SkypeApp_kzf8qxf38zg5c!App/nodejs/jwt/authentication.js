const jwt = require("jsonwebtoken")

const ACCESS_TOKEN_SECRET = "abcd"
const ACCESS_TOKEN_LIFE = "1h"
const REFRESH_TOKEN_SECRET = "abcdefgh"
const REFRESH_TOKEN_LIFE = "7d"

let users = {
    abc: { password: "abc" },
    xyz: { password: "xyz" }
}

exports.login = (req, res) => {

    let username = req.body.username
    let password = req.body.password

    if (!username || !password || users[username].password !== password) {
        return res.status(401).send("username or password required")
    }

    let payload1 = { username: username }

    let accessToken = jwt.sign(payload1, ACCESS_TOKEN_SECRET, {
        expiresIn: ACCESS_TOKEN_LIFE
    })

    let refreshToken = jwt.sign(payload1, REFRESH_TOKEN_SECRET, {
        expiresIn: REFRESH_TOKEN_LIFE
    })

    users[username].refreshToken = refreshToken
    users[username].accessToken = accessToken

    //console.log(users[username].refreshToken)

    return res.send({ accessToken: accessToken, refreshToken: refreshToken })
}

exports.refresh = (req, res) => {

    let accessToken = req.headers.token;

    if (!accessToken) {
        return res.status(403).send("access token not in request")
    }

    let payload
    try {
        payload = jwt.verify(accessToken, ACCESS_TOKEN_SECRET)
    }
    catch (e) {
        return res.status(401).send("could not verify accesstoken")
    }

    let refreshToken = users[payload.username].refreshToken
    //console.log(users[payload.username]);

    //console.log("fetched refresh token :", refreshToken)

    try {
        jwt.verify(refreshToken, REFRESH_TOKEN_SECRET);
    }
    catch (e) {
        return res.status(401).send("could not verify refreshtoken")
    }
    const username = payload.username

    let newAccessToken = jwt.sign({ username: username }, ACCESS_TOKEN_SECRET,
        {
            expiresIn: ACCESS_TOKEN_LIFE
        })

    users[username].accessToken = newAccessToken
    console.log(users[username])


    return res.status(200).send({ newAcessToken: newAccessToken })
}

