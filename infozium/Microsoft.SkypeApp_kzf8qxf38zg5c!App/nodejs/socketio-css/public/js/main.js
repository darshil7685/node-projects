const chatForm = document.getElementById('chat-form');
const chatMessages = document.querySelector('.chat-messages');
const roomName = document.getElementById('room-name');
const userList = document.getElementById('users');

const { username, room } = Qs.parse(location.search, {
    ignoreQueryPrefix: true,
});
const socket = io();
// const $messsageForm = document.querySelector('#message-form')
// const $messageFormInput = $messsageForm.querySelector('input')
// const $messageFormButton = $messsageForm.querySelector('button')
// const $messages = document.querySelector("#messages")
// const { username, room } = Qs.parse(location.search, { ignoreQueryPrefix: true })

// const sidebarTemplate = document.querySelector("#sidebar-template").innerHTML;
// const messageTemplate = document.querySelector("#message-template").innerHTML

// const autoscroll = () => {
//     const $newMessage = $messages.lastElementChild

//     //Height of the new message
//     const newMessageStyles = getComputedStyle($newMessage)
//     const newMessageMargin = parseInt(newMessageStyles.marginBottom)
//     const newMessageHeight = $newMessage.offsetHeight + newMessageMargin

//     const visibleHeight = $messages.offsetHeight
//     //Heights of messages container
//     const containerHeight = $messages.scrollHeight

//     const scrollOffset = $messages.scrollTop + visibleHeight

//     if (containerHeight - newMessageHeight <= scrollOffset) {
//         $messages.scrollTop = $messages.scrollHeight
//     }

// }
socket.emit('join', { username, room }, (error) => {
    if (error) {
        alert(error)
        location.href = '/'
    }
})
socket.on('roomData', ({ room, users }) => {
    // const html = Mustache.render(sidebarTemplate, {
    //     room,
    //     users
    // })
    // document.querySelector('#sidebar').innerHTML = html

    roomName.innerText = room;

    userList.innerHTML = '';
    users.forEach((user) => {
        const li = document.createElement('li');
        li.innerText = user.username;
        userList.appendChild(li);

    })

})
socket.on('message', (message) => {
    // console.log(msg)
    // const html = Mustache.render(messageTemplate, {
    //     username: msg.username,
    //     msg: msg.text,
    //     createdAt: moment(msg.createdAt).format('hh:mm a')
    // })
    // $messages.insertAdjacentHTML('beforeend', html)
    // autoscroll()
    const div = document.createElement('div');
    div.classList.add('message');
    const p = document.createElement('p');
    p.classList.add('meta');
    p.innerText = message.username;

    p.innerHTML += ` <span>${message.time}</span>`;

    div.appendChild(p);
    const para = document.createElement('p');
    para.classList.add('text');
    para.innerText = message.text;
    div.appendChild(para);
    document.querySelector('.chat-messages').appendChild(div);

    //chatMessages.scrollTop = chatMessages.scrollHeight;


})


chatForm.addEventListener('submit', (e) => {
    // e.preventDefault();
    // $messageFormButton.setAttribute('disabled', 'disabled')
    // const message = e.target.elements.message.value;
    // socket.emit('sendMessage', message, (error) => {
    //     $messageFormButton.removeAttribute('disabled')
    //     $messageFormInput.value = ''
    //     $messageFormInput.focus()
    //     if (error) {
    //         return console.log(error)
    //     }
    //     console.log("message deleiverd ")
    e.preventDefault();
    let msg = e.target.elements.msg.value;

    msg = msg.trim();

    if (!msg) {
        return false;
    }
    socket.emit('sendMessage', msg, (error) => {
        if (error) {
            return console.log(error)
        }
    });
    e.target.elements.msg.value = '';
    e.target.elements.msg.focus();
})




document.getElementById('leave-btn').addEventListener('click', () => {
    const leaveRoom = confirm('Are you sure you want to leave the chatroom?');
    if (leaveRoom) {
        window.location = '../index.html';
    } else {
    }
});
