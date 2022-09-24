const { Router } = require('express');
const { createRoom, getNearestInvitingRooms, joinRoom, updateRoomAvatar } = require('../controllers/room_controller');

const router = Router();
router.post('/api/inviting-rooms', getNearestInvitingRooms);

//create room post route
router.post('/api/room/create', createRoom);

//join room post route
router.post('/api/room/join', joinRoom);

//update room profile picture
router.post('/api/room/update-room-avatar', updateRoomAvatar);

module.exports = router;