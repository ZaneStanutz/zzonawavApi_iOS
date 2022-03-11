var express = require('express');
var router = express.Router();

var MongoClient = require('mongodb').MongoClient; // is property;
var cs = 'mongodb+srv://zaneStanutz:MMX2Unrs5qSA4Pu@cluster0.gyh41.mongodb.net/myFirstDatabase?retryWrites=true&w=majority';

/* GET users listing. */
router.post('/', function(req, res, next) {
    var userEmail = req.body.email;
    var userPass = req.body.password;

    MongoClient.connect(cs, function(err,db){
        if(err){
            res.send("connection-failed");
        }
        else{
            var database =  db.db('zzonawavapi');
            let query = {$and:[{email: userEmail, password: userPass }]};
            database.collection('users').findOne(query, function(finderr, findres){
                if(finderr){
                    res.send('findOne-failed');
                    console.log(finderr);
                }
                else{
                    console.log(findres);
                    res.send(findres);
                }

            });
        }
    });
  
});

module.exports = router;