const express = require('express');
const body_parser = require('body-parser');
const userRoutes = require('./routers/user.route');
const cors = require('cors');

const app = express();
app.use(cors());

app.use(body_parser.json());

app.use('/',userRoutes)
module.exports = app;