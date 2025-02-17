const mongoose = require('mongoose')

const connection = mongoose.createConnection('mongodb://localhost:27017/userLogin').on('open',()=>{
  console.log("MongoDB Connected")
}).on('error',()=>{
  console.log('MongoDB Connection Error')
})

module.exports = connection;