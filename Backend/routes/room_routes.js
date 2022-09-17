const { Router } = require('express');
const { createRoom, getNearestInvitingRooms, joinRoom } = require('../controllers/room_controller');

const router = Router();
router.post('/api/inviting-rooms', getNearestInvitingRooms);

//create room post route
router.post('/api/room/create', createRoom);

//join room post route
router.post('/api/room/join', joinRoom);

module.exports = router;