let data = [
  {
    stoneid: 1,
    certificate_short_name: "Non-Cert",
    is_polish_changed: "#F6A77A",
    is_symmetry_changed: "#F6A77A",
    is_fluorescence_changed: null,
    is_color_changed: null,
    is_clarity_changed: null,
  },
  {
    stoneid: 2,
    certificate_short_name: "Non-Cert",
    is_polish_changed: "#F6A77A",
    is_symmetry_changed: null,
    is_fluorescence_changed: "#45",
    is_color_changed: null,
    is_clarity_changed: null,
  },
  {
    stoneid: 3,
    certificate_short_name: "Non-Cert",
    is_polish_changed: "#F6A77A",
    is_symmetry_changed: "#F6A77A",
    is_fluorescence_changed: "#F6A77A",
    is_color_changed: null,
    is_clarity_changed: null,
  },
  {
    stoneid: 4,
    certificate_short_name: "Non-Cert",
    is_polish_changed: null,
    is_symmetry_changed: "#F6A77A",
    is_fluorescence_changed: null,
    is_color_changed: null,
    is_clarity_changed: null,
  },
  {
    stoneid: 5,
    certificate_short_name: "Non-Cert",
    is_polish_changed: "#F3C352",
    is_symmetry_changed: "#F6A77A",
    is_fluorescence_changed: "#F6A77A",
    is_color_changed: "#F3C352",
    is_clarity_changed: null,
  },
  ,
  {
    stoneid: 6,
    certificate_short_name: "Non-Cert",
    is_polish_changed: null,
    is_symmetry_changed: "#F3C352",
    is_fluorescence_changed: null,
    is_color_changed: null,
    is_clarity_changed: null,
  },
  {
    stoneid: 7,
    certificate_short_name: "Non-Cert",
    is_polish_changed: "#F6A77A",
    is_symmetry_changed: "#F6A77A",
    is_fluorescence_changed: "#F6A77A",
    is_color_changed: "#F6A77A",
    is_clarity_changed: "#F6A77A",
  },
  {
    stoneid: 8,
    certificate_short_name: "Non-Cert",
    is_polish_changed: null,
    is_symmetry_changed: null,
    is_fluorescence_changed: null,
    is_color_changed: null,
    is_clarity_changed: null,
  },
];
let mappingJson = {
  upgraded: "#8FE4A3",
  double_upgraded: "#ADFF2F",
  degraded: "#F6A77A",
  double_degraded: "#F3C352",
  ok: "#fffb00",
};
let result_type = "degraded";
let parameters = [
  "is_polish_changed",
  "is_symmetry_changed",
  "is_fluorescence_changed",
  "is_color_changed",
  "is_clarity_changed",
];
let value_type = [
  "is_polish_changed",
  "is_color_changed",
  "is_clarity_changed",
];

let mappedResultType = mappingJson[result_type];

let filteredData = data.filter((item) => {
  if (result_type == "ok") {
    return parameters.every((param) => item[param] == null);
  } else {
    let valueTypeExists = value_type.every(
      (prop) => item[prop] == mappedResultType || item[prop] == null
    );
    let parameterExists = value_type.some((prop) => item[prop] !== null);
    console.log("valueTypeExists", valueTypeExists);
    let otherParametersNull = parameters
      .filter((param) => !value_type.includes(param))
      .every((param) => item[param] === null);
    //   console.log("otherParametersNull",otherParametersNull);
    return valueTypeExists && otherParametersNull && parameterExists;
  }
});

console.log(filteredData);
// filter the json from data
// first get the mapped value from result_type to mappingJson
// if value of value_type either json has  is_polish_changed, is_symmetry_changed or either both is_polish_changed,is_symmetry_changed
// and other parameter from parameters excpet value_type should be null
