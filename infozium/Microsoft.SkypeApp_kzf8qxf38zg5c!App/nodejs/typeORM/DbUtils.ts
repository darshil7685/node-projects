import "reflect-metadata";
import { createConnection } from "typeorm";

export class DbUtils {
  static connection: any = null;

  static connect = async () => {
    try {
      const conn = await createConnection();
      return conn;
    } catch (error) {
      console.log("Erorr while connnecting Database", error);
    }
  };
  static getConnection = async () => {
    if (!DbUtils.connection) {
      DbUtils.connection = await DbUtils.connect();
    }
    return DbUtils.connection;
  };
}
