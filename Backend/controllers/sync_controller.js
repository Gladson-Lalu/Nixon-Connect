//sync controller , get all rooms with room messages
const Room = require('../models/room');
const User = require('../models/user');
const Message = require('../models/message');
const jwt = require('jsonwebtoken');
module.exports.sync = (req, res) => {
    console.log('syncing');

    if (req.headers['authorization']) {
        const token = req.headers['authorization'].split(' ')[1];
        const lastSyncTimestamp = req.body.lastSync;
        console.log(lastSyncTimestamp);
        if (token) {
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
                    //for each room in user rooms which updated after last sync => get room messages
                    Room.find({ _id: { $in: user.rooms }, updatedAt: { $gt: lastSyncTimestamp } }).then(rooms => {

                        //get room messages
                        const roomIds = rooms.map(room => room._id);
                        Message.find({ room: { $in: roomIds }, updatedAt: { $gt: lastSyncTimestamp } }).then(messages => {
                            res.status(200).json({ rooms: rooms, messages: messages });
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
        } else {
            res.status(401).json({ error: 'unauthorized' });
        }
    }
    else {
        res.status(401).json({ error: 'unauthorized' });
    }
}
