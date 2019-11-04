


/* parsing protocal variables setting */
var productData = "";
//var productCount = 0; // 1
var seperator = "|";
var count = -1

/* signal for start parsing */
productData = "parseWebpageOnce.js| starting now"
callNativeApp();


/* find suitable elements of a webpage */
var webPathName = window.location.href;

productData = "parseWebpageOnce.js|webPathName -> " + webPathName
callNativeApp();

if ( webPathName == "https://m.cjthemarket.com/mo/main" ) {
    findMainPageElement();
} else {
    findProductPageElement();
}
    


/* find element of main page  */
function findMainPageElement() {

    //var webPathName = window.location.href;
    var element = document.querySelectorAll(".module-product__li")

    console.log("find main page element()")
    
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
            
            var el = element[i].querySelectorAll(".module-product__title")
            if (el.length > 0) {
                productData = count.toString() + seperator + "prdName" + seperator + el[0].innerText
                callNativeApp()
            }
            
            el = element[i].getElementsByTagName("strong")
            if (el.length > 0) {
                productData = count.toString() + seperator + "prdPrice" + seperator + el[0].innerText
                callNativeApp()
            }
            
            el = element[i].getElementsByTagName("img")
            if (el.length > 0) {
                productData = count.toString() + seperator + "prdImageURL" + seperator + el[0].src
                callNativeApp()
            }
            
        }
    }
    
    productData = "0|FindElementfinished"
    callNativeApp();
    
}



/* find element of product page  */
function findProductPageElement() {
    
    console.log("find product page element()")
    //var webPathName = window.location.href;
    
    var productClassName = [ ".slick-with-video-wrap", ".product-detail__top" ] //  product class name of www.cjthemarekt.com
    var productIdName = [ "section-detail-info", "section-delivery-info", "section-review-info" ]
    
    for (var n = 0; n < productClassName.length; n++) {
        var element = document.querySelectorAll( productClassName[n] );
        for (var i = 0; i < element.length; i++) {
            var r = element[i].getBoundingClientRect();
            
            if ( r.width >= 90 && r.height >= 90 ) {
                count = count + 1
                
                productData = "\n"
                callNativeApp()
                
                productData = count.toString() + seperator + "webPathURL" + seperator + webPathName
                callNativeApp()
                
                productData = count.toString() + seperator + "prdRect" + seperator + r.x.toString() + seperator + r.y.toString() + seperator + r.width.toString() + seperator + r.height.toString()
                callNativeApp()
        
                console.log(productClassName[n], " ", productData)
                
                /* draw rectacgle of product area */
                //drawLine(r.x, r.y, r.width, r.height, 5)
            }
        }
    }
    
    
    for (var n = 0; n < productIdName.length; n++) {
        var element = document.getElementById( productIdName[n] );
        var r = element.getBoundingClientRect();
        
        if ( r.width >= 90 && r.height >= 90 ) {
            count = count + 1
            
            productData = "\n"
            callNativeApp()
            
            productData = count.toString() + seperator + "webPathURL" + seperator + webPathName
            callNativeApp()
            
            productData = count.toString() + seperator + "prdRect" + seperator + r.x.toString() + seperator + r.y.toString() + seperator + r.width.toString() + seperator + r.height.toString()
            callNativeApp()
            console.log(productIdName[n], " ", productData)
            
            /* draw rectacgle of product area */
            drawLine(r.x, r.y, r.width, r.height, 5)
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


