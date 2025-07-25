const winston=require("winston");


 const  logger = winston.createLogger({
    level: 'info',
    format: winston.format.simple(),
    //format: winston.format.json(),
    defaultMeta: { service: 'user-service' },
    transports: [
      //
      // - Write all logs with level `error` and below to `error.log`
      // - Write all logs with level `info` and below to `combined.log`
      //
      // new winston.transports.File({ filename: 'error.log', level: 'error' }),
      // new winston.transports.File({ filename: 'combined.log' }),
      new winston.transports.Console()
    ],
  });
logger.info("log")
  module.exports = {logger};