//
//  ViewController.swift
//  WebGazeBasics
//
//  Created by Steve on 26/10/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//


import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate, UIScrollViewDelegate{
    
    /* webView setting */
    var webView: WKWebView!
    
    // web page full screen size
    var currentContentSize: CGSize = CGSize(width: screenWidth, height: screenHeight)
    
    var webLoadStarted: Bool = false
    
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
    

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func loadingWebpage(url: URL) {
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
        
        
        /* Setting & loading web page URL to be analyzed */
        webView.load(URLRequest(url: url))
        //webView.allowsBackForwardNavigationGestures = true
        print("@loadingWebPage: \(url)")
        
        /* shopping end button shows */
        button.isHidden = false
        
        
    }
    

    
    
    // WKNavigationDelegate.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        if shoppingFinished == false {
            webLoadStarted = true
        }
    }
    
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        
        if shoppingFinished == true {
            displayGazePoints(webIndex: currentWebPageIndex)
        }
        
    }
    
    
    // WKScriptMessageHandler: delivering messages to app from javascript injected to webpage
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //print("@userContentController: \(message.body)")
        let str: String = message.body as! String
        w.setWebData(str: str)
    }
    
    
    @objc func nowJavascriptInjecting() {
        
        // setOnce.js & parseWebpageOnce.js
        javascriptInjection(file: "setOnce", strJS: "")
        //javascriptInjection(file: "parseWebpageOnce", strJS: "")
        javascriptInjection(file: "parseBrandiOnce", strJS: "")  // "parseCJTheMarketOnce",
        
        /* webIndex incrase & configuration setting */
        let webIndex = w.getCurrentWebIndex() + 1
        let gazeIndex = g.getGazeDataIndex()
        w.setWebIndex(webIndex: webIndex)
        w.appendWebData()
        
        if webIndex == 0 {
            w.setWebFromIndex(webIndex: webIndex, gazeIndex: gazeIndex)
            w.setWebToIndex(webIndex: webIndex, gazeIndex: gazeIndex)
        } else {
            w.setWebToIndex(webIndex: webIndex - 1, gazeIndex: gazeIndex)
            w.setWebFromIndex(webIndex: webIndex, gazeIndex: gazeIndex)
            w.setWebToIndex(webIndex: webIndex, gazeIndex: gazeIndex)
        }
        
        w.printWebInfo(webIndex: webIndex)
    }
    
    
    /* javascript injection function */
    func evaluateJavascript(_ javascript: String, sourceURL: String? = nil, completion: ((_ error: String?) -> Void)? = nil) {
        webView.evaluateJavaScript(javascript) { _, error in
            completion?(error?.localizedDescription)
        }
    }
    
    
    /* javasciprt injection to set canvas for drawing */
    func javascriptInjection(file: String, strJS: String) {
        
        /* add javaScript from 'FILE_NAME.js' file */
        guard let scriptPath = Bundle.main.path(forResource: file, ofType: "js"),
            let scriptSource = try? String(contentsOfFile: scriptPath) else { return }
        let contentController = WKUserContentController()
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        

        let javascript: String  = scriptSource + strJS
        
        evaluateJavascript(javascript, sourceURL: "getOuterHTML")
        
    }
    
    
    
    func gazeDataInjection(x: Double, y: Double) {
        let gazeX = Int(x)
        let gazeY = Int(y)

        let javascript =
            "var elX = document.querySelectorAll(\".gazeX\")[0].firstElementChild;" +
            "elX.className = \"gazeX|" + String(gazeX) + "\";" +
            "var elY = document.querySelectorAll(\".gazeY\")[0].firstElementChild;" +
            "elY.className = \"gazeY|" + String(gazeY) + "\";" +

            "var El = document.querySelectorAll(\"body\");" +
            "var event = new Event(\"touchend\");" +
            "El[0].dispatchEvent(event);"
                

        webViewController.javascriptInjection(file: "sendGazeToApp", strJS: javascript)
        
    }
    
    
    func rectangleDataInjection(rect: CGRect) {
        let rectX = Int(rect.minX)
        let rectY = Int(rect.minY)
        let rectW = Int(rect.width)
        let rectH = Int(rect.height)

        print("@rectangleDataInjection(), \(rectX) \(rectY) \(rectW) \(rectH)")
        
        let javascript =
            "var elRect = document.querySelectorAll(\".rectangle\")[0].firstElementChild;" +
            "elRect.className = \"rectXYWH|" + String(rectX) + "|" +  String(rectY) + "|" + String(rectW) + "|" + String(rectH) + "\";" +
        
            "var El = document.querySelectorAll(\"body\");" +
            "var event = new Event(\"touchend\");" +
            "El[0].dispatchEvent(event);"

        print("@rectangleDataInjection(), \(javascript)")
        webViewController.javascriptInjection(file: "sendGazeToApp", strJS: javascript)
        
    }
    
    
    
    /* touch gesture recgonizer for more analysis */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //print("@gestureRcognizer, ...")
        
        switch gestureRecognizer.state {
        case .began:
            print("began")
            break
        case .cancelled:
            print("cancelled")
            break
        case .changed:
            print("changed")
            break
        case .ended:
            print("ended")
            break
        case .failed:
            print("failed")
            break
        case .possible:
            print("possible")
            //let p = gestureRecognizer.location(in: self.webView)
            //print("@gestrureRecognizer, x:\(p.x) y:\(p.y)")
            
            /* time delay to inject javascript after page loading */
            if webLoadStarted == true && shoppingFinished == false {
                self.perform(#selector(self.nowJavascriptInjecting), with: nil, afterDelay: 0.0)
                webLoadStarted = false
            }
            break
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
   
       
    
    /* Display gaze points in front of web page */
    func displayGazePoints(webIndex: Int) {
        
        //let currentPageIndex = currentWebPageIndex
        //let contentSize = webAnalysis.getContentSize(index: currentPageIndex)
        //print("@displayGazePoints(), current page index: \(currentPageIndex), contentSize: \(contentSize) ")
        
        /* draw gaze points with javascript */
        let fromIndex = w.getWebFromIndex(webIndex: webIndex)
        let toIndex = w.getWebToIndex(webIndex: webIndex)
        if toIndex < 0 { return }
        
        var tempPoint: CGPoint
        var tempColor: String
        var tempRadius: Int
        var fixationCount: Int = 0
        
        var javascript = ""
        
        for i in fromIndex...toIndex {
            tempPoint = g.getGazeWebData(index: i)
            let tempX = Int(tempPoint.x)
            let tempY = Int(tempPoint.y)
            if g.isFixation(index: i) {
                tempColor = "\"#FF0000\"" //red"
                tempRadius = 15
                fixationCount += 1
            } else {
                tempColor = "\"#00FF00\"" //"green"
                tempRadius = 7
            }
            
            javascript = javascript +
                "drawCircle(" + String(tempX) + ", " + String(tempY) + ", " + String(tempRadius) + ", " + tempColor + ");\n"
            
        }
        //print("javascript: \(javascript)")
        webViewController.javascriptInjection(file: "drawCircle", strJS: javascript)
        
    }
    
    
    
    
    
}



