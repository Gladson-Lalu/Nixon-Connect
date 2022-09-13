const jwt = require('jsonwebtoken');
const User = require('../models/user');
const Room = require('../models/room');

module.exports.createRoom = (req, res) => {
    const { roomName, roomType, roomDescription, roomPerimeter, roomPassword } = req.body;
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
                User.updateOne({ _id: userId }, { $push: { rooms: room._id } }).then(() => {
                    res.status(200).json({ room: room });
                }).catch(err => {  //catch for user update
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