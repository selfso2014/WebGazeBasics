//
//  ViewController.swift
//  WebGazeBasics
//
//  Created by Steve on 26/10/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//

import UIKit
import TrueGaze


var g: GazeDataHandler = GazeDataHandler()
var screenWidth: CGFloat = 0.0
var screenHeight: CGFloat = 0.0
var statusBarHeight: CGFloat  = 0.0

let webViewController = WebViewController()
var w: WebDataHandler = WebDataHandler()

var shoppingFinished: Bool = false

var button = UIButton()

class ViewController: UIViewController {

    /* gaze tracking configurations */
    var sessionHandler : SessionHandler? = nil
    var gazePt : UIView?   // gaze ui view
    var gazeSize : CGSize = CGSize(width: 10, height: 10)   // gaze ui view size
    var isShow : Bool = false
    
    // view to draw eye cursor
    var cursorView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ))
    
    // cursor layer
    var cursorLayer: [CAShapeLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        // initialize eye-tracking session.
         sessionHandler = SessionHandler(key: "Im_Lq2eALkm77scMJQ62ypruLQRKsIIO4x9qrNIlExSPv3fTGerDstIqU7j8KdZToTXOfrR85oDvfnhLAXrVwo1AS8IyKcORTLZebsFQes3Sryu04rOLYmn7ySuufTEDO9LYCS_vtYRDiP0SxD84yPV-2QzwUwlm42bbodMqZqsXSS6ALC1eUtClIvPcuIhj", receiver: self)

         UIApplication.shared.isIdleTimerDisabled = true
         
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        //print("상태표시줄 높이: \(UIApplication.shared.statusBarFrame.height)")
        
        /* webView */
        // install the WebViewController as a child view controller
        addChild(webViewController)
        let webViewControllerView = webViewController.view!
        view.addSubview(webViewControllerView)
        webViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        webViewControllerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webViewControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webViewControllerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webViewControllerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webViewController.didMove(toParent: self)
        

        /* gaze cursor layer setting */
        self.view.addSubview(cursorView)
        for _ in 0...9 {
            cursorLayer.append(CAShapeLayer())
            self.view.layer.addSublayer(cursorLayer.last!)
        }
        
        
        /* Making 'Gaze Analsys End' button UI */
        let size = CGSize(width: 200, height: 50)
        button = UIButton(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: CGFloat(screenHeight) - 80,
                                            width: size.width, height: size.height))
        button.backgroundColor = .orange
        button.setTitle("쇼핑 마치기", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        button.isHidden = true
        
            
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // set eye-tracking session options.
        sessionHandler?.openSession(root: self.view, mode: ScreenMode.Portrait, isCalibration: true)

        // start eye-tracking session.
        sessionHandler?.startSession()
        
        // eye_logo show up
        sessionHandler?.setStatusViewPosition(position: CGPoint(x: CGFloat(screenWidth) / 2.0, y: 40.0))
    }
    
    
    /* draw rectangle */
    func drawRect(rect: CGRect, color: CGColor, lineWidth: CGFloat) {
        drawRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height,
                 cornerRadius: 1.0, color: color, lineWidth: lineWidth)
    }
    
    
    /* draw rectangle */
    func drawRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, cornerRadius: CGFloat, color: CGColor, lineWidth: CGFloat) {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: width, height: height),
                                  cornerRadius: cornerRadius).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color // UIColor.red.cgColor
        layer.lineWidth = lineWidth
        cursorView.layer.addSublayer(layer)
    
    }
    
    
    
    func drawCircle2(p: CGPoint, r: CGFloat, alpha: CGFloat, targeted: Bool) {
        let index = g.getGazeDataIndex()
        let layerLength = Int(cursorLayer.count / 2)
        var layerIndex = layerLength - 1
        let size: CGFloat = 3.0 // [CGFloat] = [6.0, 7.0, 8.0, 9.0, 10.0, 10.0, 9.0, 8.0, 7.0, 6.0]
        for i in ((index - layerLength + 1)...index) {
            let p = g.getGazeData(index: i)
            let rect = CGRect(x: p.x - r - size * CGFloat(layerIndex),
                              y: p.y - r - size * CGFloat(layerIndex),
                              width: 2 * r + 2 * size * CGFloat(layerIndex),
                              height: 2 * r + 2 * size * CGFloat(layerIndex))
            let circlePath = UIBezierPath(ovalIn: rect)
    
            cursorLayer[layerIndex].path = circlePath.cgPath
            if targeted == true {
                cursorLayer[layerIndex].strokeColor = UIColor(red: 1.0, green: 0.1, blue: 0.1,
                                                              alpha: alpha / CGFloat((layerIndex + 1))).cgColor //UIColor.blue.cgColor
            } else {
                cursorLayer[layerIndex].strokeColor = UIColor(red: 0.1, green: 1.0, blue: 0.1,
                                                              alpha: alpha / CGFloat((layerIndex + 1))).cgColor //UIColor.blue.cgColor
            }
            cursorLayer[layerIndex].fillColor = UIColor.clear.cgColor
            cursorLayer[layerIndex].lineWidth = 40.0

            layerIndex -= 1
        }
    }

    
    @objc func buttonAction() {
        print("'쇼핑마치기' button clicked")
        
        /* close eye tracking session */
        sessionHandler?.closeSession()
        print("close eye tracking session")
        
        let gazeIndex = g.getGazeDataIndex()
        let finalWebIndex = w.getFinalWebIndex()
        w.setWebToIndex(webIndex: finalWebIndex, gazeIndex: gazeIndex)
        w.printWebInfo(webIndex: finalWebIndex)
        
        shoppingFinished = true
        transitionToReportViewController()
    }
    
    
    func transitionToReportViewController() {
        let reportViewController: ReportViewController = ReportViewController()
        self.present(reportViewController, animated: true, completion: nil)
    }
    

    
}




// receiver protocol implementation
extension ViewController : Receiver {

    // initialization succeed.
    func onInitialized() {
        print("Initialization succeed.")
    }

    
    // errorCode 1000 : Key value is not normal, 1002 : Date expires.
    func onInitializeFailed(errorCode: Int) {
        print("Initialization failed! errorCode : \(errorCode)")
    }

    
    // called when calibraiton is done.
    func onCalibrationFinished() {
        print("Calibration is finished")
    
        webViewController.loadingWebpage(url: URL(string: "https://www.cjthemarket.com/")!)  // "https://www.brandi.co.kr/"
        
        DispatchQueue.main.async {
            self.gazePt = UIView(frame: CGRect(x: self.view.frame.width/2 - self.gazeSize.width/2, y: self.view.frame.height/2 - self.gazeSize.height/2, width: self.gazeSize.width, height: self.gazeSize.height))
            self.gazePt!.layer.cornerRadius = self.gazeSize.width/2
            self.gazePt!.backgroundColor = UIColor.blue
            self.view.addSubview(self.gazePt!)
            
            // To do anything after calibration
            
        }

    }

    // receive gaze points.
    func onGaze(xy: [Double], state: GazeState) {

        if state == .tracking{
            
            // set gaze data, notice: xy[1] - Double(statusBarHeight)
            g.setGazeData(x: xy[0], y: xy[1] - Double(statusBarHeight))
            let index = g.getGazeDataIndex()
            print("#\(index) x: \(xy[0]) y: \(xy[1] - Double(statusBarHeight))")
            
            DispatchQueue.main.async {
                // gaze data delivering to webpage through javascript injection function
                webViewController.gazeDataInjection(x: xy[0], y: xy[1] - Double(statusBarHeight))
                
                let currentWebIndex = w.getCurrentWebIndex()
                let currentPrdGazedIndex = w.getPrdGazedIndex()
                if currentPrdGazedIndex >= 0 {
                    let foundPrdRect = w.getPrdRect(webIndex: currentWebIndex, prdIndex: currentPrdGazedIndex)
                    webViewController.rectangleDataInjection(rect: foundPrdRect)
                    print("@receiver, rectangleDataInjection \(foundPrdRect)")
                } else {
                    // not founded
                }
                self.gazePt?.frame.origin.x = CGFloat(xy[0]) - self.gazeSize.width/2
                self.gazePt?.frame.origin.y = CGFloat(xy[1]) - self.gazeSize.height/2
                self.gazePt?.alpha = 0.7
                
                if w.prdGazedIndex >= 0 {
                    /* proudct found case */
                    self.gazePt?.backgroundColor = UIColor.red
                    self.gazePt?.isHidden = true
                    self.drawCircle2(p: CGPoint(x: xy[0], y: xy[1]), r: 70, alpha: 0.1, targeted: true)
                    
                } else {
                    self.gazePt?.backgroundColor = UIColor.blue
                    self.gazePt?.isHidden = true
                    self.drawCircle2(p: CGPoint(x: xy[0], y: xy[1]), r: 70, alpha: 0.1, targeted: false)
                }
                
            }
        } else if state == .faceMissing {
            print("face not found")
        }
    }
    

}


