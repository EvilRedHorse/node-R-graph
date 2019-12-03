var express = require("express");
var app = express();
var router = express.Router();
var path = __dirname + '/test/';
//var favicon = require('serve-favicon');

// shelljs to execute server-side bash scripts
const shell = require('shelljs')

var all = function() {
  // do something
  shell.exec('test/scripts/graph.sh');
};
router.post('/', function(req,res) {
  // regraph all - sending a response does not pause the function
  all();
  // The HTTP 204 No Content success status response code indicates that the request has succeeded, but that the client doesn't need to go away from its current page.
  console.log("/" + req.method + "Sending 204 Status");
  res.status(204).send();
});

// allow for refreshing individual graphs with POST /[Y-AXIS]
yaxis = [ 'transactionfeeexpenses', 'maxrevisebatchsize', 'successfulreads', 'maxduration', 'index', 'settingscalls', 'renewcalls', 'minsectoraccessprice', 'ProgressDenominator', 'potentialuploadbandwidthrevenue', 'storagerevenue', 'potentialcontractcompensation', 'remainingstorage', 'revisecalls', 'contractcount', 'loststoragecollateral', 'lostrevenue', 'capacity', 'externalmaxduration', 'maxcollateral', 'errorcalls', 'ProgressNumerator', 'mindownloadbandwidthprice', 'downloadcalls', 'successfulwrites', 'mincontractprice', 'minuploadbandwidthprice', 'failedreads', 'riskedstoragecollateral', 'minbaserpcprice', 'maxdownloadbatchsize', 'failedwrites', 'collateral', 'lockedstoragecollateral', 'contractcompensation', 'uploadbandwidthrevenue', 'potentialstoragerevenue', 'minstorageprice', 'externalmaxdownloadbatchsize', 'windowsize', 'externalmaxrevisebatchsize', 'formcontractcalls', 'unrecognizedcalls', 'downloadbandwidthrevenue', 'capacityremaining', 'potentialdownloadbandwidthrevenue', 'sectorsize', 'totalstorage', 'collateralbudget' ];

yaxis.forEach(function(value){

  var refresh = function() { 
    shell.exec('test/scripts/graph.sh ' + value);
  };
  router.post('/' + value, function(req,res) {
    // regraph one - sending a response does not pause the function
    refresh();
    // The HTTP 204 No Content success status response code indicates that the request has succeeded, but that the client doesn't need to go away from its current page.
    console.log("/" + value + req.method + "Sending 204 Status");
    res.status(204).send();
  });

});

router.use(function (req,res,next) {
  console.log("/" + req.method);
  next();
});

router.get("/",function(req,res){
  res.sendFile(path + "index.html");
});

app.use("/",router);

app.use(express.static(__dirname + '/test'));

// app.use(favicon(__dirname + '/test/images/favicon.ico'));

app.use("*",function(req,res){
  res.sendFile(path + "index.html");
});

app.listen(3030,function(){
  console.log("Live at Port 3030");
});
