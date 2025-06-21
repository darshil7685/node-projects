const express = require("express");
const app = express();
const path = require("path");
const PORT = 3000
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser")
const jwt = require("jsonwebtoken")
const passport = require("passport");
const session = require("express-session");
const LocalStratergy = require('passport-local').Strategy
const GoogleStratergy = require('passport-google-oauth20').Strategy
const JwtStratergy = require("passport-jwt").Strategy;
const ExtractZJwt = require("passport-jwt").ExtractJwt

const clientId = "292689989080-6o9ai0flr1oh2n346tivkr64arbu89gl.apps.googleusercontent.com"
const clientSecret = "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"

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser())

const DATA = [{ email: "it1@infozium.in", password: "abc" }]

const printData = (req, res, next) => {
    console.log("session id " + req.session.id)
    console.log('session cookie->');
    console.log(req.session.cookie)
    next()
}
app.use(session({
    secret: "secret",
    resave: false,
    saveUninitialized: true,
}))

function FindOrCreate(user) {
    if (CheckUser(user)) {
        return user
    } else {
        DATA.push(user)
        console.log(DATA)
    }
}
function CheckUser(input) {
    for (var i in DATA) {
        if (input.email == DATA[i].email && (input.password == DATA[i].password || input.provider == DATA[i].provider))
            return true
        return false
    }
}

app.use(passport.initialize());
app.use(passport.session());
//app.use(printData)

//const authuser = (username, password, done) => {
//    for (var i in Data) {
//        if (Data[i].username == username && Data[i].password == password) {
//            return done(null, { username, password })
//        } else if (Data[i].username == username && Data[i].password !== password) {
//            return done(null, false)
//        }
//    }
//    const user = { username: username, password: password }
//    Data.push(user);
//    console.log(Data)
//    return done(null, user)
//}
//passport.use(new LocalStratergy(authuser));

var opts = {}
opts.jwtFromRequest = (req) => {
    var token = null;
    if (req && req.cookies) {
        token = req.cookies['jwt']
    }
    return token
}
opts.secretOrKey = "secret"
passport.use(new JwtStratergy(opts, function (jwt_payload, done) {
    console.log("JWT base auth called");
    console.log(jwt_payload.data)
    if (CheckUser(jwt_payload.data)) {
        console.log(jwt_payload.data)
        return done(null, jwt_payload.data)
    }
    else
        return done(null, false)
}
))

passport.use(new GoogleStratergy({
    clientID: clientId,
    clientSecret: clientSecret,
    callbackURL: "http://localhost:3000/googleRedirect",

},
    function (accessToken, refreshToken, profile, done) {
        //console.log(accessToken, refreshToken, profile)
        console.log("GOOGLE BASED OAUTH VALIDATION GETTING CALLED")
        console.log(profile)
        return done(null, profile)
    }
))

passport.serializeUser((user, done) => {
    done(null, user);
})
passport.deserializeUser((user, done) => {
    done(null, user);
})

//checkAuthenticated = (req, res, next) => {
//    if (req.isAuthenticated()) {
//        return next()
//    }
//    res.redirect("/login")
//}
//checkLoggedIn = (req, res, next) => {
//    if (req.isAuthenticated()) {
//        return res.redirect("/profile")
//    }
//    next()
//}
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname + '/public/home.html'));
})

app.get("/login", (req, res) => {
    res.sendFile(path.join(__dirname + '/public/login.html'));
})

//app.post("/login", passport.authenticate('local', {
//    successRedirect: "/profile",
//    failureRedirect: '/login',
//}))

app.post('/login', (req, res) => {
    if (CheckUser(req.body)) {
        let token = jwt.sign({ data: req.body }, 'secret', { expiresIn: '1h' });
        res.cookie('jwt', token)
        console.log(`Log in success ${req.body.email}`)
        //res.send("login successfull")
        res.redirect('/profile')
    } else {
        console.log("enter valid data")
        res.redirect('/login')
    }
})
app.get("/auth/google", passport.authenticate('google', { scope: ['profile', 'email'] }))

app.get('/googleRedirect', passport.authenticate('google', { failureRedirect: '/login' }), (req, res) => {

    let user = {
        displayName: req.user.displayName,
        name: req.user.name.givenName,
        email: req.user._json.email,
        provider: req.user.provider
    }
    console.log(user)
    FindOrCreate(user)

    let token = jwt.sign({ data: user }, 'secret', { expiresIn: '1h' });
    console.log(token)
    res.cookie('jwt', token)
    console.log(`login successfull ${req.user.displayName}`)
    res.redirect('/profile')
})

//app.get("/profile", checkAuthenticated, (req, res) => {
//console.log(req.user)
//    res.send("Welcome");
//res.sendFile(path.join(__dirname+'/public/profile.html'));
//})

app.get('/profile', passport.authenticate('jwt', { session: false }), (req, res) => {
    res.send(`Welcome  ${req.user.email}`)
})

app.get("/logout", passport.authenticate('jwt', { session: false }), (req, res) => {
    console.log(`${req.user.email} logOut`)
    res.clearCookie('jwt');

    res.redirect('/')
})

app.listen(PORT, () => {
    console.log(`Server running at ${PORT}`)
})

