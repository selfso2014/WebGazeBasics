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
        
        /* Setting & loading web page URL to be analyzed */
        //let url = URL(string: "https://www.brandi.co.kr/")! //  "https://www.apple.com/"  // "https://www.cjthemarket.com/"
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
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
    /*
    func displayGazePoints(index: Int) {
        /* canvas size */
        let size = self.getContentSize()
        
        /* javascript injection */
        javascriptInjection(file: "setCanvasOnce", canvasSize: size, js: "")
        print("@displayGazePoints(), canvasSize: \(size) javascript injected")

        
    }
    */
    
    
    
    
    // WKNavigationDelegate.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        
        // setOnce.js & parseWebpageOnce.js 
        javascriptInjection(file: "setOnce", strJS: "")
        javascriptInjection(file: "parseWebpageOnce", strJS: "")
    }
    
    
    
    // WKScriptMessageHandler: delivering messages to app from javascript injected to webpage
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        //print("@userContentController: \(message.body)")
        let str: String = message.body as! String
        w.setWebData(str: str)
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
    
    
    /* javasciprt injection to set canvas for drawing */
    func javascriptInjection(file: String, canvasSize: CGSize, js: String) {
        
        /* add javaScript from 'FILE_NAME.js' file */
        guard let scriptPath = Bundle.main.path(forResource: file, ofType: "js"),
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

            
        @unknown default:
            print("Fatal Error!!!")
        }
        
        return true
    }
    
    
}




/*
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
 */


