const jwt = require('jsonwebtoken');
const { SocketIO } = require('../listeners/index');
const User = require('../models/user');
const Room = require('../models/room');
const geolib = require('geolib');
const InviteRoom = require('../models/inviting_rooms');

module.exports.createRoom = (req, res) => {
    const { roomName, roomType, roomDescription, roomPerimeter, roomPassword, location } = req.body;
    //get token from bearer header
    const token = req.headers['authorization'].split(' ')[1];
    //verify token
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log(err.message);
            res.status(401).json({ error: 'unauthorized' });
            return;
        }
        //get user id from token
        const userId = decoded.id;
        //verify user id
        User.findById(userId).then(user => {
            if (!user) {
                res.status(401).json({ error: 'unauthorized' });
                return;
            }
            //create room
            const _roomType = roomType.toLowerCase();
            Room.create({ roomName, roomType: _roomType, roomDescription, roomPerimeter, roomPassword, roomHost: userId, roomMembers: [userId] }).then((room) => {
                //add to inviting rooms
                InviteRoom.create({
                    room: room._id, perimeter: roomPerimeter, roomAvatarUrl: room.roomAvatarUrl, roomDescription: room.roomDescription, latitude: location.latitude, longitude: location.longitude
                }).then((_) => {
                    User.updateOne({ _id: userId }, { $push: { rooms: room._id } }).then(() => {
                        res.status(200).json({ room: room });
                    }).catch(err => {  //catch for user update
                        console.log(err);
                        res.status(500).json({ error: err.message });
                    });
                }).catch(err => {
                    console.log(err);
                    res.status(500).json({ error: err.message });
                });
            }).catch(err => {
                console.log(err);
                res.status(500).json({ error: err.message });
            }
            );
        }).catch(err => {
            console.log(err);
            res.status(500).json({ error: err.message });
        }
        );
    });
}

module.exports.getNearestInvitingRooms = (req, res) => {
    const { token, location } = req.body;
    //verify token
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log(err.message);
            res.status(401).json({ error: 'unauthorized' });
            return;
        }
        //get user id from token
        const userId = decoded.id;
        //verify user id
        User.findById(userId).then(user => {
            if (!user) {
                res.status(401).json({ error: 'unauthorized' });
                return;
            }
            //get inviting rooms
            InviteRoom.find().then((rooms) => {
                //get nearest rooms
                let nearestRooms = [];
                for (const room of rooms) {
                    const distance = geolib.getDistance({ latitude: room.latitude, longitude: room.longitude }, { latitude: location.latitude, longitude: location.longitude });
                    if (distance <= room.perimeter) {
                        nearestRooms.push(room.room);
                    }
                }
                Room.find({ _id: { $in: nearestRooms } }).then((rooms) => {
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
                    res.status(200).json({ rooms: roomDetails });
                }).catch(err => {
                    console.log(err);
                    res.status(500).json({ error: err.message });
                });
            }).catch(err => {
                console.log(err);
                res.status(500).json({ error: err.message });
            });
        }).catch(err => {
            console.log(err);
            res.status(500).json({ error: err.message });
        });
    }
    );
}

module.exports.joinRoom = (req, res) => {
    const { roomId, roomPassword, token } = req.body;
    //verify token
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log(err.message);
            res.status(401).json({ error: 'unauthorized' });
            return;
        }
        //get user id from token
        const userId = decoded.id;
        //verify user id
        User.findById(userId).then(user => {
            if (!user) {
                res.status(401).json({ error: 'unauthorized' });
                return;
            }
            //verify room
            Room.findById(roomId).then(room => {
                if (!room) {
                    res.status(404).json({ error: 'room not found' });
                    return;
                }
                //verify room password
                if (room.roomPassword !== roomPassword) {
                    res.status(401).json({ error: 'password incorrect' });
                    return;
                }
                //add user to room
                Room.updateOne({ _id: roomId }, { $push: { roomMembers: userId } }).then(() => {
                    //add room to user
                    User.updateOne({ _id: userId }, { $push: { rooms: roomId } }).then(() => {
                        res.status(200).json({ room: room });
                    }).catch(err => {
                        console.log(err);
                        //join the socket room

                        res.status(500).json({ error: err.message });
                    });
                }).catch(err => {
                    console.log(err);
                    res.status(500).json({ error: err.message });
                });
            }).catch(err => {
                console.log(err);
                res.status(500).json({ error: err.message });
            });
        }).catch(err => {
            console.log(err);
            res.status(500).json({ error: err.message });
        });
    });
}

//update room avatar
module.exports.updateRoomAvatar = (req, res) => {
    const { token, roomId, roomAvatarUrl } = req.body;
    console.log(req.roomAvatarUrl);
    //verify token
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log(err.message);
            res.status(401).json({ error: 'unauthorized' });
            return;
        }
        //get user id from token
        const userId = decoded.id;
        //verify user id
        User.findById(userId).then(user => {
            if (!user) {
                res.status(401).json({ error: 'unauthorized' });
                return;
            }
            //verify room
            Room.findById(roomId).then(room => {
                if (!room) {
                    res.status(404).json({ error: 'room not found' });
                    return;
                }
                //verify room host
                if (room.roomHost.toString() !== userId) {
                    res.status(401).json({ error: 'unauthorized' });
                    return;
                }
                //update room avatar
                Room.updateOne({ _id: roomId }, { roomAvatarUrl: roomAvatarUrl }).then(() => {
                    res.status(200).json({ url: roomAvatarUrl });
                }).catch(err => {
                    console.log(err);
                    res.status(500).json({ error: err.message });
                });
            }).catch(err => {
                console.log(err);
                res.status(500).json({ error: err.message });
            });
        }).catch(err => {
            console.log(err);
            res.status(500).json({ error: err.message });
        });
    });
}