const { sign, verify } = require('jsonwebtoken');
const User = require('../models/user');



//create jwt token
const createJWT = (user) => {
    const payload = {
        id: user._id,
    };
    //expires in 1 month
    return sign(payload, process.env.JWT_SECRET);
}

//POST METHODS

//create user (signup)
const createUser = async (req, res) => {
    var { name, userID, password, email } = req.body;
    const user1 = await User.findOne({ userID });
    if (user1) {
        res.status(400).json({ error: 'UserID already exists' });
        return;
    }
    const user2 = await User.findOne({ email: email });
    if (user2) {
        res.status(400).json({ error: 'Email already exists' });
        return;
    }
    User.create({ name, userID, password, email: email }).then((user) => {
        const token = createJWT(user);
        res.status(200).json({
            authentication: 'success', user: {
                id: user._id,
                name: user.name,
                userID: user.userID,
                email: user.email,
                profileUrl: user.profileUrl,
                chats: user.chats,
                lastSeen: user.lastSeen,
                isActive: user.isActive,
                token: token,
            }
        });
    }
    ).catch(err => {
        console.log(err);
        res.status(500).json({ error: err.message });
    });
}


//login user (login)
const loginUser = async (req, res) => {
    var { email, password } = req.body;
    email = email.toLowerCase();
    User.login(email, password).then(
        (user) => {
            const token = createJWT(user);
            res.status(200).json({
                authentication: 'success', user: {
                    id: user._id,
                    name: user.name,
                    userID: user.userID,
                    email: user.email,
                    profileUrl: user.profileUrl,
                    chats: user.chats,
                    lastSeen: user.lastSeen,
                    token: token,
                    isActive: user.isActive,
                }
            });
        }
    ).catch(err => {
        console.log(err);
        res.status(500).json({ error: err.message });
        return;
    });
}

//verify token
const verifyToken = (req, res) => {
    const token = req.body.token;
    if (!token) {
        res.status(400).json({ error: 'token not found' });
        return;
    }
    try {
        const decoded = verify(token, process.env.JWT_SECRET);
        //verify userId
        User.findById(decoded.id).then((user) => {
            if (!user) {
                res.status(400).json({ error: 'user not found' });
                return;
            }
            res.status(200).json({
                authentication: 'success'
            });
        }).catch(err => {
            console.log(err);
            res.status(500).json({ error: err.message });
        });
    } catch (err) {
        res.status(400).json({ error: 'token not verified' });
    }
}

//update profile picture
const updateProfilePicture = (req, res) => {
    const token = req.body.token;
    if (!token) {
        res.status(400).json({ error: 'token not found' });
        return;
    }
    try {
        const decoded = verify(token, process.env.JWT_SECRET);
        //verify userId
        User.findById(decoded.id).then((user) => {
            if (!user) {
                res.status(400).json({ error: 'user not found' });
                return;
            }
            user.profileUrl = req.body.profilePicture;
            user.save().then((user) => {
                res.status(200).json({
                    authentication: 'success', user: {
                        id: user._id,
                        name: user.name,
                        userID: user.userID,
                        email: user.email,
                        profileUrl: user.profileUrl,
                        chats: user.chats,
                        lastSeen: user.lastSeen,
                        token: token,
                        isActive: user.isActive,
                    }
                });
            }).catch(err => {
                console.log(err);
                res.status(500).json({ error: err.message });
            });
        }).catch(err => {
            console.log(err);
            res.status(500).json({ error: err.message });
        });
    } catch (err) {
        console.log(err);
        res.status(400).json({ error: 'token not verified' });
    }
}

module.exports = { createUser, loginUser, verifyToken, updateProfilePicture };
