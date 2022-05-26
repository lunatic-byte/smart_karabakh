'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const express = require('express');
const app = express();
app.use(function (req, res, next) {

    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods",  'GET,POST','PUT','DELETE');
    res.set("Access-Control-Allow-Headers", "Content-Type");
    res.set("Access-Control-Max-Age", "3600");
    // Send response to OPTIONS requests and terminate the function execution
    if (req.method == 'OPTIONS') {
        res.status(204).send('');
    }else{
        next();
    }

  
});

var mainRoute = require('./routers/main');
app.use('/main', mainRoute);







//
//Listener 
exports.main = functions.https.onRequest(app);