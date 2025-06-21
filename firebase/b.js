// import crypto from 'crypto-js'
// import bcrypt from 'bcryptjs'
// const crypto = require("crypto-js")

// const key = "12345";
// const plainText = "Hello, world!"

// const encrypted = crypto.AES.encrypt(plainText, key);
// // console.log(encrypted);
// const decrypted = crypto.AES.decrypt(encrypted, key).toString(crypto.enc.Utf8);

// console.log(decrypted)

// Node.js program to demonstrate the	
// crypto.createDecipheriv() method

// Includes crypto module
import crypto from 'crypto'
// The data to be decrypted, encoded as a base64 string
const encryptedData = 'ZW5jcnlwdGVkRGF0YQ==';
// The secret key used to encrypt the data
const key = Buffer.from('mySecretKey', 'utf8');
// The initialization vector (IV) used to encrypt the data
const iv = Buffer.from('myIV', 'utf8');
// Create a Decipher object using the AES-256-CBC algorithm
const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
// Decrypt the data
const decrypted = decipher.update(encryptedData, 'base64', 'utf8');
decrypted += decipher.final('utf8');
console.log(decrypted); // Output: "decryptedData"

