import joi from "joi";

let schema = joi.object({
  a: joi.string(),
  b: joi.number(),
  c: joi.number(),
}).or('a','b')

let obj = { b: -5 };
let result = schema.validate(obj);
console.log("result", result);

// let result = customValidation(obj, schema);

// function customValidation(obj, schema) {
//   let result = schema.validate(obj);
//   let isAorB;
//   if (result.error) {
//     isAorB = result.error.details.some((detail) => {
//       return detail.path.length === 1 && ["a", "b"].includes(detail.path[0]);
//     });
//     if(isAorB) return result
//   }
//     return joi.object({
//         a: joi.string().required(),
//         b: joi.number().required(),
//         c: joi.number(),
//       })
//       .validate(obj);  
// }


let a={
  "type":"IT",
  "resources":{
    "it_frontend_developer":{
      "react":1,
      "angular":5
    },
    "it_backend_developer":{
      "node":5,
      "java":15
    },
    "it_fullstack_developer":{
      "node":1,
      "angular":5
    }
  }
}

function renameKeys(obj, oldKeyPrefix, newKeyPrefix) {
  const updatedObj = {};
  for (const key in obj) {
    console.log("-----",key,obj);
    if (key.startsWith(oldKeyPrefix)) {
      const newKey = key.replace(oldKeyPrefix, newKeyPrefix);
      updatedObj[newKey] = obj[key];
    } else {
      updatedObj[key] = obj[key];
    }
  }
  return updatedObj;
}

const updatedResources = renameKeys([], 'it_', 'comp_');

// Update the document with the modified 'resources' object
a.resources = updatedResources;
console.log(updatedResources)


