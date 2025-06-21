const mongoose = require("mongoose");

var userDetailsSchema = mongoose.Schema({
  user_id: { type: Number, unique: true },
  champion_index: { type: Number },
  champion_purchased: { type: Boolean },
  bodytypelist: [
    {
      SelectbodyType: String,
      CurrentType: String,
      HasColorChangeOption: { type: String, default: false },
    },
  ],
});

// userDetailsSchema.plugin(autoIncrement.plugin, {
//     model: 'UserDetails',
//     field: 'user_id'
// });
module.exports = new mongoose.model("UserDetails", userDetailsSchema);
