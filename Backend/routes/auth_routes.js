const { Router } = require('express');
const { createUser, loginUser } = require('../controllers/auth_controller');
const router = Router();

router.post('/api/auth/register', createUser);
router.post('/api/auth/login', loginUser);
// router.get('/api/room/create', getUsers);
module.exports = router;