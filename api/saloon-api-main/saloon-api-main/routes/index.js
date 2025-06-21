

const express = require("express");
const router = express.Router();
const userRoutes = require("./userRoutes");
const shopRoutes = require("./shopRoutes");
const customerRoutes = require("./customerRoutes");
const servicesRoutes = require("./servicesRoutes");
const appointmentRoutes = require("./appointmentRoutes");

router.use('/user',userRoutes)
router.use('/shop',shopRoutes)
router.use('/customer',customerRoutes)
router.use('/services',servicesRoutes)
router.use('/appointment',appointmentRoutes)


module.exports = router; 
