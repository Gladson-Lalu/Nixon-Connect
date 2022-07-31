const { Router } = require('express');
const { root_get } = require('../controllers/root_controller.js');

const router = Router();

router.get('/', root_get);
module.exports = router;