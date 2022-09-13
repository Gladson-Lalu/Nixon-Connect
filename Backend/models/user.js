const { Schema, Types, model } = require('mongoose');
const bcrypt = require('bcrypt');
const userSchema = new Schema({
    name: {
        type: String,
        require: [true, 'Please enter your username'],
    },
    userID: {
        type: String,
        require: [true, 'Please enter your userID'],
        unique: [true, 'This userID is already taken'],
    },
    password: {
        type: String,
        require: [true, 'Please enter your password'],
    },
    email: {
        type: String,
        require: [true, 'Please enter your email'],
        unique: [true, 'This email is already taken'],
        validate: {
            validator: function (value) {
                return /^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(value);
            },
            message: 'Please enter a valid email' // error message
        }
    },
    isActive: {
        type: Boolean,
        required: true,
        default: false,
    },
    profileUrl: {
        required: true,
        type: String,
        default: 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
    },
    createdAt: {
        required: true,
        type: Date,
        default: Date.now,
    },
    rooms: [{ type: Types.ObjectId, ref: 'Room' }],
    lastSeen: {
        required: true,
        type: Date,
        default: Date.now,
    },
});

//encrypt password before saving
userSchema.pre('save', function (next) {
    const salt = bcrypt.genSaltSync(12);
    this.password = bcrypt.hashSync(this.password, salt);
    next();
});

//login user
userSchema.statics.login = async function (email, password) {
    const user = await this.findOne({ email });
    if (user) {
        const auth = bcrypt.compareSync(password, user.password);
        if (auth) {
            return user;
        }
        throw Error('Incorrect password');
    }
    throw Error('Incorrect email');
}

const User = model('User', userSchema);

module.exports = User;