//Api Routes
const { Router } = require('express');
const { sync } = require('../controllers/sync_controller');
const router = Router();


//master sync post route user id
router.post('/api/sync', sync);


//test route
router.get('/api/test', (req, res) => {
    res.status(200).json({ success: true });
});

module.exports = router;