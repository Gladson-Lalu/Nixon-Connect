const { Schema, Types, model } = require('mongoose');

//create room schema
const roomSchema = new Schema({
    roomName: {
        type: String,
        required: [true, 'Please enter room name'],
    },
    roomType: {
        type: String,
        enum: ['public', 'community', 'guided', 'friendzone'],
        required: [true, 'Please choose room type'],
    },
    roomPassword: {
        type: String,
        required: [true, 'Please enter room password'],
    },
    roomDescription: {
        type: String,
        required: [true, 'Please enter room description'],
    },
    roomCreator: {
        type: { type: Types.ObjectId, ref: 'User' },
        required: true,
    },
    roomAvatarUrl: {
        type: String,
        default: 'https://www.clipartkey.com/view/ooxJoR_multiple-user-png-icon/',
    },
    roomMembers: [{ type: Types.ObjectId, ref: 'User' }],
    roomRoles: [{ type: Types.ObjectId, ref: 'Role' }],
    roomMessages: [{ type: Types.ObjectId, ref: 'Message' }],
});

//create room model
const Room = model('Room', roomSchema);

module.exports = Room;