// // https://github.com/AhmedAbouelkher/flutter_socket_io_chat/tree/master

// const express = require('express');
// const app = express();
// const bodyParser = require("body-parser");
// const http = require('http');
// const server = http.createServer(app);
// const { Server } = require("socket.io");
// const PORT = process.env.PORT || 8000

// //middleware
// // support parsing of application/json type post data
// app.use(bodyParser.json());

// //support parsing of application/x-www-form-urlencoded post data
// app.use(bodyParser.urlencoded({ extended: true }));


// //server fire up
// var io =  server.listen(PORT, () => {
//     console.log(`server is running on port ${PORT}....`)
// });

// io.on('connection',function(socket) {
//     console.log('a user connected');

//     console.log('client connect...', socket.id);

//     socket.on("cmd",(data)=>{
//       console.log(data);
//       io.emit("cmd",data);
//   });

//     socket.on('disconnect', () => {
//       console.log('user disconnected');
//     });
// })

const http = require("http");
const server = http.createServer();
const {Server} = require("socket.io");
const io = new Server(server);

const PORT = process.env.PORT || 8000;

io.on("connection",(socket)=>{
    //from Mobile
    socket.on("cmd",(data)=>{
        console.log(data);
        io.emit("cmd",data);
    });
    //from Desktop
    socket.on("commandOutPut",(data)=>{
        // console.log(data);
        io.emit("commandOutPut",data);
    });
    socket.on("disconnect",()=>{});
});


server.listen(PORT,()=>{
    console.log(`listtening on ${PORT}`);
});