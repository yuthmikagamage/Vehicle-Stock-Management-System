const mongoose = require('mongoose');
const db = require('../config/db');
const userModel =require("../model/user.mode")
const {Schema} = mongoose;

const vehicleSchema= new Schema({
    userId:{
        type:Schema.Types.ObjectId,
        ref:userModel.modelName
    },
    title:{
        type:String,
        required:true,
    },
    description:{
        type:String,
        required:true,
    }
})

const vehicleModel = db.model('vehicle',vehicleSchema);

module.exports = vehicleModel;