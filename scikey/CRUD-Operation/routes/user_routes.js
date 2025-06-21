const {getEmployeeData,deleteEmployee, upsertEmployee,mailto}=require('../controllers/user_controllers')
const{upsertSchema,getDataSchema,deleteDataSchema}=require('../validators/validators')
const express=require("express")
const router =express.Router();

router.get('/getEmployeeData',getDataSchema, getEmployeeData)
router.delete('/deleteEmployee',deleteDataSchema,deleteEmployee)
router.post('/upsertEmployee',upsertSchema,upsertEmployee)
router.post('/mailto',mailto)
module.exports=router