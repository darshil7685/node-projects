const mongoose = require("mongoose");

const appointmentSchema = new mongoose.Schema(
  {
    start_time: { type: String },
    end_time: { type: String },
    date: { type: Date },
    serviceId: { type: mongoose.Schema.Types.ObjectId, ref: "Services" },
    customerId: { type: mongoose.Schema.Types.ObjectId, ref: "Customer" },
    status: {
      type: String,
      default: "pending",
      enum: ["pending", "completed", "cancelled"],
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model("Appointment", appointmentSchema);
