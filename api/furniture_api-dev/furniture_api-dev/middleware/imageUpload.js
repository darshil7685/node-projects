const multer = require("multer");
let productImage;
try {
  productImage = multer({
    storage: multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, "public/productImages");
      },
      filename: function (req, file, cb) {
        const ext = file.originalname.split(".");
        cb(null, +Date.now() + "." + ext[ext.length - 1]);
      },
    }),
  });
} catch (err) {
  throw err;
}

module.exports = { productImage };
