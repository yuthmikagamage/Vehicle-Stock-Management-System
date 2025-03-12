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
      const user = await userService.checkuser(email);
      
      if(!user){
        console.log("User Doesn't exist");
        return res.status(401).json({status:false, message:"User does not exist"});
      }
      
      const isMatch = await user.comparePassword(password);
      if(isMatch === false){
        console.log("Password Invalid");
        return res.status(401).json({status:false, message:"Invalid password"});
      }
      
      let tokenData = {_id:user._id,email:user.email};
      const token = await userService.generateToken(tokenData,"secretKey",'1h');
      res.status(200).json({status:true, message:"Login Suessfully", token:token});
    } catch(error){
      console.error(error);
      res.status(500).json({status:false, message:"Internal server error"});
    }
  }