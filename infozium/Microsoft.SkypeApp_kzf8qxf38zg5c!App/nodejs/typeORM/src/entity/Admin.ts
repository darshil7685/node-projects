import { Entity, PrimaryGeneratedColumn, Column, BaseEntity } from "typeorm";

@Entity({ name: "Admin" })
export class Admin extends BaseEntity {
  @PrimaryGeneratedColumn({ type: "int" })
  Admin_id: number;

  @Column({ type: "varchar", unique: true })
  Admin_name: string;

  @Column({ type: "enum", enum: ["Admin", "SubAdmin"], default: "SubAdmin" })
  Admin_Role: string;

  @Column({ default: true })
  IsActive: boolean;

  @Column({ default: 0 })
  Age: number;
}
