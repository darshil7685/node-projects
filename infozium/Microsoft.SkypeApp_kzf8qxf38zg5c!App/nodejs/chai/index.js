var express = require('express')
var app = express()
let chai = require('chai');
let chaiHttp = require('chai-http');
// const {
//     expect
// } = require('chai');
var expect = require('chai').expect;
let should = chai.should();

chai.use(chaiHttp);
describe('app', () => {
    describe('api testing', () => {

        it('should return in json format ', (done) => {
            chai.request(app).get('/data')
                .end((err, res) => {
                    if (err) done(err);
                    res.should.to.be.json;
                    res.should.have.status(200);
                    done();
                })
        })

    })
})

app.get('/data', function (req, res) {
    return res.status(200).json({
        a: "a",
        b: "b"
    })
})


app.listen(8080, function () {
    console.log('App listening on port 8080!')
})