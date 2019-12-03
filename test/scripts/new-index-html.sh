#!/usr/bin/env bash

# Title: create index.html
# Author: Stefan Crawford

### function to print multiple blank lines
function lines { yes '' | sed ${1}q ; }

array=( transactionfeeexpenses maxrevisebatchsize successfulreads maxduration index settingscalls renewcalls minsectoraccessprice ProgressDenominator potentialuploadbandwidthrevenue storagerevenue potentialcontractcompensation remainingstorage revisecalls contractcount loststoragecollateral lostrevenue capacity externalmaxduration maxcollateral errorcalls ProgressNumerator mindownloadbandwidthprice  downloadcalls successfulwrites mincontractprice minuploadbandwidthprice failedreads riskedstoragecollateral minbaserpcprice maxdownloadbatchsize failedwrites collateral lockedstoragecollateral contractcompensation uploadbandwidthrevenue potentialstoragerevenue minstorageprice externalmaxdownloadbatchsize windowsize externalmaxrevisebatchsize formcontractcalls unrecognizedcalls downloadbandwidthrevenue capacityremaining potentialdownloadbandwidthrevenue sectorsize totalstorage collateralbudget )

strings=( acceptingcontracts connectabilitystatus externalacceptingcontracts externalnetaddress netaddress path workingstatus )
# no unlockhash

# declare html and create <head>
printf "<!doctype html>
<html lang=\"en\">

<!-- standard head -  -->
<head>
  <meta charset=\"UTF-8\">
  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">    
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <title>SiaPrime Report</title>
  <meta name=\"keywords\" content=\"\">
  <meta name=\"description\" content=\"\">
  <link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\">
  <link rel=\"shortcut icon\" type=\"image/png\" href=\"SPRho_512x512.png\">
</head>"
lines 1

# create <main>
printf "
<!-- main view --><main>"
lines 1

# create <header>
printf "<!-- button/form to refresh graphs (divs) -->
<header>  
  <form class=\"button-pad\" method=\"post\" action=\"/\"><input class=\"button\" type=\"submit\" value=\"Refresh Graphs\"></form>
</header>"
lines 1

# create <section>
printf "<!-- display graphs/figures  -->
<section>"
for i in "${array[@]}"
do
   :
  # figure-graph loop
  printf "<figure class=\"mySlides\" ><figcaption class=\"caption\">\"$i\"</figcaption><form  method=\"post\" action=\"/$i\"><input id=\"$i\"class=\"figure-graph\" src=\"/graphs/graph-$i.svg?\" type=\"image\" value=\"$i\"></form></figure>"
  lines 1
done

for j in "${strings[@]}"
do
   :
   # figure-status loop
printf "<figure class=\"mySlides\"><figcaption class=\"caption\">$j</figcaption><img id=\"$j\" class=\"figure-status\" src=\"/graphs/status-$j.svg\"></figure>"
done
printf "</section>"
lines 1

# create <nav>
printf "<!-- nav/button to display & scroll through graphs (divs containing svg) -->
<nav>
  <button class=\"arrow-back\" onclick=\"plusDivs(-1)\">&#10094;</button>
  <button class=\"arrow-forward\" onclick=\"plusDivs(+1)\">&#10095;</button>
</nav>"
lines 1

# create slide script
printf "<!-- script to display & scroll through graphs (divs) -->
<script>
    var slideIndex = 1;
showDivs(slideIndex);
function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName(\"mySlides\");
  if (n > x.length) {slideIndex = 1}
  if (n < 1) {slideIndex = x.length} ;
  for (i = 0; i < x.length; i++) {
    x[i].style.display = \"none\";
  }
  x[slideIndex-1].style.display = \"block\";
}

</script>"
lines 1

# create refresh script
printf "<!-- script to refresh graphs (svg) -->
<script>
window.onload=function(){"

for k in "${array[@]}"
do
   :
  # figure refresh js loop
  printf "$k=document.getElementById('$k'); setInterval(function(){$k.src=$k.src.replace(/\\\?.*/,function(){return'?'+new Date()})},5000)"
lines 1
done
printf "}
</script>"
lines 1

# close <main> tag
printf "</main>"

exit 0

