const router = require("express").Router();
const vehicleController = require('../controller/vehicle.controller');

router.post('/storeVehicle',vehicleController.createVehicle);
router.get('/getVehicle',vehicleController.getUserVehicle);
router.post('/deleteVehicle',vehicleController.deleteVehicle);
module.exports = router;