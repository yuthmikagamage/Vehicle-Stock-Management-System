const userService = require('../services/user.service')

exports.register = async(req,res,next)=>{
    try{
        const {email,password} = req.body;

        const successRes = await userService.registerUser(email,password);

        res.json({status:true,success:"User Registered Suessfully"})
    }catch(error){
        throw error
    }
}