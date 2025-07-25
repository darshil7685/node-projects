const express = require("express");
const app = express();
const db = require("./models");
const bodyParser = require('body-parser');
const initRoutes = require("./routes/awb.routes");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
global.__basedir = __dirname + "/..";

app.use(express.urlencoded({ extended: true }));
initRoutes(app);

db.sequelize.sync();
// db.sequelize.sync({ force: true }).then(() => {
//   console.log("Drop and re-sync db.");
// });

let port = 8080;
app.listen(port, () => {
  console.log(`Running at localhost:${port}`);
});
