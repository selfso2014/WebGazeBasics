


/* parsing protocal variables setting */
var productData = "";
var productCount = 0; // 1
var seperator = "|";


/* signal for start parsing */
productData = "parseWebpageOnce.js| starting now"
callNativeApp();


/* find suitable elements of a webpage */
findElement();


/* find element function */
function findElement() {  // www.brandi.co.kr

    /* in case of brandi main page */
    var elmt = document.querySelectorAll(".bannerBeforeLoad")   // ".bannerBeforeLoad" //".frame" ".lightSlider"
    if (elmt.length > 0) {
        elmt[0].style.height = "170px"
        var elmtRect = elmt[0].getBoundingClientRect()
        productData = "style.height|" + elmtRect.height.toString()
        callNativeApp();
    }
    
    //var elClass = document.querySelectorAll(".frame")
    //var element = elClass[2].getElementsByTagName("img")
    var element = document.getElementsByTagName("ul") //document.getElementsByTagName("img")
    /* ending configurations of www.brandi.co.kr */
    
    
    var count = -1
    var webPathName = window.location.href;
    
    console.log(productData)
    
    for (var i = 0; i < element.length; i++) {
        var r = element[i].getBoundingClientRect();
       
        var b = document.body.getBoundingClientRect();
        var offsetY = r.top - b.top;
        
        if ( r.width >= 90 && r.height >= 90 ) {
            count = count + 1
            
            productData = "\n"
            callNativeApp()
            
            productData = count.toString() + seperator + "webPathURL" + seperator + webPathName
            callNativeApp()
            
            productData = count.toString() + seperator + "prdRect" + seperator + r.x.toString() + seperator + r.y.toString() + seperator + r.width.toString() + seperator + r.height.toString()
            callNativeApp()
            console.log(productData)
            
            /* draw rectacgle of product area */
            //drawLine(r.x, r.y, r.width, r.height, 5)
            
            var el = element[i].querySelectorAll(".list_title")
            if (el.length > 0) {
                var str = el[0].innerText
                var tempStr = ""
                for (var j = 0; j < str.length - 1; j++) {
                    tempStr = tempStr + str.charAt(j)
                }
                productData = count.toString() + seperator + "prdName" + seperator + tempStr //el[0].innerText //tempStr //
                callNativeApp()
            }
            
            el = element[i].querySelectorAll(".normal_price")
            if (el.length > 0) {
                productData = count.toString() + seperator + "prdPrice" + seperator + el[0].innerText
                callNativeApp()
            }
            
            el = element[i].querySelectorAll(".list_seller")
            if (el.length > 0) {
                productData = count.toString() + seperator + "prdSeller" + seperator + el[0].innerText
                callNativeApp()
            }
            
            el = element[i].getElementsByTagName("img")
            if (el.length > 0) {
                productData = count.toString() + seperator + "prdImageURL" + seperator + el[0].src
                callNativeApp()
            }
            
            /*
            var prdCategory = element[i].parentElement.parentElement.querySelector(".title").innerText
            if (prdCategory.length > 0) {
                productData = count.toString() + seperator + "prdCategory" + seperator + prdCategory
                callNativeApp()
            }
            */
        }
    }
    
    productData = "0|FindElementfinished"
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





/* draw circle on mini canvas based on gaze position */
function drawLine(x, y, w, h, size) {

    drawCrossLine(x,   y,   size, "#FF0000")
    drawCrossLine(x+w, y,   size, "#00FF00")
    drawCrossLine(x+w, y+h, size, "#FF0000")
    drawCrossLine(x,   y+h, size, "#00FF00")
    
}


/* unit drawCrossLine */
function drawCrossLine(x, y, size, color) {
    
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



/*
var e = document.elementFromPoint(300, 500);
productData = "elementFromPoint: " + e.src
callNativeApp();
drawLine(e.x, e.y, e.width, e.height, 20);
*/


