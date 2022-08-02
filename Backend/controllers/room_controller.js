const jwt = require('jsonwebtoken');
const User = require('../models/user');
const Room = require('../models/room');

module.exports.createRoom = (req, res) => {
    const { roomName, roomType, roomDescription, roomPerimeter, roomPassword } = req.body;
    console.log(roomName, roomType, roomDescription, roomPerimeter, roomPassword);
    //get token from bearer header
    const token = req.headers['authorization'].split(' ')[1];
    //verify token
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
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
            Room.create({ roomName, roomType: _roomType, roomDescription, roomPerimeter, roomPassword, roomHost: userId }).then((room) => {
                res.status(200).json({
                    room: {
                        roomName: room.roomName,
                        roomType: room.roomType,
                        roomDescription: room.roomDescription,
                        roomPerimeter: room.roomPerimeter,
                        roomPassword: room.roomPassword,
                        roomHost: room.userId,
                        roomId: room._id,
                    }
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