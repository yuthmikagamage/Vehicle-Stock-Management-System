const app = require('./app');

const db = require('./config/db')

const userModel = require('./model/user.mode')

const port = 3000;

app.get('/',(req,res)=>{
    res.send("Hello World!!ss!")
});

app.listen(port, () => {
    console.log('Server listening on port http://localhost:3000');
});
