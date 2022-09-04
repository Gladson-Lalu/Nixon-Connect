//Api Routes
const { Router } = require('express');
const { createRoom } = require('../controllers/room_controller');
const router = Router();

//create room post route
router.post('/api/room/create', createRoom);
router.get('/api/get', (req, res) => {
    console.log('api route');
    res.send('api route');
}
);


module.exports = router;