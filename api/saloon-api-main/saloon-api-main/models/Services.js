const mongoose = require("mongoose");

const services_userSchema = new mongoose.Schema(
  {
    services_name: { type: String },
    services_time: { type: Number },
    services_charges: { type: Number },
    shopId: { type: mongoose.Schema.Types.ObjectId, ref: "Shop" },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model("Services", services_userSchema);
