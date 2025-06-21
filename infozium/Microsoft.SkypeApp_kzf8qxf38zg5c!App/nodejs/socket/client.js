const io = require("socket.io-client");
let socket = io.connect("http://localhost:3000/a");

socket.emit("create-room", "abc")

socket.emit("create-room", "abc1")
