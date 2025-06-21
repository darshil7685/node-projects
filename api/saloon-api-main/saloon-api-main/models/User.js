const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    email: { type: String },
    password: { type: String, select: false },
    full_name: { type: String },
    address: { type: String },
    phon_number: { type: Number },
    user_type: { type: String,enum:["admin","shop_user","customer"]}
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model("User", userSchema);
