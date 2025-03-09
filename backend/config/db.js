const mongoose = require('mongoose')

const connection = mongoose.createConnection('mongodb+srv://vanuj20220952:vbYlLSZFs6fBrTmx@vehiclecluster.uq7mn.mongodb.net/?retryWrites=true&w=majority&appName=VehicleCluster').on('open',()=>{
  console.log("MongoDB Connected")
}).on('error',()=>{
  console.log('MongoDB Connection Error')
})

module.exports = connection;
