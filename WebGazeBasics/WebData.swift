
//
//  ViewController.swift
//  WebGazeBasics
//
//  Created by Steve on 26/10/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//


import UIKit
import WebKit


struct WebData {
    var webPathURL: URL = URL(string: "https://m.cjthemarket.com/")!
    var webFromIndex : Int = 0
    var webToIndex : Int = 0
    var prdData = [ProductData]()
}

struct ProductData {
    var prdCategory: String = ""
    var prdRect: (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) = (0.0, 0.0, 0.0, 0.0)
    var prdName: String = ""
    var prdPrice: String = ""
    var prdSeller: String = ""
    var prdImageURL: URL = URL(string: "https://m.cjthemarket.com/")!
    var prdGazeCount: Int = 0         // product_gaze_count      : all gaze counts including saccades and fixations
    var prdFixCount: Int = 0          // product_fixation_count  : gaze fixation counts only
    var prdFixDensity: CGFloat = 0.0  // product_fixation_density: gaze fixation denesity of each product AOI(Area Of Interests)
}

struct WebProductRank {
    var webIndex: Int = 0
    var prdIndex: Int = 0
    var prdFixDensity: CGFloat = 0.0
}

class WebDataHandler {
    
    var webData : [WebData] = []
    var webPrdRank: [WebProductRank] = []
    var webIndex: Int = -1 // Important! If webpage loaded, webIndex should increase by 1.
    var prdIndex: Int = -1
    
    var gazeWeb: CGPoint = CGPoint(x: 0.0, y: 0.0) // gaze points array of full webpage screen
    var gazeIndex: Int = 0
    
    var prdGazedIndex: Int = -1  // -1: not found, 0~prdIndex: found & prdIndex
    
    
    /* initializer */
    init() {
        // initial web page URL to be analyzed with gaze tracking
        //print("@init, webData_count: \(webData.count)   productData.count:\(webData[0].prdData.count) webPrdRank:\(webPrdRank.count)")
    }
    
    
    func appendWebData() {
        webData.append(WebData())
        let webIndex = webData.count - 1
        webData[webIndex].prdData.append(ProductData())
        webPrdRank.append(WebProductRank())
        //gazeWeb.append(CGPoint())
        prdIndex = -1
        prdGazedIndex = -1
        print("@appendWebData, webData_count: \(webData.count)   productData.count:\(webData[webIndex].prdData.count) webPrdRank_count:\(webPrdRank.count)")
    }
    
    
    /* web <--> app communication protocal example
             prdIndex|catetory|data ...
    setWebData(), 187|webPathURL|/
    setWebData(), 187|prdRect|23.34375|25506.15625|157.4375|256
    setWebData(), 187|prdName|스트랩 벨트 롱코트
    setWebData(), 187|prdPrice|32,300
    setWebData(), 187|prdSeller|아이무드유
    setWebData(), 187|prdImageURL|https://image.brandi.me/cproduct/2019/10/28/11431797_1572255506_image1_M.jpg
    */
    func setWebData(str: String) {
        
        if shoppingFinished == true {
            return
        }
        
        let strData =  str.components(separatedBy: "|")
        //print("setWebData(), \(str)")
        
        let strIndex = strData.count - 1
        
        if strIndex <= 0 { return }
        else {
            switch strData[1] {
                
            case "webPathURL":
                webData[webIndex].webPathURL = URL(string: strData[2])!
                prdIndex += 1
                webData[webIndex].prdData.append(ProductData())
                print("\n")
                print(" webIndex#\(webIndex) prdIndex#\(prdIndex) webPathURL|\(webData[webIndex].webPathURL)")
                break
                
            case "prdRect":
                if let n = NumberFormatter().number(from: strData[2]) {
                    webData[webIndex].prdData[prdIndex].prdRect.x = CGFloat(truncating: n)
                }
                if let n = NumberFormatter().number(from: strData[3]) {
                    webData[webIndex].prdData[prdIndex].prdRect.y = CGFloat(truncating: n)
                }
                if let n = NumberFormatter().number(from: strData[4]) {
                    webData[webIndex].prdData[prdIndex].prdRect.w = CGFloat(truncating: n)
                }
                if let n = NumberFormatter().number(from: strData[5]) {
                    webData[webIndex].prdData[prdIndex].prdRect.h = CGFloat(truncating: n)
                }
                print(" webIndex#\(webIndex) prdIndex#\(prdIndex) prdRect|\(webData[webIndex].prdData[prdIndex].prdRect.x) \(webData[webIndex].prdData[prdIndex].prdRect.y) \(webData[webIndex].prdData[prdIndex].prdRect.w) \(webData[webIndex].prdData[prdIndex].prdRect.h)")
                break
                
            case "prdName":
                webData[webIndex].prdData[prdIndex].prdName = strData[2]
                //print(" webIndex#\(webIndex) prdIndex#\(prdIndex) prdName|\(webData[webIndex].prdData[prdIndex].prdName)")
                break
                
            case "prdPrice":
                webData[webIndex].prdData[prdIndex].prdPrice = strData[2]
                //print(" webIndex#\(webIndex) prdIndex#\(prdIndex) prdPrice|\(webData[webIndex].prdData[prdIndex].prdPrice)")
                break
                
            case "prdSeller":
                webData[webIndex].prdData[prdIndex].prdSeller = strData[2]
                //print(" webIndex#\(webIndex) prdIndex#\(prdIndex) prdSeller|\(webData[webIndex].prdData[prdIndex].prdSeller)")
                break
                
            case "prdImageURL":
                webData[webIndex].prdData[prdIndex].prdImageURL = URL(string: (strData[2]))!
                //print(" webIndex#\(webIndex) prdIndex#\(prdIndex) prdImageURL|\(webData[webIndex].prdData[prdIndex].prdImageURL)")
                break
                
            case "prdCategory":
                webData[webIndex].prdData[prdIndex].prdCategory = strData[2]
                break
                
            case "gazeWeb":  // new gaze point calculated in full webpage screen
                
                if let n = NumberFormatter().number(from: strData[2]) {
                    gazeWeb.x = CGFloat(truncating: n)
                }
                if let n = NumberFormatter().number(from: strData[3]) {
                    gazeWeb.y = CGFloat(truncating: n)
                }
                let tempIndex = g.getGazeDataIndex()
                g.setGazeWebPoint(index: tempIndex, x: gazeWeb.x, y: gazeWeb.y)
                
                print("@setWebData(), gazeIndex#\(tempIndex) gazeWeb| \(gazeWeb.x) \(gazeWeb.y)")
                let tempPrdGazedIndex = findProductGazed(x: gazeWeb.x, y: gazeWeb.y
                )
                if tempPrdGazedIndex == -1 {
                    // product not found
                } else {
                    // product found
                    webData[webIndex].prdData[tempPrdGazedIndex].prdGazeCount += 1
                    if g.isFixation(index: g.getGazeDataIndex()) == true {
                        // in case of gaze fixation
                        webData[webIndex].prdData[tempPrdGazedIndex].prdFixCount += 1
                        findPrdFixDensity(webIndex: webIndex, prdIndex: tempPrdGazedIndex)
                    }
                }
                break
                
            case "FindElementfinished":
                printAllPrd(webIndex: webIndex)
                break
                
            default:
                print(" default:\(str)")
                break
            }
        }
    }
    
    
    /* set functions */
    func setWebIndex(webIndex: Int) {
        self.webIndex = webIndex
    }
    
    
    func setWebFromIndex(webIndex: Int, gazeIndex: Int) {
        webData[webIndex].webFromIndex = gazeIndex
    }
    
    
    func setWebToIndex(webIndex: Int, gazeIndex: Int) {
        webData[webIndex].webToIndex = gazeIndex
    }
    
    
    
    /* get functions */
    func getCurrentWebIndex() -> Int {
        return webIndex
    }
    
    func getCurrentPrdIndex() -> Int {
        return prdIndex
    }
    
    
    func getWebURL(webIndex: Int) -> URL {
        return webData[webIndex].webPathURL  //URL(webData[webIndex].webPathURL)
    }
    
    func getFinalWebIndex() -> Int {
        return ( webData.count - 1 )
    }
    
    func getWebFromIndex(webIndex: Int) -> Int {
        return webData[webIndex].webFromIndex
    }
    
    func getWebToIndex(webIndex: Int) -> Int{
        return webData[webIndex].webToIndex
    }
    
    
    func getFinalPrdIndex(webIndex: Int) -> Int {
        return ( webData[webIndex].prdData.count - 1 )
    }
    
    
    func getPrdGazedIndex() -> Int {
        return prdGazedIndex
    }
    
    
    func getPrdRect(webIndex: Int, prdIndex: Int) -> CGRect {
        let minX = webData[webIndex].prdData[prdIndex].prdRect.x
        let minY = webData[webIndex].prdData[prdIndex].prdRect.y
        let width = webData[webIndex].prdData[prdIndex].prdRect.w
        let height = webData[webIndex].prdData[prdIndex].prdRect.h
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
    

    func getPrdRankInfo(webIndex: Int, prdIndex: Int) -> (prdName: String, prdPrice: String, prdImageURL: URL) {
        if prdIndex > getFinalPrdIndex(webIndex: webIndex) {
            return (prdName: "", prdPrice: "", prdImageURL:  URL(string: "https://www.google.com")!)
        }
        let prdName = webData[webIndex].prdData[prdIndex].prdName
        let prdPrice = webData[webIndex].prdData[prdIndex].prdPrice
        let prdImageURL = webData[webIndex].prdData[prdIndex].prdImageURL
        return (prdName: prdName, prdPrice: prdPrice, prdImageURL: prdImageURL)
    }
    
    
    /* find functions */
    func findProductGazed(x: CGFloat, y: CGFloat) -> Int {
        let prdIndex = webData[webIndex].prdData.count - 1
        for i in 0...prdIndex {
                        
            let tempX = webData[webIndex].prdData[i].prdRect.x
            let tempY = webData[webIndex].prdData[i].prdRect.y
            let tempW = webData[webIndex].prdData[i].prdRect.w
            let tempH = webData[webIndex].prdData[i].prdRect.h
            
            //if  webData[webIndex].prdData[i].prdName != ""  &&
            if x > tempX &&
                x < tempX + tempW &&
                y > tempY &&
                y < tempY + tempH {
                prdGazedIndex = i
                print("@findProidcutGazed(), Product found!!!")
                printPrd(webIndex: webIndex, prdIndex: i)
                return prdGazedIndex
            }
        }
        prdGazedIndex = -1
        print("@findProidcutGazed(), Product not founded \n")
        return prdGazedIndex
    }
    
    
    func findPrdFixDensity(webIndex: Int, prdIndex: Int) {
        let area = webData[webIndex].prdData[prdIndex].prdRect.w * webData[webIndex].prdData[prdIndex].prdRect.h
        let tempPrdFixDensity = CGFloat(webData[webIndex].prdData[prdIndex].prdFixCount) / area * 10000.0
        webData[webIndex].prdData[prdIndex].prdFixDensity = tempPrdFixDensity
    }
    
    
    func findPrdFixDensityRank(webIndex: Int, prdIndex: Int) { // prdIndex is final index of products in webpage of webIndex
        
        /* set webPrdRank array */
        for i in 0...prdIndex {
            webPrdRank[i].webIndex = webIndex
            webPrdRank[i].prdIndex = i
            webPrdRank[i].prdFixDensity = webData[webIndex].prdData[i].prdFixDensity
            //webPrdRank[i].rankIndex = i
            if i < prdIndex {
                webPrdRank.append(WebProductRank())
            }
        }
        print("webprdRank final index#\(webPrdRank.count - 1)")
        
        /* sorting product rank */
        let index = prdIndex //productRank.count - 1
        if index <= 0 { return }
        for i in (0...(index-1)) {
            for j in (1...(index)) {
                if webPrdRank[j].prdFixDensity > webPrdRank[j-1].prdFixDensity {
                    let temp = webPrdRank[j-1]
                    webPrdRank[j-1] = webPrdRank[j]
                    webPrdRank[j] = temp
                }
            }
        }
    }
    
    
    /* print functions */
    func printPrd(webIndex: Int, prdIndex: Int) {
        print("Product info. webIndex#\(webIndex) prdIndex#\(prdIndex)")
        print(" prdRect|\(webData[webIndex].prdData[prdIndex].prdRect.x) \(webData[webIndex].prdData[prdIndex].prdRect.y) \(webData[webIndex].prdData[prdIndex].prdRect.w) \(webData[webIndex].prdData[prdIndex].prdRect.h)")
        print(" prdName|\(webData[webIndex].prdData[prdIndex].prdName)")
        print(" prdPrice|\(webData[webIndex].prdData[prdIndex].prdPrice)")
        print(" prdSeller|\(webData[webIndex].prdData[prdIndex].prdSeller)")
        print(" prdImageURL|\(webData[webIndex].prdData[prdIndex].prdImageURL)")
        print(" prdCategory|\(webData[webIndex].prdData[prdIndex].prdCategory)")
        print(" prdGazeCount|\(webData[webIndex].prdData[prdIndex].prdGazeCount)")
        print(" prdFixCounty|\(webData[webIndex].prdData[prdIndex].prdFixCount)")
        print(" prdFixDensity|\(webData[webIndex].prdData[prdIndex].prdFixDensity)")
        print("\n")
    }
    
    
    
    func printAllPrd(webIndex: Int) {
        print("@printAllPrd()")
        let prdIndex = webData[webIndex].prdData.count - 1
        for i in 0...prdIndex {
            printPrd(webIndex: webIndex, prdIndex: i)
        }
    }
    
    
    func printWebPrdRank(webIndex: Int) {
        print("@printWebPrdRank()")
        let tempPrdIndex = webData[webIndex].prdData.count - 1
        for i in 0...tempPrdIndex {
            print(" webPrdRank #\(i)")
            let prdIndex = webPrdRank[i].prdIndex
            printPrd(webIndex: webIndex, prdIndex: prdIndex)
        }
    }
    
    
    func printWebInfo(webIndex: Int) {
        print("@printWebInfo")
        for i in 0...webIndex {
            print("webIndex #\(i)  self.webIndex #\(self.webIndex) webFromIndex: \(webData[i].webFromIndex) webToIndex: \(webData[i].webToIndex) webPathURL: \(webData[i].webPathURL) finalPrIndex#\(webData[i].prdData.count - 1) ")
        }
        print("\n")
    }
}
