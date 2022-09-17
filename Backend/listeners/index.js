const Room = require('../models/room');
const User = require('../models/user');
const Message = require('../models/message');
const { ActiveUserInfo } = require('./active_user_session');
const InviteRoom = require('../models/inviting_rooms');
const geolib = require('geolib');

const jwt = require('jsonwebtoken');
//socket io listeners for the chat and send message
//singleton class pattern to handle io
class SocketIO {
    constructor() {
        if (!SocketIO.instance) {
            SocketIO.instance = this;
        }
        return SocketIO.instance;
    }
    //get instance 
    static getInstance() {
        return SocketIO.instance;
    }

    //initialize socket io
    Init(io) {
        //active users hash map
        this.io = io;
        this.activeUsers = new Map();
        io.on('connection', (socket) => {
            console.log(`socket ${socket.id} connected`);
            function onError(message) {
                io.to(socket.id).emit('error', { message: message });
            }
            socket.on('authenticate', ({ token }) => {
                try {
                    if (!token) {
                        onError('No token provided');
                        return;
                    }
                    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
                        if (err) {
                            console.log(err.message);
                            onError('Failed to authenticate token');
                            return;
                        }
                        const userId = decoded.id;

                        User.findById(userId).then(user => {
                            if (!user) {
                                onError('User not found');
                                return;
                            }

                            //add this user to all socket rooms that he is a member of
                            user.rooms.forEach(room => {
                                socket.join(room.toString());
                            });
                            //add this user to the active users hash map
                            this.activeUsers[token] = new ActiveUserInfo(userId, socket.id);
                            //send the active users hash map to the client
                        });
                    });
                } catch (err) {
                    console.log(err);
                }
            });

            socket.on('send-message', (data) => {
                try {
                    const { token, message, mentions, roomId } = data;
                    if (token && roomId && message) {
                        if (token in this.activeUsers) {
                            const userId = this.activeUsers[token].userId;
                            if (!userId) {
                                onError('User not found');
                                return;
                            }
                            //check user is in room
                            Room.findById(roomId).then(room => {
                                if (!room) {
                                    onError('Room not found');
                                    return;
                                }
                                if (room.roomMembers.includes(userId)) {
                                    const newMessage = new Message({
                                        messageSender: userId,
                                        messageRoomId: roomId,
                                        messageContent: message,
                                        mentions: mentions,
                                    });
                                    newMessage.save().then(message => {
                                        //send message to all users in room
                                        //Update Room Last Message
                                        Room.updateOne({ _id: roomId }, { $set: { lastMessage: message.messageContent } }).then(() => {
                                            io.in(roomId).emit('message-received', message);
                                            io.to(socket.id).emit('message-sent', { success: true });
                                        }).catch(err => {
                                            console.log(err);
                                            onError(err.message);
                                        });
                                    }).catch(err => {
                                        console.log(err);
                                        onError('Failed to save message');
                                    });
                                } else {
                                    onError('User not in room');
                                    return;
                                }
                            }).catch(err => {
                                console.log(err);
                                onError('Failed to find room');
                            });
                        } else {
                            onError('token-not-found');
                            return;
                        }
                    } else {
                        onError('Invalid data');
                        return;
                    }
                } catch (err) {
                    console.log(err);
                }
            });

            socket.on('disconnect', () => {
                //remove this user from the active users hash map
                for (const token in this.activeUsers) {
                    if (this.activeUsers[token].socketId === socket.id) {
                        delete this.activeUsers[token];
                    }
                }
                console.log(`socket ${socket.id} disconnected`);
            });

            //get location of user and store in Location
            socket.on('send-location', (data) => {
                try {
                    const { token, location } = data;
                    if (token && location) {
                        let userId = null;
                        if (token in this.activeUsers) {
                            userId = this.activeUsers[token].userId;
                        }
                        else {
                            jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
                                if (err) {
                                    console.log(err.message);
                                    return;
                                }
                                userId = decoded.id;
                            });
                        }
                        if (!userId) {
                            onError('User not found');
                            return;
                        }
                        User.findById(userId).then(user => {
                            if (!user) {
                                onError('User not found');
                                return;
                            }
                            const temp = this.activeUsers[token];
                            if (temp) {
                                console.log('user is online');
                                temp.location = location;
                                this.inviteUserToNearestRooms(temp);
                            }
                            //print type of inviteUserToNearestRooms

                        }).catch(err => {
                            console.log(err);
                            onError('Failed to save location');
                        });
                    }
                } catch (err) {
                    console.log(err);
                }
            });
        });
    };

    //get active users hash map
    getActiveUsers() {
        return this.activeUsers;
    }

    //invite users to rooms
    notifyUsers(users, invitingRooms) {
        console.log(invitingRooms);
        for (const user of users) {
            this.io.to(user.socketId).emit('room-invite', { rooms: invitingRooms });
        }
    }

    async inviteUserToNearestRooms(user) {
        //get inviting rooms
        InviteRoom.find().then((rooms) => {
            //get nearest rooms
            let nearestRooms = [];
            for (const room of rooms) {
                const distance = geolib.getDistance({ latitude: room.latitude, longitude: room.longitude }, { latitude: user.location.latitude, longitude: user.location.longitude });
                if (distance <= room.perimeter) {
                    nearestRooms.push(room.room);
                }
            }
            //get room details
            Room.find({ _id: { $in: nearestRooms } }).then(rooms => {
                //send room name, room id, room type, room description, room host, room avatar 
                const roomDetails = rooms.map(room => {
                    return {
                        roomName: room.roomName,
                        _id: room._id,
                        roomType: room.roomType,
                        roomDescription: room.roomDescription,
                        roomHost: room.roomHost,
                        roomAvatarUrl: room.roomAvatarUrl,
                        createdAt: room.createdAt,
                    };
                });
                this.notifyUsers([user], roomDetails);
            }).catch((err) => {
                console.log(err);
            });
        }).catch((err) => {
            console.log(err);
        });
    }
}

module.exports.SocketIO = SocketIO;