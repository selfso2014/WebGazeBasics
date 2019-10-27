


var webPathName = window.location.pathname;
var productData = "";

var ElBody = document.querySelectorAll("body");
var ElBrandSection = document.querySelectorAll(".brand_section");
var ElSwiperWrapper = document.querySelectorAll(".swiper-wrapper");

var brandSectionScrollX = null;
var swiperWrapperX = null;

var productCount = 0; // 1
var seperator = "|";

var gazeX = 100;
var gazeY = 100;

//var isScriptInjected = false;

/* Add eventListener */
ElBody[0].addEventListener('scroll', onEventUpdate);
ElBody[0].addEventListener('click', onEventUpdate);
//ElBody[0].addEventListener('mouseover', onEventUpdate);
//ElBody[0].addEventListener('touchstart', onEventUpdate);
//ElBody[0].addEventListener('touchmove', onEventUpdate);
ElBody[0].addEventListener('touchend', onEventUpdate);
ElBody[0].addEventListener('transitioned', onEventUpdate);

for (var i = 0; i < ElBrandSection.length; i++) {
    ElBrandSection[i].addEventListener('scroll', onEventUpdate);
}


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



/* find out webpage category */
console.log("webpage PathName:", webPathName);
var pageCategory = "";
if (webPathName.includes("mai") == true) {
    
    pageCategory = "main";
    console.log("Main page");
    productData = "Main_page,test";
    callNativeApp();
    
    var productClassName = [".swiper-container-horizontal", ".module-product__li", ".main__section-contents", ".main__section", ".main__cookit", ".main__section--none-horizon", ".main__section--none-horizon", ".main__section--none-horizon", ".main__section--none-horizon", ".main__section-header--flex"]
    // [".main__visual swiper-container swiper-container-horizontal", "module-product__li ", "main__section-contents", "main__section", "main__cookit", "main__section main__section--none-horizon", "main__section main__section--none-horizon", "main__section main__section--none-horizon", "main__section main__section--none-horizon", "main__section-header main__section-header--flex"]
    //[".swiper-slide", ".feed-item"]; // ".swiper-slide.swiper-slide-active", ".footer_m"
    
} else if (webPathName.includes("pro") == true) {
    
    pageCategory = "product"
    console.log("Product detail page")
    productData = "Product_detail_page,test"
    callNativeApp()
    
    var productClassName = [".slick-with-video--product", ".product-detail__top", ".product-detail__section--pb0", ".product-detail__section", ".productReviewArea"] //[".item_detail_view", ".detail_info_area", ".detail_item_wrap", ".brand_section", ".review_section", ".qa_section", ".evt_connent", ".detail_item_recommend", ".post_more"]
    
} else {
    
    pageCategory = "category"
    console.log("Other page")
    productData = "Other_page,test"
    callNativeApp()
    
    var productClassName = [".swiper-slide", ".issue_banner_in", ".content_cnt", ".post_more", ".item_img_view", ".item_detail_view", ".detail_info_area", ".detail_item_wrap", ".brand_section", ".review_section", ".qa_section", ".evt_connent", ".detail_item_recommend"]  // ".swiper-slide.swiper-slide-active"
    
}




findProductPageInfo();

findProduct();




function findProductPageInfo() {

    for (var n = 0; n < productClassName.length; n++) {
        var Elproduct = document.querySelectorAll( productClassName[n] )
        
        for (var i = 0; i < Elproduct.length; i++) {
            
            var r = Elproduct[i].getBoundingClientRect();
            var b = document.body.getBoundingClientRect();
            var offsetY = r.top - b.top;
            
            /* only once triggering productCount */
            productCount = productCount + 1;
            productData = "productIndex" + seperator + productCount.toString()  // Should be sent by first to match producIndex
            callNativeApp()
            
            productData = "pageCategory" + seperator + pageCategory  // page category setting
            callNativeApp()
            
            productData = "className" + seperator + productClassName[n]
            callNativeApp()
            
            productData = "rectXYWH"+ seperator + r.x.toString() + seperator + offsetY.toString() + seperator + r.width.toString() + seperator + r.height.toString()
            callNativeApp()
            
            console.log("el.top", r.top, " body.top", b.top, " className:", productClassName[n], " rectXYWH:", productData)
           
            
        }
    }
    
    console.log("findProductInfo() ending part")
}



/* findProduct function */
function findProduct() {
    
    var productClassName = [".module-product__li"] //[".swiper-container-horizontal", ".module-product__li", ".main__section-contents", ".main__section", ".main__cookit", ".main__section--none-horizon", ".main__section--none-horizon", ".main__section--none-horizon", ".main__section--none-horizon", ".main__section-header--flex"]
    //[".slick-with-video--product", ".product-detail__top", ".product-detail__section--pb0", ".product-detail__section", ".productReviewArea"] //[".prd_s", ".prd_bd", ".prd_b"];  // product class name of www.21cm.co.kr
    for (var n = 0; n < productClassName.length; n++) {
        var Elproduct = document.querySelectorAll( productClassName[n] )
        
        for (var i = 0; i < Elproduct.length; i++) {
            /* find out size and position for each product */
            var r = Elproduct[i].getBoundingClientRect();
            var b = document.body.getBoundingClientRect();
            var offset = r.top - b.top;  // r.y
            var imageURL = ""
            var productName = ""
            
            console.log("findProduct(), for-loop", i, productClassName[n], Elproduct[i])
            
            /* find image source URL */
            //var imageURL = Elproduct[i].getElementsByTagName("img")[0].currentSrc
            if ( productClassName[n] == ".module-product__li" ) {
                imageURL = Elproduct[i].children[0].children[0].children[0].currentSrc
                productName = Elproduct[i].children[0].children[0].children[0].alt
                
                console.log("findProduct(), moduel-product__li class", i, imageURL, productName)
            }
            
            /* find brand */
            //var brand = Elproduct[i].getElementsByClassName("brand")[0].outerText
            
            /* find productName */
            //var productName = Elproduct[i].getElementsByClassName("name")[0].outerText
             
            /* find price */
            //var price = Elproduct[i].getElementsByClassName("price")[0].outerText
            
            /* find product link page URL */
            //var productURL = Elproduct[i].getElementsByTagName("a")[0].href
            
            
            /* saving to productData string */
            productCount = productCount + 1;
            productData = "productIndex" + seperator + productCount.toString()  // Should be sent by first to match producIndex
            callNativeApp()
            
            //productData = "className" + seperator + productClassName[n]
            //callNativeApp()
            
            //productData = "productURL" + seperator + productURL
            //callNativeApp()
            
            //productData = "brand" + seperator + brand
            //callNativeApp()
            
            productData = "imageURL" + seperator + imageURL
            callNativeApp()
            
            productData = "rectXYWH" + seperator + r.x.toString() + seperator + offset.toString() + seperator + r.width.toString() + seperator + r.height.toString()
            callNativeApp()
            //console.log("className:", productClassName[n], "rectXYWH:", productData)
            
            //productData = "price" + seperator + price
            //callNativeApp()
            
            productData = "productName" + seperator + productName
            callNativeApp()
            
            //console.log("className:", productClassName[n], "rectXYWH:", productData)
            console.log("findProduct(), imageURL: productName:",  imageURL, productName)
            
        }
    }
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

    
    var elX = document.querySelectorAll(".gazeX")[0].firstElementChild  //elX.className = "gazeX|4078"
    var elY = document.querySelectorAll(".gazeY")[0].firstElementChild  //elY.className = "gazeY|1234"
    
    //productData = "gaze_selfso" + seperator + elX.className + " " + elY.className
    //callNativeApp()
    
    console.log("gazeX:", elX.className, "gazeY:", elY.className);
    var strX = elX.className;
    var resX = strX.split("|");
    var strY = elY.className;
    var resY = strY.split("|");
    
    productData = "gaze_selfso_Int" + seperator + resX + " " + resY
    callNativeApp()
    
    var gX = parseInt(resX[1])
    var gY = parseInt(resY[1])
    
    var gazeX = gX
    var gazeY = gY
    
    console.log("gazeX:", gX, "gazeY:", gY);
    
    /*
    var el = document.querySelectorAll(".gaze")
    for (var i = 0; i < el.length; i++) {
        productData = el[i].className + seperator + "test_selfso"
        callNativeApp()
        console.log("Injdected ClassName:,", productData)
    }
    */
    
    console.log("gaze_xy,", gazeX, gazeY);
    
    /* find out events info by touched event */
    findProductGazed()
    
}




function findProductGazed() {
    
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



