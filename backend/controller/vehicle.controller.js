const vehicleServices = require("../services/vehicle.service");

exports.createVehicle = async (req,res, next)=>{
    try{
        const {userId,title,description} = req.body;

        let vehicle = await vehicleServices.createVehicle(userId,title,description);


        res.json({status:true,success:vehicle});


    }catch(error){
        next(error);
    }
}


exports.getUserVehicle = async (req, res, next) => {
    try {
      const userId = req.query.userId || req.body.userId;
      
      if (!userId) {
        return res.status(400).json({ status: false, message: "userId is required" });
      }
      
      let vehicle = await vehicleServices.getVehicleData(userId);
      res.json({ status: true, success: vehicle });
    } catch (error) {
      next(error);
    }
  };

  exports.deleteVehicle = async (req, res, next) => {
    try {
      const id = req.query.id || req.body.id;
      
      if (!id) {
        return res.status(400).json({ status: false, message: "userId is required" });
      }
      
      let deleted = await vehicleServices.deleteVehicleData(id);
      res.json({ status: true, success: deleted });
    } catch (error) {
      next(error);
    }
  };