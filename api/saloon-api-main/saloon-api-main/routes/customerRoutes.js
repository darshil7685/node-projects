const express = require("express");
const router = express.Router();

const {
  customerGetProfile,
  deleteCustomer,
} = require("../controller/customerController");
const { appointmentsget } = require("../controller/appointmentBook");
const { isCustomer } = require("../middleware/jwtMiddleware");

router.get("/customer-get", customerGetProfile);
router.delete("/delete-customer/:_id", deleteCustomer);
router.get("/appointment-get", isCustomer, appointmentsget);

module.exports = router;
