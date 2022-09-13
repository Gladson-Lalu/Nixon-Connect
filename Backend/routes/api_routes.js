//Api Routes
const { Router } = require('express');
const { createRoom } = require('../controllers/room_controller');
const { sync } = require('../controllers/sync_controller');
const router = Router();

//create room post route
router.post('/api/room/create', createRoom);

//master sync post route user id
router.post('/api/sync', sync);

//test route
router.get('/api/test', (req, res) => {
    res.status(200).json({ success: true });
});

module.exports = router;