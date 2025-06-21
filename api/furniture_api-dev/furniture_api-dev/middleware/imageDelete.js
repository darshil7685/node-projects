const fs = require('fs');


exports.deleteImage = (file) => {
    try {
        fs.unlinkSync('public/' + file);
        return;
    } catch (err) {
        return;
    }
}