var express = require('express');
var router = express.Router();

var MongoClient = require('mongodb').MongoClient; // is property;
var cs = 'mongodb+srv://zaneStanutz:MMX2Unrs5qSA4Pu@cluster0.gyh41.mongodb.net/myFirstDatabase?retryWrites=true&w=majority';

/* GET users listing. */
router.post('/', function(req, res, next) {
    var userEmail = req.body.email;
    var userPass = req.body.password;
    var userFeel = req.body.feeling;
    console.log(userEmail + ":");
    console.log(userPass + ":");
    console.log(userFeel + ":");
    
    MongoClient.connect(cs, function(err, db){
        if(err){
            console.log("could not connect:\n" + err);
            res.send("could-not-connect");
        }
        else{
            var database = db.db('zzonawavapi');
            let query = {$and:[{email: userEmail, password: userPass }]};
            database.collection('users').findOne(query, function(finderr, findres){
                if(finderr){
                    console.log('findOne error:\n' + finderr);
                    res.send("find-one-fail");
                }
                else{
                    console.log(findres);
                    database.collection('users').updateOne(
                    { _id: findres._id },
                    { $push: { feelings: userFeel } }, function(updateerr, updateres){
                        if(updateerr){
                            console.log("update has failed: \n" + updateerr);
                            res.send("update-one-fail");
                        }
                        else{
                            console.log("update success: \n" + updateres);
                            res.send("update-one-200");
                        }
                    });    
                }
            });
           
        }
    });
});

module.exports = router;
