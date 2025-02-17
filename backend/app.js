const express = require('express');
const body_parser = require('body-parser');
const userRoutes = require('./routers/user.route');

const app = express();

app.use(body_parser.json());

app.use('/',userRoutes)
module.exports = app;