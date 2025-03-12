const vehicleModel = require("../model/vehicle.model");

class VehicleServices {
  static async createVehicle(userId, title, description) {
    // Create a new vehicle instance with an object containing the data
    const createVehicle = new vehicleModel({
      userId: userId,
      title: title,
      description: description
    });

    // Save the vehicle instance to MongoDB
    return await createVehicle.save();
  }
}

module.exports = VehicleServices;
