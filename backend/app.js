const express = require('express');
const body_parser = require('body-parser');
const userRoutes = require('./routers/user.route');
const vehicleRoutes = require('./routers/vehicle.route');
const cors = require('cors');

const app = express();
app.use(cors());

app.use(body_parser.json());

app.use('/',userRoutes)
app.use('/',vehicleRoutes)
module.exports = app;