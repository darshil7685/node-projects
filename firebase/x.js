let a = [
  {
    stoneid: "123456kmlkmklklkml",
    lcode: "12345",
    rfid: "12345",
    shape: "A",
  },
  {
    stoneid: "hkbhjbhjbhjvg",
    lcode: "12345",
    rfid: "12345",
    shape: "A",
  },
];

// a.forEach(async (obj) => {
//   await ab(obj, (err, result) => {
//     console.log(result);
//   });
// });

// function ab(obj, callback) {
//   return callback(null, obj);
// }

// ([[1,2,3],[5,6,7]]).forEach(([m,value,n])=>{
//   console.log(m,value,n);
// })

let result = a.map((obj, index) => {
  return obj;
});

// console.log(result);

const obj1 = { a: 1, b: 2 };
const obj2 = { c: 3, d: 4 };
const obj3 = { e: 5, f: 6 };
const mergedObj = [obj1, obj2, obj3].reduce((acc, curr) => {
  // console.log("acc",acc,"curr",curr)
  return { ...acc, ...curr };
}, {});

// console.log(mergedObj); // { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 }

const numbers = [1, 2, 3, 4, 5];

const sum = numbers.reduce((total, currentValue) => {
  return total + currentValue;
}, 0);

// console.log(sum); // 15

const obj = [
  {
    x: 1,
    y: 2,
  },
  {
    x: 1,
    z: 4,
  },
  {
    x: 2,
    a: 1,
  },
  {
    x: 2,
    p: 88,
  },
];
let op = [];
const merge = obj.map((ele, idx) => {
  let existIndex;
  existIndex = op.findIndex((itm) => itm.x == ele.x);
  if (existIndex !== -1) {
    op[existIndex] = { ...op[existIndex], ...ele };
  } else {
    op.push(ele);
  }
  // console.log("op",op);
});
// console.log("obj", op);

let p = {
  // data:{
  //   a:{
  //     b:[12,58]
  //   }
  // }
};

// console.log((p.data?.length)?p.data.length:10)
// console.log(p.data?.bp?.length)

let q = [1, 2, 3, 4, 5];

q.splice(0, q.length);
// console.log(q)

let w = [7, 8, 9, 0, 1, 2, 3, 4];
let re = w.slice(0, 2);
// console.log(re);
// console.log(w.concat(w))

function mul(x) {
  return function (y) {
    return x * y;
  };
}

// console.log(mul(2)(3))

const sum1 = (x) => (y) => (z) => x + y + z;
// console.log(sum1(1)(2)(3));

const ob = [{ a: 1 }, { a: 1 }, { b: 2 }];
const result1 = ob.reduce((result, ele, idx) => {
  console.log("result", result, ele, idx);
  result[idx] = idx;
  return result;
}, {});

console.log(result1);



