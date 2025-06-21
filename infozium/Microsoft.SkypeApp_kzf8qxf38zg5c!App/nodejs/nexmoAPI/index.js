const Nexmo = require('nexmo');

const nexmo = new Nexmo({
    apiKey: '3761f4c2',
    apiSecret: 'A1KXzwa0CPUKXBbI',
    applicationId: "b8b00dd1-f11e-4db1-b007-c1cb7051024e",
    signatureSecret: "pml6Hb9uqYYiNTC1UA7GzpQt8drsc3DDzyragG63alprJEexEv",
    privateKey: './key/private.key'
});

nexmo.calls.create({
    to: [{
        type: 'phone',
        number: "919824470182"
    }],
    from: {
        type: 'phone',
        number: "919824470182"
    },
    ncco: [{
        "action": "talk",
        "text": "This is a text to speech call from Me"
    }]
}, (error, response) => {
    if (error) console.log(error)
    if (response) console.log(response)
})

// const from = 'Nexmo';
// const to = '919824470182';
// const text = 'Hii';

// nexmo.message.sendSms(from, to, text,
//     function (error, result) {

//         if (error) {
//             console.log("ERROR", error)
//         }

//         else {
//             console.log("RESULT", result)
//         }
//     });