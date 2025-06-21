const func =require('../func')
module.exports = {
  async up(db) {
    const result = await db
      .collection("practice")
      .findOne({ config_type: "super_config" });

      const result1=func.pushEle(result.values,{ PQR: "11111111111", ABC: 123456789 })
    // result.values.push({ PQR: "11111111111", ABC: 123456789 });
    // const result = { values: { abcdefghijk: 234323432 } };
    await db.collection("practice").updateOne(
      { config_type: "super_config" },
      {
        $set: {
          values: result1
        }
      }
    );
  },
};
