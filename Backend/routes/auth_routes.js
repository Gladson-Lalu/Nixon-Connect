const { Router } = require('express');
const { createUser, loginUser } = require('../controllers/auth_controller');
const router = Router();

router.post('/api/auth/register', createUser);
router.post('/api/auth/login', loginUser);
router.get('/api/auth/logout', (req, res) => {
    console.log('logout');
    res.clearCookie('token');
    res.status(200).json({ message: 'logged out' });
}
);

module.exports = router;