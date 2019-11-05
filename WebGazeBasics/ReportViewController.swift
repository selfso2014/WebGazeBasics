//
//  ReportViewController.swift
//  WebGazeBasics
//
//  Created by Steve on 02/11/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//

import UIKit

var currentWebPageIndex: Int = 0

class ReportViewController: UIViewController {

    // screen sized white view for report gaze analysis
    var whiteView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight ))
    
    // screen sized webpage view for report gaze analysis
    var pageView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight ))
    
    var percentRadius = [CGFloat(1.0), CGFloat(1.0), CGFloat(1.0), CGFloat(1.0), CGFloat(1.0)]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(whiteView)
        
        if backButtonClicked == false {
            /* calculating rank of fixation density in each product area */
            let tempWebIndex = 0 // main page product ranking only  // w.getCurrentWebIndex()
            let tempPrdIndex = w.getFinalPrdIndex(webIndex: tempWebIndex)
            //w.printAllPrd(webIndex: tempWebIndex)
            w.findPrdFixDensityRank(webIndex: tempWebIndex, prdIndex: tempPrdIndex)
            w.printWebPrdRank(webIndex: tempWebIndex)
            /* display rank products */
            displayRank(webIndex: tempWebIndex, productNumber: 10)
            
            /* display button */
            displayButton()
            
        } else {
            pageView.backgroundColor = .white
            view.addSubview(pageView)
            displayWebpage(webIndex: currentWebPageIndex)
            backButtonClicked = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    /* display rank of products up to productNumber */
    func displayRank(webIndex: Int, productNumber: Int) {
        
        /* display title of gaze analysis */
        var size = CGSize(width: 340, height: 50)
        let titleLabel = UILabel(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: 30,
                                               width: size.width, height: size.height))
        titleLabel.text = "시선분석을 통한 추천상품"
        titleLabel.font = titleLabel.font.withSize(25)
        titleLabel.textAlignment = .center
        whiteView.addSubview(titleLabel)
        
        /* get products infomration to recommend  */
        for i in 0...(productNumber - 1) {
            
            // get main page prdocut info recommendation only
            let tempRankInfo = w.getPrdRankInfo(webIndex: 0, rankIndex: i)
            let prdName = tempRankInfo.prdName
            let prdPrice = tempRankInfo.prdPrice
            let prdImageURL = tempRankInfo.prdImageURL
            
            // display prdocut
            print("recommend #\(i) \(prdName) \(prdPrice) \(prdImageURL)")
            whiteView.contentSize = CGSize(width: screenWidth, height: 400 * CGFloat(i) + 700)
            displayPrd(x: 0.0, y: 400 * CGFloat(i) + 150.0, prdName: prdName, prdPrice: prdPrice, prdImageURL: prdImageURL)
        }
        
    }
    
    
    /* display product */
    func displayPrd(x: CGFloat, y: CGFloat, prdName: String, prdPrice: String, prdImageURL: URL) {
        
        /* label declration */
        var size = CGSize(width: 340, height: 40)
        let label1 = UILabel(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: y, width: size.width, height: size.height))
        label1.textAlignment = .left
        whiteView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: y + 40, width: size.width, height: size.height))
        label2.textAlignment = .left
        whiteView.addSubview(label2)
        
        /* set label text */
        label1.text = "상품명: " + prdName
        label2.text = "가 격: " + prdPrice + "원"
        
        /* show product image */
        size = CGSize(width: 200, height: 200)
        displayPrdImage(x: (CGFloat(screenWidth) - size.width)/2, y: y + 100, width: size.width, height: size.height, imageURL: prdImageURL)
        
    }
    
    
    /* display product image */
    func displayPrdImage(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, imageURL: URL) {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let data = try? Data(contentsOf: imageURL)
        imageView.image = UIImage(data: data!)
        self.whiteView.addSubview(imageView)
    }
    
    
    func displayButton() {
    
        /* Making 'Gaze Analsys End' button UI */
        let size = CGSize(width: 200, height: 50)
        var button = UIButton()
        button = UIButton(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: whiteView.contentSize.height - 80,
                                            width: size.width, height: size.height))
        button.backgroundColor = .orange
        button.setTitle("웹페이지별 시선분석 보기", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.whiteView.addSubview(button)
        
    }
    
    
    @objc func buttonAction() {
        print("'go to pageView' button clicked")
        
        pageView.backgroundColor = .white
        view.addSubview(pageView)
        w.setWebIndex(webIndex: 0) // setting webpage index as 0
        displayWebpage(webIndex: 0)
    }
    
    
    /* display rank of products up to productNumber */
    func displayWebpage(webIndex: Int) {
       
        /* display title of gaze analysis */
        var size = CGSize(width: 340, height: 50)
        let titleLabel = UILabel(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: 30,
                                              width: size.width, height: size.height))
        titleLabel.text = "웹페이지별 시선분석"
        titleLabel.font = titleLabel.font.withSize(25)
        titleLabel.textAlignment = .center
        pageView.addSubview(titleLabel)
       
        /* label declration */
        size = CGSize(width: 340, height: 40)
        let label1 = UILabel(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: 100, width: size.width, height: size.height))
        label1.textAlignment = .left
        pageView.addSubview(label1)

        let label2 = UILabel(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: 100 + 40, width: size.width, height: size.height))
        label2.textAlignment = .left
        pageView.addSubview(label2)

        /* set label text */
        label1.text = "웹페이지: " + String(currentWebPageIndex + 1) + " / " + String(w.getFinalWebIndex() + 1)
        label2.text = "URL  : " +  w.getWebURL(webIndex: currentWebPageIndex).absoluteString

        // display prdocut
        pageView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        drawPentagonAnalysis(sides: 5.0, centerX: CGFloat(screenWidth) / 2, centerY: 400)
        
        displayNavigationButton()
        
        
    }
   
    
    /* draw polygon gaze analysis graph */
    func drawPentagonAnalysis(sides: CGFloat, centerX: CGFloat, centerY: CGFloat) {
        percentRadius = [CGFloat(1.0), CGFloat(1.0), CGFloat(1.0), CGFloat(1.0), CGFloat(1.0)]
        darwPolygonAxis(sides: sides, centerX: centerX, centerY: centerY, radius: 110.0, lineColor: UIColor.gray.cgColor, lineWidth: 1.0)
        darwPolygon(sides: sides, centerX: centerX, centerY: centerY, radius: 50.0, lineColor: UIColor.gray.cgColor, lineWidth: 1.0)
        darwPolygon(sides: sides, centerX: centerX, centerY: centerY, radius: 100.0, lineColor: UIColor.gray.cgColor, lineWidth: 1.0)
        
        let finalPrdIndex = w.getFinalPrdIndex(webIndex: currentWebPageIndex)
        var randNum0 = CGFloat(arc4random_uniform(100)) / CGFloat(100.0) // 100 //0~0.99사이의 난수
        var randNum1 = CGFloat(arc4random_uniform(100)) / CGFloat(100.0) // 100 //0~0.99사이의 난수
        var randNum2 = CGFloat(arc4random_uniform(100)) / CGFloat(100.0) // 100 //0~0.99사이의 난수
        var randNum3 = CGFloat(arc4random_uniform(100)) / CGFloat(100.0) // 100 //0~0.99사이의 난수
        var randNum4 = CGFloat(arc4random_uniform(100)) / CGFloat(100.0) // 100 //0~0.99사이의 난수
        
    
        
        
        print("rand: \(randNum0) \(randNum1) ")
        percentRadius = [randNum0, randNum1, randNum2, randNum3, randNum4]
        darwPolygon(sides: sides, centerX: centerX, centerY: centerY, radius: 70.0, lineColor: UIColor.red.cgColor, lineWidth: 3.0)
       
    }
    
    
    /* draw polygon */
    func darwPolygon(sides: CGFloat, centerX: CGFloat, centerY: CGFloat, radius: CGFloat, lineColor: CGColor, lineWidth: CGFloat ) {
        
        let shapeLayer = CAShapeLayer()
        
       
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = lineColor //UIColor.green.cgColor
        shapeLayer.fillColor = nil //UIColor.blue.cgColor
        
        let starPath = UIBezierPath()
        
        let shapeBounds = shapeLayer.bounds
        let center = shapeLayer.position
        
        let numberOfPoints = sides //CGFloat(5.0)
        let numberOfLineSegments = Int(numberOfPoints * 2.0)
        let theta = .pi * 2 / numberOfPoints
        
        let circumscribedRadius: CGFloat = 100.0
        let outerRadius = radius
        let tempPercentRadius: [CGFloat] = percentRadius //[0.1, 0.4, 0.6, 0.7, 0.7]

        // Alternate between the outer and inner radii while moving evenly along the
        // circumference of the circle, connecting each point with a line segment
        for i in 0..<Int(numberOfPoints) {
            
            let radius = outerRadius * tempPercentRadius[i] //outerRadius
            let pointX = centerX + cos(CGFloat(i) * theta) * radius
            let pointY = centerY + sin(CGFloat(i) * theta) * radius
            let point = CGPoint(x: pointX, y: pointY)
            
            if i == 0 {
                starPath.move(to: point)
            } else {
                starPath.addLine(to: point)
            }
        }
        
        starPath.close()
        
        // Rotate the path so the star points up as expected
        var pathTransform  = CGAffineTransform.identity
        pathTransform = pathTransform.translatedBy(x: centerX, y: centerY)
        pathTransform = pathTransform.rotated(by: CGFloat(-.pi / 2.0))
        pathTransform = pathTransform.translatedBy(x: -centerX, y: -centerY)
        
        starPath.apply(pathTransform)
        shapeLayer.path = starPath.cgPath
        
        self.pageView.layer.addSublayer(shapeLayer)
        
    }
    
    

   /* draw polygon axis */
   func darwPolygonAxis(sides: CGFloat, centerX: CGFloat, centerY: CGFloat, radius: CGFloat, lineColor: CGColor, lineWidth: CGFloat) {
       
       let shapeLayer = CAShapeLayer()
       
       
       shapeLayer.lineWidth = lineWidth
       shapeLayer.strokeColor = lineColor //UIColor.green.cgColor
       shapeLayer.fillColor = nil //UIColor.blue.cgColor
       
       let starPath = UIBezierPath()
       
       let shapeBounds = shapeLayer.bounds
       let center = shapeLayer.position
       
       let numberOfPoints = sides //CGFloat(5.0)
       let numberOfLineSegments = Int(numberOfPoints * 2.0)
       let theta = .pi * 2 / numberOfPoints
       
       let circumscribedRadius: CGFloat = 100.0
       let outerRadius = radius
       //let percentRadius: [CGFloat] = [1.0, 1.0, 1.0, 1.0, 1.0] //0.4, 0.6, 0.7, 0.7]
       
       // Alternate between the outer and inner radii while moving evenly along the
       // circumference of the circle, connecting each point with a line segment
       for i in 0..<Int(numberOfPoints) {
           
           let radius = outerRadius
           let pointX = centerX + cos(CGFloat(i) * theta) * radius
           let pointY = centerY + sin(CGFloat(i) * theta) * radius
           let point = CGPoint(x: pointX, y: pointY)

           starPath.move(to: CGPoint(x: centerX, y: centerY))
           starPath.addLine(to: point)
           
       }
       
       starPath.close()
       
       // Rotate the path so the star points up as expected
       var pathTransform  = CGAffineTransform.identity
       pathTransform = pathTransform.translatedBy(x: centerX, y: centerY)
       pathTransform = pathTransform.rotated(by: CGFloat(-.pi / 2.0))
       pathTransform = pathTransform.translatedBy(x: -centerX, y: -centerY)
       
       starPath.apply(pathTransform)
       shapeLayer.path = starPath.cgPath
       
       self.pageView.layer.addSublayer(shapeLayer)
       
   }
    
    
    /*  Display buttons for gaze analysis */
    func displayNavigationButton() { // mode: Bool) {
        
        /* button UI */
        let size = CGSize(width: 200, height: 50)
        let homeButton = UIButton(frame: CGRect(x: (CGFloat(screenWidth) - size.width)/2, y: CGFloat(screenHeight) - 80,
                                                width: size.width, height: size.height))
        homeButton.backgroundColor = UIColor.orange.withAlphaComponent(1.0)
        homeButton.setTitle("시선포인트 표시", for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonAction), for: .touchUpInside)
        self.pageView.addSubview(homeButton)
        
        if w.getFinalWebIndex() >= 1 {
            
            /* preButton */
            let size = CGSize(width: 50, height: 50)
            let preButton = UIButton(frame: CGRect(x: 20, y: CGFloat(screenHeight) - 80,
                                                   width: size.width, height: size.height))
            preButton.backgroundColor = UIColor.orange.withAlphaComponent(1.0)
            preButton.setTitle("<", for: .normal)
            preButton.addTarget(self, action: #selector(preButtonAction), for: .touchUpInside)
            self.pageView.addSubview(preButton)
            
            /* nextButton */
            let nextButton = UIButton(frame: CGRect(x: CGFloat(screenWidth) - size.width - 20, y: CGFloat(screenHeight) - 80,
                                                    width: size.width, height: size.height))
            nextButton.backgroundColor = UIColor.orange.withAlphaComponent(1.0)
            nextButton.setTitle(">", for: .normal)
            nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
            self.pageView.addSubview(nextButton)
        }
        
    }
    
    
    func clearView() {
        
        for v in whiteView.subviews{
            v.removeFromSuperview()
        }
        
        for v in pageView.subviews{
            v.removeFromSuperview()
        }
        
        pageView.layer.removeFromSuperlayer()
        
        pageView.layer.sublayers = nil;
        
        whiteView.removeFromSuperview()
        pageView.removeFromSuperview()
        
    }
    
    
    func transitionToGazeOnWebViewViewController() {
        let gazeOnWebViewController: GazeOnWebViewController = GazeOnWebViewController()
        self.present(gazeOnWebViewController, animated: true, completion: nil)
    }
    
    
    /* homeButton action funcion */
    @objc func homeButtonAction(sender: UIButton!) {
        
        print("homeButton clicked")
         
        clearView()
        
        w.setWebIndex(webIndex: currentWebPageIndex)
        transitionToGazeOnWebViewViewController()
        
        //print("homeButton part end")
    }
    
    /* previous('<') button action function */
    @objc func preButtonAction(sender: UIButton!) {

        currentWebPageIndex -= 1
        if currentWebPageIndex == -1 {
            currentWebPageIndex = w.getFinalWebIndex()
        }
        w.setWebIndex(webIndex: currentWebPageIndex)
        
        clearView()

        pageView.backgroundColor = .white
        view.addSubview(pageView)
        displayWebpage(webIndex: currentWebPageIndex)
        
    }
    
    
    /* next('>') button action function */
    @objc func nextButtonAction(sender: UIButton!) {
        currentWebPageIndex += 1
        if currentWebPageIndex > w.getFinalWebIndex() {
            currentWebPageIndex = 0
        }
        w.setWebIndex(webIndex: currentWebPageIndex)
    
        clearView()
        
        pageView.backgroundColor = .white
        view.addSubview(pageView)
        displayWebpage(webIndex: currentWebPageIndex)
        
    }
    
    
    
}
