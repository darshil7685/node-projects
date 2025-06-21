const res = require("express/lib/response");
const Joi = require("joi");

function upsertSchema(req, res, next) {
  const upsertSchema = Joi.object({
    emp_id: Joi.number().allow(null),
    emp_name: Joi.string(),
    emp_salary: Joi.number(),
    emp_designation: Joi.string(),
    manager_id: Joi.number().integer(),
    obj:Joi.object({
      name:Joi.string(),
      age:Joi.number().integer()
    })
  });
  ValidateSchema(req, next, upsertSchema);
}
function getDataSchema(req,res,next){
    const getDataSchema =Joi.object({
        emp_id:Joi.number().integer().optional()
    })
    ValidateSchema(req,next,getDataSchema)
}
function deleteDataSchema(req,res,next){
    const getDataSchema =Joi.object({
        emp_id:Joi.number().integer().required()
    })
    ValidateSchema(req,next,getDataSchema)
}
function ValidateSchema(req, next, upsertSchema) {
  const options = {
    abortEarly: false,
    allowUnknown: true,
    stripUnknown: true,
  };
  const { error, value } = upsertSchema.validate(req.body, options);
  if (error) {
    console.log("validation eror ", error);
    
    throw error.details.map(x=>x.message);
  } else {
    next();
  }
}

module.exports = { upsertSchema,getDataSchema,deleteDataSchema };
