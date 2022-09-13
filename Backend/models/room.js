const { Schema, model } = require('mongoose');
const mongoose = require('mongoose');
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
    roomDescription: {
        type: String,
        default: "",
    },
    roomPerimeter: {
        type: String,
        required: [true, 'Room perimeter is required'],
    },
    roomPassword: {
        type: String,
    },
    roomHost: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: [true, 'Room host is required'],
    },
    roomAvatarUrl: {
        type: String,
        default: 'https://about.fb.com/wp-content/uploads/2014/11/groupslogo2.jpg',
    },
    roomMembers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    roomRoles: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Role' }],
    roomMessages: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Message' }],
}, { timestamps: true });

//find room by id
roomSchema.statics.findRoomById = function (roomId) {
    return this.findById(roomId).populate('roomMembers').populate('roomHost').populate('roomRoles').populate('roomMessages');
}

//create room model
const Room = model('Room', roomSchema);


module.exports = Room;