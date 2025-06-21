const express = require("express");
const router = express.Router();

const { appointmentsAdd,appointmentsUpdate,appointmentsdelete,appointmentsget } = require("../controller/appointmentBook");
const { appointmentsAddValidator,appointmentsUpdateValidator } = require("../validators/appointmentValidators");

const { isCustomer } = require("../middleware/jwtMiddleware");


router.post( "/appointments-add",isCustomer,appointmentsAddValidator,appointmentsAdd);
router.put("/appointments-update/:_id",isCustomer,appointmentsUpdateValidator,appointmentsUpdate);
router.put("/appointments-delete/:_id",isCustomer,appointmentsdelete);

module.exports = router;
