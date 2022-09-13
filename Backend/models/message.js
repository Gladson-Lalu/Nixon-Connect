const { Schema, Types, model } = require('mongoose');

//create message schema
const messageSchema = new Schema({
    messageContent: {
        type: String,
        required: [true, 'message is required'],
        minlength: [1, 'message is too short'],
    },
    mentions: [{ type: Types.ObjectId, ref: 'User' }],
    messageSender: {
        type: Types.ObjectId, ref: 'User',
        required: [true, 'message sender is required'],
    },
    messageRoomId: {
        type: Types.ObjectId, ref: 'Room',
        required: [true, 'message room is required'],
    },
}, { timestamps: true });

//create message model
const Message = model("Message", messageSchema);
module.exports = Message;