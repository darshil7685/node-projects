import {
  Column,
  MigrationInterface,
  QueryRunner,
  Table,
  TableColumn,
} from "typeorm";

export class test1643430543618 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // await queryRunner.query("ALTER TABLE `Admin` ADD `Token` VARCHAR(50)");
    await queryRunner.addColumn(
      "Admin",
      new TableColumn({
        name: "Token",
        type: "VARCHAR(50)",
        default: null,
      })
    );
    await queryRunner.createTable(
      new Table({
        name: "Wallet",
        columns: [
          {
            name: "id",
            type: "int",
            isPrimary: true,
          },
          {
            name: "name",
            type: "varchar",
          },
        ],
      }),
      true
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query("ALTER TABLE `Admin` DROP `Token`");
  }
}
