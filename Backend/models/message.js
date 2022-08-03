const { Schema, Types, model } = require('mongoose');

//create message schema
const messageSchema = new Schema({
    message: {
        type: String,
        required: [true, 'message is required'],
        minlength: [1, 'message is too short'],
    },
    bucket: {
        type: Number,
        required: true,
        min: 0,
    },
    from: {
        type: { type: Types.ObjectId, ref: 'User' },
        required: true,
    },
    to: {
        type: { type: Types.ObjectId, ref: 'User' },
        required: true,
    },
    room: {
        type: { type: Types.ObjectId, ref: 'Room' },
        required: true,
    },
}, { timestamps: true });

//create message model
const Message = model("Message", messageSchema);
export default Message;