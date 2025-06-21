const express = require("express");
const path = require("path");
const http = require("http");
const socketio = require("socket.io");
const Filter = require("bad-words");
const { generateMessage } = require("./utils/messages.js")
const { addUser, getUser, getUsersInRoom, removeUser, users } = require("./utils/users.js")

const app = express()
const server = http.createServer(app)
const io = socketio(server)

const publicDirectoryPath = path.join(__dirname, './public')

app.use(express.static(publicDirectoryPath))


io.on("connection", (socket) => {
    console.log("connected");

    //socket.emit('message',generateMessage('Welcome !'));
    //socket.broadcast.emit('message',generateMessage("A new user connected"));
    socket.on('join', (options, callback) => {
        const { room } = options;
        const userRoom = users.filter((user) => user.room === room);
        if (userRoom.length == 3) {
            return callback("This room is full,Try another room!")
        }
        const { error, user } = addUser({ id: socket.id, ...options })
        if (error) {
            return callback(error)
        }

        socket.join(user.room)

        socket.emit('message', generateMessage('Admin', 'Welcome !'));
        socket.broadcast.to(user.room).emit('message', generateMessage('Admin', `${user.username} has joined chat`));

        io.to(user.room).emit("roomData", {
            room: user.room,
            users: getUsersInRoom(user.room)
        })

        callback()
    })

    socket.on('sendMessage', (msg, callback) => {
        const user = getUser(socket.id)
        const filter = new Filter()
        if (filter.isProfane(msg)) {
            return callback('Profanity is not allowed')
        }
        io.to(user.room).emit('message', generateMessage(user.username, msg))
        callback()
    })
    socket.on('disconnect', () => {
        const user = removeUser(socket.id)
        if (user) {
            io.to(user.room).emit('message', generateMessage('Admin', `${user.username} has left!`))
            io.to(user.room).emit('roomData', {
                room: user.room,
                users: getUsersInRoom(user.room)
            })
        }
    })
})

server.listen(8080, () => {
    console.log("Server running at port 8080");
})