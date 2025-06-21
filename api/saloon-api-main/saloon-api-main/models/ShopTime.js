const mongoose = require("mongoose");

const timeSchema = new mongoose.Schema(
  {
    day : { type: String,enum:["sunday","monday","tuesday","wednesday","thursday","friday","saturday"] },
    opentime : {type: String},
    closetime : {type: String},
    shop: { type: mongoose.Schema.Types.ObjectId, ref: "Shop" },

  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model("shopTime", timeSchema);
