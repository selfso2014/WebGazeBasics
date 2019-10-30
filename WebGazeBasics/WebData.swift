
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
    var webPathURL: String = ""
    var webFromIndex : Int = 0
    var webToIndex : Int = 0
    var prdData = [ProductData]()
}

struct ProductData {
    var prdRect: (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) = (0.0, 0.0, 0.0, 0.0)
    var prdName: String = ""
    var prdPrice: String = ""
    var prdSeller: String = ""
    var prdImageURL: URL = URL(string: "https://www.google.com")!
    var prdFixDensity: CGFloat = 0.0  // product_fixation_density: gaze fixation denesity of each product AOI(Area Of Interests)
}


class WebDataHandler {
    
    var webData : [WebData] = []
    var webIndex: Int = 0
    var prdIndex: Int = 0
    
    /* initializer */
    init() {
        // initial web page URL to be analyzed with gaze tracking
        webData.append(WebData())
        webData[0].prdData.append(ProductData())
        print("@init, webData_count: \(webData.count)   productData.count:\(webData[0].prdData.count)")
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
        
        let strData =  str.components(separatedBy: "|")
        //print("setWebData(), \(str)")
        
        let strIndex = strData.count - 1
        
        if strIndex <= 0 { return }
        else {
            switch strData[1] {
                
            case "webPathURL":
                webData[webIndex].webPathURL = strData[2]
                if Int(strData[0])! > webData[webIndex].prdData.count - 1 {
                    webData[webIndex].prdData.append(ProductData())
                    prdIndex = Int(strData[0])!  // prdIndex incrases only in this parsing section
                }
                //print("\n")
                //print(" webIndex#\(webIndex) prdIndex#\(prdIndex) webPathURL|\(webData[webIndex].webPathURL)")
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
                //print(" webIndex#\(webIndex) prdIndex#\(prdIndex) prdRect|\(webData[webIndex].prdData[prdIndex].prdRect.x) \(webData[webIndex].prdData[prdIndex].prdRect.y) \(webData[webIndex].prdData[prdIndex].prdRect.w) \(webData[webIndex].prdData[prdIndex].prdRect.h)")
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
                
            default:
                print(" default:\(str)")
                break
            }
        }
    }
    
    
}
