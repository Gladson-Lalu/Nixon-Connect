const { Router } = require('express');
const { createUser, loginUser, updateProfilePicture } = require('../controllers/auth_controller');
const { verifyToken } = require('../controllers/auth_controller');
const router = Router();

router.post('/api/auth/register', createUser);
router.post('/api/auth/login', loginUser);

//update-profile-picture
router.post('/api/auth/update-profile-picture', updateProfilePicture);

router.get('/api/auth/verify-token', verifyToken);


router.get('/api/auth/logout', (req, res) => {
    console.log('logout');
    res.clearCookie('token');
    res.status(200).json({ message: 'logged out' });
}
);

module.exports = router;