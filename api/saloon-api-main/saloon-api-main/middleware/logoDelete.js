const fs = require('fs');


exports.deleteLogo = (file) => {
    try {
        fs.unlinkSync('public/' + file);
        return;
    } catch (err) {
        return;
    }
}