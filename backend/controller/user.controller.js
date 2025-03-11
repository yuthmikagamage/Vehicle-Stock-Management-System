const UserService = require('../services/user.service');
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

exports.login = async(req,res,next)=>{
    try{
        const {email,password} = req.body;

        const user = await UserService.checkuser(email);

        if(!user){
            throw new Error("User doesnt exists")
        }

        const isMatch = await user.comparePassword(password);

        if(isMatch == false){
            throw new Error("Password invalid")
        }

        let tokenData = {_id:user._id,email:user.email};

        const token = await userService.generateToken(tokenData,"secretKey",'1h')

        res.status(200).json({status:true,token:token})


        
    }catch(error){
        throw error
    }
}