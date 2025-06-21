import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  BaseEntity,
  OneToOne,
  JoinColumn,
  OneToMany,
} from "typeorm";
import { Photo } from "./Photo";
import { Profile } from "./Profile";

@Entity({ name: "User" })
export class User extends BaseEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ default: "" })
  password: string;

  @Column({ default: 0 })
  age: number;

  @OneToOne((type) => Profile, (profile) => profile.user)
  @JoinColumn()
  profile: Profile;

  @OneToMany((type) => Photo, (photo) => photo.user)
  @JoinColumn()
  photos: Photo[];
}
