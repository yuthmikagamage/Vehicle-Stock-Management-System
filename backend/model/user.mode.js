const mongoose = require('mongoose');
const bycrypt = require('bcrypt');
const db = require('../config/db');

const {Schema} = mongoose;

const userSchema = new Schema({
    email:{
        type:String,
        lowercase:true,
        required:true,
        unique:true
    },
    password:{
        type:String,
        required:true,
    }
})

userSchema.pre('save',async function () {
    try{
        var user = this;
        const salt = await(bycrypt.genSalt(10));
        const hashpass = await bycrypt.hash(user.password,salt);

        user.password=hashpass;
    }catch(err){

    }
})

userSchema.methods.comparePassword = async function(userPassword){
    try{
        const isMatch = await bycrypt.compare(userPassword,this.password)
        return isMatch;
    }catch(error){
        throw error;
    }
}

const userModel = db.model('user',userSchema);

module.exports = userModel;