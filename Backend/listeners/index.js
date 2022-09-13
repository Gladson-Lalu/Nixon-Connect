const Room = require('../models/room');
const User = require('../models/user');
const Message = require('../models/message');
const jwt = require('jsonwebtoken');
//socket io listeners for the chat and send message
const listeners = (io) => {
    //active users hash map
    const activeUsers = new Map();
    io.on('connection', (socket) => {
        console.log(`socket ${socket.id} connected`);
        socket.on('authenticate', ({ token }) => {
            try {
                if (!token) {
                    io.to(socket.id).emit('user-connected', { success: false, message: 'Authentication failed' });
                    return;
                }
                jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
                    if (err) {
                        console.log(err.message);
                        io.to(socket.id).emit('user-connected', { success: false, message: 'Authentication failed' });
                        return;
                    }
                    const userId = decoded.id;

                    User.findById(userId).then(user => {
                        if (!user) {
                            io.to(socket.id).emit('user-connected', { success: false, message: 'Authentication failed' });
                            return;
                        }

                        //add this user to all socket rooms that he is a member of
                        user.rooms.forEach(roomId => {
                            socket.join(roomId);
                        });

                        //add this user to the active users hash map
                        activeUsers[token] = [userId, socket.id];
                        //send the active users hash map to the client
                        io.to(socket.id).emit('user-connected', { success: true });
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

                    if (token in activeUsers) {

                        const userId = activeUsers[token][0];
                        if (!userId) {
                            io.to(socket.id).emit('message-sent', { success: false, message: 'Authentication failed' });
                            return;
                        }

                        //check user is in room
                        Room.findById(roomId).then(room => {
                            if (!room) {
                                io.to(socket.id).emit('message-sent', { success: false, message: 'Room not found' });
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
                                    io.to(roomId).emit('message-received', message);
                                    io.to(socket.id).emit('message-sent', { success: true });
                                }).catch(err => {
                                    console.log(err);
                                    io.to(socket.id).emit('message-sent', { success: false, message: 'Failed to send message' });
                                });

                            } else {
                                io.to(socket.id).emit('message-sent', { success: false, message: 'User not in room' });
                                return;
                            }
                        }).catch(err => {
                            console.log(err);
                            io.to(socket.id).emit('message-sent', { success: false, message: 'Failed to send message' });
                        });
                    } else {
                        io.to(socket.id).emit('message-sent', { success: false, message: 'resend-token' });
                        return;
                    }
                } else {
                    io.to(socket.id).emit('message-sent', { success: false, message: 'Authentication failed' });
                    return;
                }
            } catch (err) {
                console.log(err);
            }
        });

        socket.on('disconnect', () => {
            //remove this user from the active users hash map
            for (let [key, value] in activeUsers) {
                if (value[1] === socket.id) {
                    activeUsers.delete(key);
                }
            }
            console.log(`socket ${socket.id} disconnected`);
        });
    });
};

module.exports = listeners;