const db = require("../../models");
const AWB = db.awbs;

const readXlsxFile = require("read-excel-file/node");
const excel = require("exceljs");

const upload = async (req, res) => {
  try {
    if (req.file == undefined) {
      return res.status(400).send("Please upload an excel file!");
    }

    let path =
      __basedir + "/resources/static/assets/uploads/" + req.file.filename;

    readXlsxFile(path).then((rows) => {
      // skip header
      rows.shift();

      let awbs = [];

      rows.forEach((row) => {
        let awb = {
          id: row[0],
          awb_number: row[1],
        };

        awbs.push(awb);
      });

      AWB.bulkCreate(awbs)
        .then(() => {
          res.status(200).send({
            message: "Uploaded the file successfully: " + req.file.originalname,
          });
        })
        .catch((error) => {
          res.status(500).send({
            message: "Fail to import data into database!",
            error: error.message,
          });
        });
    });
  } catch (error) {
    console.log(error);
    res.status(500).send({
      message: "Could not upload the file: " + req.file.originalname,
    });
  }
};

const getAwbs = (req, res) => {
  AWB.findAll()
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving awbs.",
      });
    });
};

const download = (req, res) => {
  AWB.findAll().then((objs) => {
    let awbs = [];

    objs.forEach((obj) => {
      awbs.push({
        id: obj.id,
        awb_number: obj.awb_number,
      });
    });

    let workbook = new excel.Workbook();
    let worksheet = workbook.addWorksheet("AWBS");

    worksheet.columns = [
      { header: "Id", key: "id", width: 5 },
      { header: "awb_number", key: "title", width: 25 },
    ];

    // Add Array Rows
    worksheet.addRows(awbs);

    res.setHeader(
      "Content-Type",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    );
    res.setHeader(
      "Content-Disposition",
      "attachment; filename=" + "awbs.xlsx"
    );

    return workbook.xlsx.write(res).then(function () {
      res.status(200).end();
    });
  });
};

module.exports = {
  upload,
  getAwbs,
  download,
};
