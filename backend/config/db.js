const mongoose = require('mongoose')

const connection = mongoose.createConnection('mongodb+srv://vanuj20220952:O5W8NLAhjWeCilYh@vehicles.ou8c7.mongodb.net/?retryWrites=true&w=majority&appName=Vehicles').on('open',()=>{
  console.log("MongoDB Connected")
}).on('error',()=>{
  console.log('MongoDB Connection Error')
})

module.exports = connection;