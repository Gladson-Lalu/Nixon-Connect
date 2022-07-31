import { verify } from 'jsonwebtoken';
import { findById } from '../models/score';
import { jwtSecretKey } from '../config.env';

const requireAuth = (req, res, next) => {
    const token = req.cookies.auth;
    if (token) {
        verify(token, jwtSecretKey, async (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.redirect('/login.html');
            } else {
                const teamScore_ = await findById(decodedToken.id);
                if (teamScore_) {
                    res.locals.teamScore = teamScore_;
                    next();
                } else {
                    res.locals.id = null;
                    res.redirect('/login.html');
                }
            }
        });
    } else {
        res.redirect('/login.html');
    }
};


export default { requireAuth };
