const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const mongoose = require("mongoose");
const Room = require("./models/room.js");
var io = require("socket.io")(server);
const getword = require('./api/words');
const { listIndexes } = require("./models/room.js");
// import MongoClient from 'mongodb';


// converting data into json

app.use(express.json());

//connect to database mongoose

const DB = 'mongodb://0.0.0.0:27017/drawize';

mongoose.connect(DB, { useUnifiedTopology: true }).then(() => {
    console.log('succesful!');
}).catch(e => {
    console.log(e);
})


io.on('connection', (socket) => {
    console.log('connected');



    //create game callback
    socket.on('create-game', async ({ nickname, name, occupancy, maxRounds }) => {
        try {
            const isRoomNotNew = await Room.findOne({ name });
            if (isRoomNotNew) {
                socket.emit('roomalreadyexist', 'Room with that ID already exists!');
                return;
            }
            let room = new Room();
            const word = getword();
            room.word = word;
            room.name = name;
            room.occupancy = occupancy;
            room.maxRounds = maxRounds;

            let player = {
                socketID: socket.id,
                nickname,
                isPartyLeader: true,
            }
            room.players.push(player);
            room = await room.save();
            socket.join(name);

            // console.log(room);
            io.to(name).emit('updateRoom',room);



        } catch (err) {
            console.log(err);
        }
    })



    //join room callback
    socket.on('join-game', async ({ nickname, name }) => {
        // console.log(nickname);
        try {
            let room = await Room.findOne({ name });
            // console.log(room);
            if (!room) {
                console.log('error');
                socket.emit('notCorrectGame', 'Please Enter a valid room name');
                return;
            }
            if (room.isJoin) {
                let player = {
                    socketID: socket.id,
                    nickname,
                    isPartyLeader: false,
                }
                // console.log(player);
                room.players.push(player);
                socket.join(name);
                if (room.players.length == room.occupancy) {
                    room.isJoin = false;
                }
                room.turn = room.players[room.turnIndex];
                room = await room.save();

                io.to(name).emit('updateRoom',room);
            }
            else {
                socket.emit('notCorrectGame', 'Room is full, please try again later!');
                return;
            }


        } catch (err) {
            console.log(err);
        }
    })

    socket.on('msg', async (data) => {
        console.log(data);
        try {
            if (data.msg === data.word) {
                let room = await Room.find({ name: data.roomName });
                let userPlayer = room[0].player.filter(
                    (player) => player.nickname === data.username
                )
                if (data.timeTaken !== 0) {
                    userPlayer[0].points += Math.round((200 / data.timeTaken) * 10);
                }
                room = await room[0].save();
                io.to(data.roomName).save();
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: 'Guessed it!',
                    guessedUserCtr: data.guessedUserCtr + 1,
                })
            } else {
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: data.msg,
                    guessedUserCtr: data.guessedUserCtr,
                })
            }
        } catch (err) {
            console.log(err.toString());
        }
    })

    socket.on('change-turn', async (name) => {
        try {
            let room = await Room.findOne({ name });
            let index = room.turnIndex;
            if (index + 1 === room.players.lenght) {
                room.currentRound += 1;
            }
            if (room.currentRound <= room.maxRounds) {
                const word = getWord();
                room.word = word;
                room.turnIndex = (index + 1) % room.players.length;
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(name).emit('change-turn', room);
            } else {
                // show the leaderboad
            }

        } catch (err) {
            console.log(err);
        }
    })

    //painting area callback
    socket.on('paint', async ({ details, roomName }) => {
        // if(details.dx != null){console.log(details)}
        // console.log(typeof(details))
        // console.log(roomName)
        // let room = await Room.findOne({roomName});
        // socket.join(roomName);
        // for (let index = 0; index < room.players.length; index++) {
        // console.log(room.players[index]);
        // }
        io.to(roomName).emit('points', { details: details });
    })

    //color callback
    socket.on('color-change', async ({ color, roomName }) => {
        // console.log(color);
        // console.log(roomName);
        io.to(roomName).emit('color-change', color);
    })


    //stroke-width callback
    socket.on('stroke-width', async ({ value, roomName }) => {
        // console.log(value);
        // console.log(roomName);
        io.to(roomName).emit('stroke-width', value);
    })

    //clear-screen callback
    socket.on('clear-screen', (roomName) => {
        io.to(roomName).emit('clear', roomName);
        // console.log(roomName);
    })

});


server.listen(port, '0.0.0.0', () => {
    console.log('server started and running at port :' + port);
})
// 