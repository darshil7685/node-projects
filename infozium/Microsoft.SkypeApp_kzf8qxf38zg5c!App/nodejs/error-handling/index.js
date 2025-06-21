const express = require("express");

const app = express();
const PORT = 8000;
const bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

class AppError extends Error {
  
  constructor(statuscode, message) {
    super();
    this.statuscode = statuscode;
    this.message = message;
  }
}

const errorHandler = (err, res) => {
  if (err instanceof AppError) {
    const { statuscode, message } = err;
    return res.status(statuscode).send({ errors: message });
  } else {
    return res.status(400).send({
      errors: "Something Went Wrong",
    });
  }
};

const validateUser = async (req, res, next) => {
  try {
    const username = await req.body.username;

    if (!username) {
      throw new AppError(500, "please enter username");
    }
    if (username !== "abc") {
      throw new AppError(500, "Enter correct username");
    }
    next();
  } catch (error) {
    next(error);
  }
};

app.get("/", validateUser, (req, res) => {
  res.send(req.body.username);
});
app.get("/error", (req, res) => {
  throw new AppError(404, "Error");
});
app.get("/user", (req, res, next) => {
  try {
    if (req.body.username) {
      return res.json(username);
    } else {
      throw new AppError(403, "Provide username");
    }
  } catch (err) {
    next(err);
  }
});
app.all("*", (req, res) => {
  throw new AppError(404, "Path not found");
});
app.use((err, req, res, next) => {
  errorHandler(err, res);
});

app.listen(PORT, () => {
  console.log(`server running at ${PORT}`);
});
