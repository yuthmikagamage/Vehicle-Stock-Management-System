const vehicleModel = require("../model/vehicle.model");

class VehicleServices {
  static async createVehicle(userId, title, description) {
    const createVehicle = new vehicleModel({
      userId: userId,
      title: title,
      description: description
    });

    return await createVehicle.save();
  }

  static async getVehicleData(userId) {
    const vehicleData = await vehicleModel.find({ userId: userId });
    return await vehicleData;
  }
}



module.exports = VehicleServices;
