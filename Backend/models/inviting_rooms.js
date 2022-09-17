//model for inviting rooms
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const InvitingRoomSchema = new Schema({
    room: {
        type: Schema.Types.ObjectId,
        ref: 'Room',
        required: true,
    },
    perimeter: {
        type: String,
        required: true,
    },
    //room Center location Data
    latitude: {
        type: String,
        required: true,
    },

    longitude: {
        type: String,
        required: true
    },

    createdAt: {
        type: Date,
        default: Date.now,
        expires: 3600,
    },
});
const InvitingRoom = mongoose.model('InvitingRoom', InvitingRoomSchema);
module.exports = InvitingRoom;