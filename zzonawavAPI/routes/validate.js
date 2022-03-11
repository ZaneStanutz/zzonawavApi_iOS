var express = require('express');
var router = express.Router();


var MongoClient = require('mongodb').MongoClient; // is property;
var cs = 'mongodb+srv://zaneStanutz:MMX2Unrs5qSA4Pu@cluster0.gyh41.mongodb.net/myFirstDatabase?retryWrites=true&w=majority';

router.post('/', function(req, res){

    var email = req.body.email;
    var password = req.body.password;
    console.log(email + "type: " + typeof(email));
    console.log(password + "type: " + typeof(password));
   
    testEmail = "stanutz.stanutz@gmail.com";
    testPass = "password";

    MongoClient.connect(cs, function(err, db){
        if(err){
            console.log(err);
        }
        let database = db.db('zzonawavapi');
        let query = {$and:[{email: email, password: password }]};
        database.collection('users').findOne(query, function(finderr, findres){
            if(finderr){
               console.log("findOne err: " + finderr); 
            }
            if(findres){
                res.send('200-valid-user');
                console.log(findres._id);
            }
            else {
                console.log(findres);
                res.send('404-invalid-user');
            }
        });
    

    // UserName Pass in body... perform query return result
    }); // .connect()

}); // .post()

module.exports = router


