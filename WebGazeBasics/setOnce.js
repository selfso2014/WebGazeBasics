

var ElBody = document.querySelectorAll("body");

var productData = "";
var seperator = "|";

var gazeX = 0;
var gazeY = 0;


/* Add eventListener */
ElBody[0].addEventListener('touchend', onEventUpdate);
//ElBody[0].addEventListener('scroll', onEventUpdate);
//ElBody[0].addEventListener('click', onEventUpdate);
//ElBody[0].addEventListener('transitioned', onEventUpdate);
//ElBody[0].addEventListener('mouseover', onEventUpdate);
//ElBody[0].addEventListener('touchstart', onEventUpdate);
//ElBody[0].addEventListener('touchmove', onEventUpdate);


/* gaze point data transfer preparing */
var divX = document.createElement("div");
divX.className = "gazeX"
var subDivX = document.createElement("div");
subDivX.className = "gazeX|0"
divX.appendChild(subDivX)

var divY = document.createElement("div");
divY.className = "gazeY"
var subDivY = document.createElement("div");
subDivY.className = "gazeY|0"
divY.appendChild(subDivY)

var element = document.querySelectorAll("body");
element[0].appendChild(divX);
element[0].appendChild(divY);


/* Rectangle info to draw rectangle */
var divRect = document.createElement("div");
divRect.className = "rectangle"
var subDivRect = document.createElement("div");
subDivRect.className = "rectXYWH|0|0|0|0"
divRect.appendChild(subDivRect)

element[0].appendChild(divRect)



/* in case of brandi main page */
var el = document.querySelectorAll(".bannerBeforeLoad")   // ".bannerBeforeLoad" //".frame" ".lightSlider"
if (el.length > 0) {
    el[0].style.height = "170px"
    var testR = el[0].getBoundingClientRect()
    productData = "style.height|" + testR.height.toString()
    callNativeApp();
}




/* message sending to WKWebView function */
function callNativeApp() {
    try {
        webkit.messageHandlers.WebViewControllerMessageHandler.postMessage(productData)
    } catch(err) {
        //console.log('The native context does not exist yet');
    }
}



/* event handling */
function onEventUpdate(e) {

    productData = "event|" + e.toString() //+ gazeX.toString() + " " + gazeY.toString()
    callNativeApp()
    console.log("event|", e.toString());
    
    /* get gaze point data */
    var elX = document.querySelectorAll(".gazeX")[0].firstElementChild  //elX.className = "gazeX|4078"
    var elY = document.querySelectorAll(".gazeY")[0].firstElementChild  //elY.className = "gazeY|1234"

    var strX = elX.className;
    var resX = strX.split("|");
    var strY = elY.className;
    var resY = strY.split("|");
    
    var gX = parseInt(resX[1])
    var gY = parseInt(resY[1])
    var gazeX = gX
    var gazeY = gY
    
    productData = "setOnce.js, gazePoint_Int|" + seperator + gazeX.toString() + " " + gazeY.toString()
    callNativeApp()
    console.log("gazeX:", gX, "gazeY:", gY);
    
    
    /* draw rectangle */
    var elRect = document.querySelectorAll(".rectangle")[0].firstElementChild
    var strRect = elRect.className
    var resRect = strRect.split("|")
    var rectX = parseInt(resRect[1])
    var rectY = parseInt(resRect[2])
    var rectW = parseInt(resRect[3])
    var rectH = parseInt(resRect[4])
    
    productData = "setOnce.js, rectXYWHP_Int|" + seperator + rectX.toString() + " " + rectY.toString() + " " + rectW.toString() + " " + rectH.toString()
    callNativeApp()
    console.log("rectXYWH:", rectX, " ", rectY, " ", rectW, " ", rectH);
    
    
    
    /* draw circle on mini canvas */
    var scrollTop = window.pageYOffset;  // scroll y position of full webpage
    
    /* brandi case heading menu fixed effect */
    /*
    if (scrollTop > 137) {
        brandiValue = 51
    } else {
        brandiValue = 0
    }
    */
    
    
    //drawCircle(gazeX, gazeY + scrollTop, 5, "00AA00")  // "00AA00" = green
    
    
    /* draw rectangle */
    if ( rectX != 0 || rectY != 0 || rectW != 0 || rectH != 0 ) {
        //drawRectangle( rectX, rectY, rectW, rectH, 20)
    }
    
    /* find out events info by touched event */
    /* in case of brandi, */
    //sendGazeInFullWebpage(gazeX, gazeY + scrollTop + brandiValue)  // brandi case : brandiValue
    sendGazeInFullWebpage(gazeX, gazeY + scrollTop)
    
    /* needed to be modified
    var e = document.elementFromPoint(gazeX, gazeY);
    productData = "elementFromPoint XY:" + e.x.toString() + " " + e.y.toString()
    callNativeApp();
    drawLine(e.x, e.y, e.width, e.height, 20);
    */

    
}


/* draw circle on mini canvas based on gaze position */
function drawCircle(x, y, r, color) {
    
    const Elbody = document.querySelector('body');
    var canvasEl = document.createElement('canvas');
    canvasEl.style.position = 'absolute';
    canvasEl.style.left = (x-r).toString() + "px"
    canvasEl.style.top = (y-r).toString() + "px"
    canvasEl.width = r * 2
    canvasEl.height = r * 2
    canvasEl.style.zIndex = 1000;

    Elbody.insertBefore(canvasEl, Elbody.firstChild);

    var ctx = canvasEl.getContext("2d");
    ctx.globalAlpha = 0.2;
    ctx.beginPath();
    ctx.arc(r,r,r,0,2*Math.PI);
    ctx.fillStyle = color; //"#00AA00";
    ctx.fill();
    //ctx.stroke();
}



/* draw circle on mini canvas based on gaze position */
function drawRectangle(x, y, w, h, size) {

    drawCrossLine2(x,   y,   size, "#FFFF00")
    //drawCrossLine2(x+w, y,   size, "#00FFFF")
    //drawCrossLine2(x+w, y+h, size, "#FFFF00")
    //drawCrossLine2(x,   y+h, size, "#00FFFF")
    
}


/* unit drawCrossLine */
function drawCrossLine2(x, y, size, color) {
    
    const Elbody = document.querySelector('body');
    var canvasEl = document.createElement('canvas');
    canvasEl.style.position = 'absolute';
    
    canvasEl.style.left = (x-size).toString() + "px"
    canvasEl.style.top = (y-size).toString() + "px"
    
    canvasEl.width = size * 2
    canvasEl.height = size * 2
    
    canvasEl.style.zIndex = 1000;

    Elbody.insertBefore(canvasEl, Elbody.firstChild);

    var c = canvasEl;
    var ctx = canvasEl.getContext("2d");
    ctx.globalAlpha = 0.8;
    ctx.strokeStyle = color; //"#FF0000";

    ctx.moveTo(0, size);
    ctx.lineTo(size * 2, size);
    ctx.stroke();
    
    ctx.moveTo(size, 0);
    ctx.lineTo(size, size * 2);
    ctx.stroke();

}




function sendGazeInFullWebpage(x, y) {
    productData = "0|gazeWeb" + seperator + x.toString() + seperator + y.toString() 
    callNativeApp();
}



function findProductGazed(x, y) {
    /*
    var e = document.elementFromPoint(x, y);
    productData = "elementFromPoint: " + e.src
    callNativeApp();
    drawCircle(e.x, e.y, 10, "FF0000")
    */
    
    
}



function findProductGazed2() {
    
    //var Elproduct = document.querySelectorAll(".feed-item") //.feed-item
    var Elproduct = document.getElementsByTagName("img")
    
    var elX = document.querySelectorAll(".gazeX")[0].firstElementChild  //elX.className = "gazeX|4078"
    var elY = document.querySelectorAll(".gazeY")[0].firstElementChild  //elY.className = "gazeY|1234"
    
    productData = "findProductGazed(), gaze_selfso" + seperator + elX.className + " " + elY.className
    callNativeApp()
    
    console.log("gazeX:", elX.className, "gazeY:", elY.className);
    var strX = elX.className;
    var resX = strX.split("|");
    var strY = elY.className;
    var resY = strY.split("|");
    
    //productData = "gaze_selfso_Int" + seperator + resX + " " + resY
    //callNativeApp()
    
    var gX = parseInt(resX[1])
    var gY = parseInt(resY[1])
    
    var gazeX = gX
    var gazeY = gY
    
    
    for (var i = 0; i < Elproduct.length; i++) {
        
        var r = Elproduct[i].getBoundingClientRect();
        var b = document.body.getBoundingClientRect();
        var bTop = b.top
        var offsetY = r.top - b.top;
        
        
        if (i > 100 && i < 250 ) {
            productData = "findProductGazed(), offsetY: " + offsetY.toString() + " b.top:" + b.top.toString() + " gazeXY: " + gazeX.toString() + " " + gazeY.toString() + " r.x:" + r.x.toString() + " r.y:" + r.y.toString() + " r.width:" + r.width.toString() + " r.height:" + r.height.toString()
            callNativeApp()
            
        }
        
        if (gazeX > r.x - 20  && gazeX < r.x + r.width + 20 && gazeY > r.y - 50 && gazeY < r.y + r.height + 50 ) {
            //var productName = Elproduct[i].getElementsByClassName("name")[0].outerText
            //var productURL = Elproduct[i].getElementsByTagName("a")[0].href
            
            productData = "Product_Found" + seperator + "test"
            //productData = "Found! default productName" + seperator + productName + " gazeXY:" + gazeX.toString() + " " + gazeY.toString() + " " + productURL
            callNativeApp()
            console.log("Found Product! name:,", productData)
        }
    }
}



