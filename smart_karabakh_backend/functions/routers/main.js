var express = require('express');
var router = express.Router();
const admin = require('firebase-admin');
const firestore = admin.firestore();

//

router.get('/getLedData', async (req, res) => {
    // const payload = req.body;
    //return json like {ledEnergy:100}
    //
    try {
        //
        var result = await firestore.collection("IOT").doc('smartLighting').get();
        if (req.query.t !== undefined) {
            var result2 = await firestore.collection("Weather").add({
                timestamp: Date.now(),
                t: req.query.t,
                h: req.query.h,
            });
        }
        res.json(result.data());
        //
    } catch (e) {
        res.send('server_error');
    }


});
router.get('/getWeaterData', async (req, res) => {
    //
    try {
        let lst = [];

        var result = await firestore.collection("Weather").orderBy("timestamp", "desc").limit(30).get();
        result.forEach(doc => {
            lst.push(doc.data());
        });
        res.json(lst);
        //
    } catch (e) {
        res.send('server_error');
    }
});
router.get('/getParkingData', async (req, res) => {
    //
    try {
        let lst = [];

        var result = await firestore.collection("Parking").orderBy("count", "desc").limit(30).get();
        result.forEach(doc => {
            lst.push(doc.data());
        });
        res.json(lst);
        //
    } catch (e) {
        res.send('server_error');
    }
});

router.post('/setParkingLocation', async (req, res) => {
    //
    const payload = req.body;
    const docID = `${payload.count}${payload.lat}${payload.lon}${payload.name}`;
    try {


        var result = await firestore.collection("Parking").doc(docID).set({
            count: payload.count,
            id: docID,
            lat: payload.lat,
            lon: payload.lon,
            name: payload.name,

        });

        res.json(result.writeTime);
        //
    } catch (e) {
        res.send('server_error');
    }
});

router.post('/deleteParkingWithId', async (req, res) => {
    //
    const payload = req.body;
    const docID =payload.docId;
    try {


        var result = await firestore.collection("Parking").doc(docID).delete();

        res.json(result.writeTime);
        //
    } catch (e) {
        res.send('server_error');
    }
});



router.post('/setLedData', async (req, res) => {

    const payload = req.body;
    //set like {ledEnergy:x}
    try {
        var result = await firestore.collection("IOT").doc('smartLighting').set({
            ledEnergy: payload['ledEnergy']
        });

        res.send(result.writeTime);
    } catch (e) {
        res.send('server_error');
    }

});

module.exports = router;