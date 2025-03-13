const router = require("express").Router();
const vehicleController = require('../controller/vehicle.controller');

router.post('/storeVehicle',vehicleController.createVehicle);
router.get('/getVehicle',vehicleController.getUserVehicle);
module.exports = router;