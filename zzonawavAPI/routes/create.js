var express = require('express');
var router = express.Router();

var MongoClient = require('mongodb').MongoClient; // is property;
var cs = 'mongodb+srv://zaneStanutz:MMX2Unrs5qSA4Pu@cluster0.gyh41.mongodb.net/myFirstDatabase?retryWrites=true&w=majority';

router.post('/', function(req, res, next) {
    var email = req.body.email;
    var password = req.body.password;
    var name = req.body.name;
    console.log("Data Comming in: \n" + email + "\n" + password + "\n" + name );
    MongoClient.connect(cs, function(err,db){
        if(err){
            console.log("err-on-connect:\n" + err);
        }
        else{
            var database = db.db('zzonawavapi');
            var query = {email: email};
            database.collection('users').findOne(query, function(finderr,findres){
                if(finderr){
                    console.log(finderr);
                }
                console.log("findOne result:\n" + findres);
                if(findres){
                    res.send("user-exists");
                }
                else{
                    newUserObject = {email: email , password: password, name: name };
                    database.collection('users').insertOne(newUserObject, function(errInsert, resInsert){
                        if(errInsert){
                            console.log(errInsert);
                            res.send("insert-failed");
                        }
                        else{
                            console.log(resInsert);
                            res.send("insert-successful");
                        }
                    }); 
                }
            });
        }
    });

});

module.exports = router;