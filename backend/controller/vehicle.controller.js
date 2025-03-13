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

exports.getUserVehicle = async (req,res, next)=>{
    try{
        const {userId} = req.body;

        let vehicle = await vehicleServices.getVehicleData(userId);


        res.json({status:true,success:vehicle});


    }catch(error){
        next(error);
    }
}

