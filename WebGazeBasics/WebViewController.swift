//
//  WebViewController.swift
//  TestWebScreenCapture
//
//  Created by Steve on 14/07/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//


import Foundation
import UIKit
import WebKit
import ObjectiveC


/* webAnalsys setting */
var webAnalysis: WebAnalsys = WebAnalsys()

// to saving data to a file
var strData: String = ""
var gazePointInjected: Bool = false




class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate, UIScrollViewDelegate{
    
    /* webView setting */
    var webView: WKWebView!
    private var webViewContentIsRequested = false
    var newPageLoadingIndex: Int = -1
    
    // web page full screen size
    var currentContentSize: CGSize = CGSize(width: screenWidth, height: screenHeight)
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.webView = {
            let contentController = WKUserContentController()
            
            contentController.add(self, name: "WebViewControllerMessageHandler")
            
            let configuration = WKWebViewConfiguration()
            configuration.userContentController = contentController
            
            let webView = WKWebView(frame: .zero, configuration: configuration)
            webView.scrollView.bounces = false
            webView.navigationDelegate = self
            
            return webView
        }()
    }
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View Load : WebVie Load!")
        /* loading webView */
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        /* add tap gesture recogziger */
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTap) )
        tapGesture.delegate = self
        webView.addGestureRecognizer(tapGesture)
        webView.allowsBackForwardNavigationGestures = true
        
        /* Setting & loading web page URL to be analyzed */
        let initialURL = webAnalysis.getURL(index: 0)
        let request = URLRequest(url: initialURL as URL)
        webView.load(request)

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func loadURL(url: URL){
        let request = URLRequest(url: url as URL)
        webView.load(request)
    }
    
    
    
    /* get web page position offset information */
    func getCurrentOffset() -> CGPoint {
        print("getCurrentOffset: \(self.webView.scrollView.contentOffset)")
        return self.webView.scrollView.contentOffset
        
    }
    
    
    /* get web page contentsize information */
    func getContentSize() -> CGSize {
        return self.webView.scrollView.contentSize
    }
    
    
    
    /* Display gaze points in front of web page */
    func displayGazePoints(index: Int) {
        
        let currentPageIndex = webAnalysis.getCurrentPageIndex()
        let contentSize = webAnalysis.getContentSize(index: currentPageIndex)
        print("@displayGazePoints(), current page index: \(currentPageIndex), contentSize: \(contentSize) ")
        
        /* draw gaze points with javascript */
        let fromIndex = webAnalysis.getFromIndex(index: index) //webData[index].fromIndex
        let toIndex = webAnalysis.getToIndex(index: index) //webData[index].toIndex
        if toIndex < 0 { return }
        var tempPoint: Point
        var tempColor: String
        var tempRadius: Int
        var fixationCount: Int = 0
        var allJavascript: String = ""
        
        for i in fromIndex...toIndex {
            tempPoint = storage.getGazePointOfFullWebpage(index: i)
            if storage.isLongFixationWebFlag(index: i) {
                tempColor = "red"
                tempRadius = 15
                fixationCount += 1
            } else if storage.isFixationWebFlag(index: i) {
                tempColor = "orange"
                tempRadius = 10
            } else {
                tempColor = "green"
                tempRadius = 3
            }
            let javascript =
                "ctx.beginPath();" +
                    "ctx.arc(" + String(tempPoint.x) + "," + String(tempPoint.y) + ", " + String(tempRadius) + ", 0, 2 * Math.PI);" +
                    "ctx.fillStyle = '" + tempColor + "';" +
            "ctx.fill();"
            
            allJavascript += javascript
            
            evaluateJavascript(javascript, sourceURL: "getOuterHTML")
            
        }
        
        
    }
    
    
    
    
    /* display product information about web page */
    func getProductInfo(index: Int) -> String {
        let index = webAnalysis.getCurrentPageIndex()
        let prdIndex = webAnalysis.getProductDataCount(index: index) - 1 // webData[index].productData.count - 1
        var allJavascript: String = ""
        
        /* drawing product information */
        for i in 0...prdIndex {
            //let x = webData[index].productData[i].x
            //let y = webData[index].productData[i].y
            //let w = webData[index].productData[i].width
            //let h = webData[index].productData[i].height
            let (x, y, w, h) = webAnalysis.getProductDataRect(index: index, prdIndex: i)
            let productName = webAnalysis.getProductDataPrdName(index: index, prdIndex: i)
            let price = webAnalysis.getProductDataPrice(index: index, prdIndex: i)
            let javascript =
                "ctx.beginPath();" +
                    "ctx.lineWidth = \"4\";" +
                    "ctx.strokeStyle = \"green\";" +
                    "ctx.rect(\(x), \(y), \(w), \(h));" +
                    "ctx.stroke();" +
                    
                    "ctx.font = \"15px Arial\";" +
                    "ctx.fillStyle = \"red\";" +
                    "ctx.fillText(\"" +  productName  + "\"," + "\(x)," + "\(y + 10));" +
                    
                    //"ctx.font = \"15px Arial\";" +
                    //"ctx.fillStyle = \"red\";" +
                    "ctx.fillText(\"" +  price  + "\"," + "\(x)," + "\(y + 20));"
            
            /*
             productData = "imageURL," + imageURL;
             callNativeApp();
             
             productData = "rectXYWH," + r.x.toString() + "," + offset.toString() + "," + r.width.toString() + "," + r.height.toString();
             callNativeApp();
             
             productData = "price," + price;
             callNativeApp();
             
             productData = "productName," + productName;
             callNativeApp();
             */
            
            
            
            allJavascript += javascript
            
            //evaluateJavascript(javascript, sourceURL: "getOuterHTML")
            //print("@displayProductInfo(),  #\(i) rectXYWH: \(x) \(y) \(w) \(h)")
        }
        return allJavascript
    }
    
    
    
    // WKNavigationDelegate.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        let urlStr = webView.url
        
        
        
        if webAnalysis.getAnalysisStatus() == false {
            newPageLoadingIndex += 1  // set first page loading as 0
            webAnalysis.setCurrentPageIndex(pageIndex: newPageLoadingIndex)
            
            
            /* saving web data to previous web page */
            if newPageLoadingIndex == 0 {
                webAnalysis.setWebDataURL(index: 0, url: webView.url!) // save current url
                webAnalysis.setFromIndex(index: 0, fromIndex: storage.getIndex())
                
            } else if newPageLoadingIndex > 0 {
                /* previous web page data saving  */
                var index = webAnalysis.getWebDataCount() - 1
                webAnalysis.setToIndex(index: index, toIndex: storage.getIndex())
                webAnalysis.setWebData(index: index)
                
                print("@webView if..yes, Loading URL: \(webAnalysis.getURL(index: webAnalysis.getWebDataCount() - 1)) currentPageIndex: \(webAnalysis.getCurrentPageIndex()) webData.count - 1 : \(webAnalysis.getWebDataCount() - 1)")
                let currentPageIndex = webAnalysis.getCurrentPageIndex()
                //webAnalysis.printProductData(index: currentPageIndex - 1)
                
                /* new loaded web page data preparing  */
                webAnalysis.appendWebData(url: webView.url!, pageIndex: newPageLoadingIndex)  // new webData appending
                index = webAnalysis.getWebDataCount() - 1
                webAnalysis.setWebDataURL(index: index, url: webView.url!) // save current url
                webAnalysis.setFromIndex(index: index, fromIndex: storage.getIndex())
            }
            
            print("@webView, newPageLoadingIndex: \(newPageLoadingIndex)  webAnalsys.getWebDataCount() - 1 : \(webAnalysis.getWebDataCount() - 1 )  webAnalysis.getCurrentPageIndex(): \(webAnalysis.getCurrentPageIndex()) contentSize: \(getContentSize())")
        }
        
        
        print("Loading URL: \(urlStr) currentPageIndex: \(webAnalysis.getCurrentPageIndex()) webData.count - 1 : \(webAnalysis.getWebDataCount() - 1)")
        let currentPageIndex = webAnalysis.getCurrentPageIndex()
        //webAnalysis.printProductData(index: currentPageIndex)
        
    }
    
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
        let urlStr = webView.url
        print("URL: \(urlStr) \n")
        
        if webAnalysis.getAnalysisStatus() == true {
            /*
             let currentPageIndex = webAnalysis.getCurrentPageIndex()
             let javascript = "" //getProductInfo(index: currentPageIndex)
             let size = webAnalysis.getContentSize(index: currentPageIndex)
             javascriptInjection(file: "StyleScript", canvasSize: size, js: javascript)
             displayGazePoints(index: currentPageIndex)
             print("#webView didStartProvisionalNavigation end")
             */
        }
    }
    
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print(#function)
        
        if webAnalysis.getAnalysisStatus() == false {
            /* in case of gaze data saving session */
            let index = webAnalysis.getWebDataCount() - 1
            webAnalysis.setContentSize(index: index, size: getContentSize()) // saving contentSize only!
            print("@webView, didFinish, newPageLoadingIndex: \(newPageLoadingIndex)  webAnalsys.getWebDataCount() - 1 : \(webAnalysis.getWebDataCount() - 1 )  webAnalysis.getCurrentPageIndex(): \(webAnalysis.getCurrentPageIndex()) contentSize: \(getContentSize())")
            
            print("@webView didFinish, Loading URL: \(webAnalysis.getURL(index: index)) currentPageIndex: \(webAnalysis.getCurrentPageIndex()) webData.count - 1 : \(webAnalysis.getWebDataCount() - 1)")
            let currentPageIndex = webAnalysis.getCurrentPageIndex()
            //webAnalysis.printProductData(index: currentPageIndex)
            
        } else {
            /* in case of gaze points display session */
            let currentPageIndex = webAnalysis.getCurrentPageIndex()
            let size = webAnalysis.getContentSize(index: currentPageIndex)
            print("canvasSize: \(size)")
            
            if surveyMode == false {
                /* javascript injection */
                print("@webView didfinish end, javascript injection with StyleScript file will start")
                javascriptInjection(file: "StyleScript", canvasSize: size, js: "")
                displayGazePoints(index: currentPageIndex)
            }
            print("@@webView didfinish end")
        }
        
        webViewContentIsRequested = true
    }
    
    
    
    // WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        //print("@userContentController: \(message.body) \n")
        
        let str: String = message.body as! String
        let index = webAnalysis.getCurrentPageIndex()
        let prdIndex = webAnalysis.getProductDataCount(index: index)
        let tempPageIndex = webAnalysis.getCurrentPageIndex()
        
        let currentOffset = getCurrentOffset()
        
        webAnalysis.setProductData(index: index, str: str)
    }
    
    
    
    /* javascript injection function */
    func evaluateJavascript(_ javascript: String, sourceURL: String? = nil, completion: ((_ error: String?) -> Void)? = nil) {
        var javascript = javascript
        
        // Adding a sourceURL comment makes the javascript source visible when debugging the simulator via Safari in Mac OS
        if let sourceURL = sourceURL {
            javascript = "//# sourceURL=\(sourceURL).js\n" + javascript
        }
        
        webView.evaluateJavaScript(javascript) { _, error in
            completion?(error?.localizedDescription)
        }
    }
    
    
    
    /* javasciprt injection to set canvas for drawing */
    func javascriptInjection(file: String, canvasSize: CGSize, js: String) {
        
        /* add javaScript from 'FILE_NAME.js' file */
        // StyleScript.js : Basic setting
        guard let scriptPath = Bundle.main.path(forResource: file, ofType: "js"),  //StyleScript", ofType: "js"),
            let scriptSource = try? String(contentsOfFile: scriptPath) else { return }
        let contentController = WKUserContentController()
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        
        /* making canvas in webpage with javascript */
        // Setting size of canvas at javascript
        var javascript: String  =
            "canvasEl.width = " + String(Int(canvasSize.width)) + ";" +
                "canvasEl.height = " + String(Int(canvasSize.height)) + ";"
        
        
        
        javascript = scriptSource + javascript + js
        
        evaluateJavascript(javascript, sourceURL: "getOuterHTML")
        print("@javascriptInjection(file:size:), file: \(file) contentSize:\(canvasSize)")
    }
    
    
    
    /* touch gesture recgonizer for more analysis */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("@gestureRcognizer, ...")
        
        switch gestureRecognizer.state {
        case .began:
            print("began")
        case .cancelled:
            print("cancelled")
        case .changed:
            print("changed")
        case .ended:
            print("ended")
        case .failed:
            print("failed")
        case .possible:
            print("possible")
            let p = gestureRecognizer.location(in: self.webView)
            print("@gestrureRecognizer, x:\(p.x) y:\(p.y)")
            
            //print(" content_size:\(getContentSize())  currentContentSize: \(currentContentSize)   offset_size: \(getCurrentOffset())" )
            //if webAnalysis.getAnalysisStatus() == false {
            if currentContentSize != getContentSize() && webAnalysis.getAnalysisStatus() == false {
                currentContentSize = getContentSize()
                
                /* to get ProductInfo by injecting javascript */
                javascriptInjection2(file: "CJTheMarket", canvasSize: CGSize(width: 0, height: 0), js: "")
                //javascriptInjection2(file: "AreaScript2", canvasSize: CGSize(width: 0, height: 0), js: "")
                let currentPageIndex = webAnalysis.getCurrentPageIndex()
               
            }
            
            
        @unknown default:
            print("Fatal Error!!!")
        }
        
        return true
    }
    
    
    /* touch event call function  */
    @objc func onTap(gesture:UITapGestureRecognizer) -> Void {
        if(gesture.state == .ended){
            let touchPoint: CGPoint = gesture.location(in: view)
            let scrollPoint: CGPoint = gesture.location(in: webView!.scrollView)
            let zoomScale: CGFloat = webView!.scrollView.zoomScale
            // Now do something with this gesture information
            print("@onTap, gesture ended")
        }
        if(gesture.state == .failed){
            let touchPoint: CGPoint = gesture.location(in: view)
            let scrollPoint: CGPoint = gesture.location(in: webView!.scrollView)
            let zoomScale: CGFloat = webView!.scrollView.zoomScale
            // Now do something with this gesture information
            print("@onTap, gesture failed")
        }
    }
    
    
    /* touch event call function  */
    @objc func viewTap() {
        let contentOffset = webView.scrollView.contentOffset
        let out = webView.scrollView.contentScaleFactor
        print("View Tap selfso  contentOffset:\(contentOffset) contentScaleFacgor:\(out)")
    }
    
    
    
    /*
     /* display product information about web page */
     func displayProductInfo(index: Int) {
     let prdIndex = webAnalysis.getProductDataCount(index: index) - 1 // webData[index].productData.count - 1
     print("@displayProductInfo(), index: \(index)  proIndex: \(prdIndex)")
     
     //javascriptInjection()
     
     var allJavascript: String = ""
     
     /* drawing product information */
     for i in 0...prdIndex {
     //let x = webData[index].productData[i].x
     //let y = webData[index].productData[i].y
     //let w = webData[index].productData[i].width
     //let h = webData[index].productData[i].height
     let (x, y, w, h) = webAnalysis.getProductDataRect(index: index, prdIndex: i)
     let javascript =
     "ctx.beginPath();" +
     "ctx.lineWidth = \"4\";" +
     "ctx.strokeStyle = \"green\";" +
     "ctx.rect(\(x), \(y), \(w), \(h));" +
     "ctx.stroke();"
     
     allJavascript += javascript
     
     evaluateJavascript(javascript, sourceURL: "getOuterHTML")
     //print("@displayProductInfo(),  #\(i) rectXYWH: \(x) \(y) \(w) \(h)")
     }
     
     }
     */
    
    
}





/* javasciprt injection to set canvas for drawing */
func javascriptInjection2(file: String, canvasSize: CGSize, js: String) {
    
    /* add javaScript from 'FILE_NAME.js' file */
    // StyleScript.js : Basic setting
    guard let scriptPath = Bundle.main.path(forResource: file, ofType: "js"),  //StyleScript", ofType: "js"),
        let scriptSource = try? String(contentsOfFile: scriptPath) else { return }
    let contentController = WKUserContentController()
    let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    contentController.addUserScript(script)
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    
    /* making canvas in webpage with javascript */
    // Setting size of canvas at javascript
    var javascript: String  = ""
    
    
    javascript = scriptSource + javascript + js
    
    webViewController.evaluateJavascript(javascript, sourceURL: "getOuterHTML")
    //print("@javascriptInjection2(file:size:), file: \(file) canvasSize:\(canvasSize)")
}


