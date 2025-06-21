const mongoose = require("mongoose");

const shop_userSchema = new mongoose.Schema(
  {
    shop_name: { type: String },
    shop_address: { type: String },
    pincode: { type: Number },
    logo: { type: String },
    phon_number: { type: Number },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model("Shop", shop_userSchema);
