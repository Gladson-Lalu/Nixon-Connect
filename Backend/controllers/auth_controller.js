const { sign } = require('jsonwebtoken');
const User = require('../models/user');



//create jwt token
const createJWT = (user) => {
    const payload = {
        id: user._id,
    };
    return sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
}

//POST METHODS

//create user (signup)
const createUser = async (req, res) => {
    var { name, userID, password, email } = req.body;
    console.log(name, userID, password, email);
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
    console.log(email, password);
    email = email.toLowerCase();
    User.login(email, password).then(
        (user) => {
            const token = createJWT(user);
            res.status(200).json({
                authentication: 'success', user: {
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

module.exports = { createUser, loginUser };
