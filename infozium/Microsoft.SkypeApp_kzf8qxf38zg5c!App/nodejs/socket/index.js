const express = require("express");
const http = require("http");
const socketio = require("socket.io");
const path = require("path")
const app = express()
const server = http.createServer(app);
const io = socketio(server);

const PORT = process.env.PORT || 3000;

// const publicDirectoryPath = path.join(__dirname, './public')
// app.use(express.static(publicDirectoryPath))
// app.get('/a', (req, res) => {
//     res.sendFile(path.join(__dirname, './public/index.html'))
// })
const nsp = io.of('/a')
nsp.on("connection", async (socket) => {

    console.log("connected /a");
    console.log(socket.adapter.sids.size)
    //console.log(io.engine.clientsCount);

    socket.on("create-room", (room) => {
        const clients = socket.client.conn.emit.length;;
        console.log(clients)
        socket.join(room);
        console.log(socket.rooms);
        console.log(`room ${room} was created`);
    });
    // const rooms = io.of("/a").adapter.rooms;
    // console.log(rooms)

    socket.on("disconnect", () => {
        console.log("disconnect")
    })
})
io.of('/').on("connection", (socket) => {
    console.log("connected /");
    socket.on("create-room", (room) => {

        socket.join(room);
        console.log(socket.rooms);
        console.log(`room ${room} was created`);
    });
    const rooms = io.of("/").adapter.rooms;
    console.log(rooms)

    socket.on("disconnect", () => {
        console.log("disconnect")
    })
})
server.listen(PORT, () => {
    console.log(`server running at ${PORT}`);
})