//
//  GazeOnWebViewController.swift
//  WebGazeBasics
//
//  Created by Steve on 03/11/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//
//


import UIKit

var backButtonClicked: Bool = false

class GazeOnWebViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        UIApplication.shared.isIdleTimerDisabled = true
         

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
        
        let url = w.getWebURL(webIndex: w.getCurrentWebIndex())
        print("loading web url: \(url) #\(w.getCurrentWebIndex())")
        webViewController.loadingWebpage(url: url)  //URL(string: "https://www.cjthemarket.com/")!
        
        
        
        /* Making 'Gaze Analsys End' button UI */
        let size = CGSize(width: 200, height: 50)
        let backButton = UIButton(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: CGFloat(screenHeight) - 80,
        width: size.width, height: size.height))
        backButton.backgroundColor = .orange
        backButton.setTitle("돌아가기", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backButton)
            
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
   
    @objc func backButtonAction() {
        
        backButtonClicked = true
        transitionToReportViewController()
        
    }
    
    
    func transitionToReportViewController() {
        let reportViewController: ReportViewController = ReportViewController()
        self.present(reportViewController, animated: true, completion: nil)
    }
    
    
}


