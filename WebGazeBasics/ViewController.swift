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


class ViewController: UIViewController {

    /* gaze tracking configurations */
    var sessionHandler : SessionHandler? = nil
    var gazePt : UIView?   // gaze ui view
    var gazeSize : CGSize = CGSize(width: 10, height: 10)   // gaze ui view size
    var isShow : Bool = false
    
    
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
    
        webViewController.loadingWebpage(url: URL(string: "https://www.brandi.co.kr/")!)
        
        DispatchQueue.main.async {
            self.gazePt = UIView(frame: CGRect(x: self.view.frame.width/2 - self.gazeSize.width/2, y: self.view.frame.height/2 - self.gazeSize.height/2, width: self.gazeSize.width, height: self.gazeSize.height))
            self.gazePt!.layer.cornerRadius = self.gazeSize.width/2
            self.gazePt!.backgroundColor = UIColor.orange
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
                self.gazePt?.frame.origin.x = CGFloat(xy[0]) - self.gazeSize.width/2
                self.gazePt?.frame.origin.y = CGFloat(xy[1]) - self.gazeSize.height/2
                self.gazePt?.isHidden = false
                self.gazePt?.alpha = 0.7
                
                // gaze data delivering to webpage through javascript injection function
                webViewController.gazeDataInjection(x: xy[0], y: xy[1] - Double(statusBarHeight))
                
            }
        } else if state == .faceMissing {
            print("face not found")
        }
    }
    

}


