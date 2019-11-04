
//
//  ViewController.swift
//  WebGazeBasics
//
//  Created by Steve on 26/10/2019.
//  Copyright © 2019 Visualcamp. All rights reserved.
//

import Foundation
import UIKit

struct GazeData {
    var gazePoint : CGPoint = CGPoint(x: 0, y: 0)
    var gazeWebPoint: CGPoint = CGPoint(x: 0, y: 0)
    var fixationFlag : Bool = false
    var saccadeFlag : Bool = false
    var longFixationFlag : Bool = false
}

class GazeDataHandler: NSObject { // usage: ojbect of DataStorage as dataStorage. making queue of dataStorage.
  
    private var data : [GazeData] = []
    private let constFixationCount : Int = 5
    private let constLongFixationCount: Int = 10
    private let constFixationDistancePixel : Int = 35  //
    
    func setGazeData(x : Double, y: Double){
        data.append(GazeData())
        let index = data.count - 1
        data[index].gazePoint = CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    func setGazeWebPoint(index: Int, x: CGFloat, y: CGFloat) {
        data[index].gazeWebPoint.x = x
        data[index].gazeWebPoint.y = y
    }
    
    
    func isFixation(index: Int) -> Bool {
        
        var tempX : CGFloat = 0.0
        var tempY : CGFloat = 0.0
        
        if index < 3 { return false }
        
        if index > constFixationCount + 1 {
            var i : Double = 0.0
            for j in (index - constFixationCount)...(index) {  // constFixaionCount - 10 !!
                let pixelX1 = abs(data[j-1].gazePoint.x - data[j].gazePoint.x)
                let pixelY1 = abs(data[j-1].gazePoint.y - data[j].gazePoint.y)
                let pixelX2 = abs(data[j-1].gazePoint.x - data[index].gazePoint.x)
                let pixelY2 = abs(data[j-1].gazePoint.y - data[index].gazePoint.y)
                i += 1
                tempX += data[j-1].gazePoint.x
                tempY += data[j-1].gazePoint.y
                if Int(pixelX1) > constFixationDistancePixel || Int(pixelY1) > constFixationDistancePixel || Int(pixelX2) > constFixationDistancePixel || Int(pixelY2) > constFixationDistancePixel {
                    data[index-1].fixationFlag = false
                    return false
                }
            }
            

            if data[index-2].longFixationFlag == true {
                data[index-1].longFixationFlag = true

            } else {
                var tempCount: Int = 0
                for i in stride(from: index - 2, through: index - 2 - constLongFixationCount, by: -1) {
                    if i < 0 { break }
                    if data[i].fixationFlag == true {
                        tempCount += 1
                    }
                }
                if tempCount >= constLongFixationCount {
                    data[index-1].longFixationFlag = true
                } else {
                    data[index-1].longFixationFlag = false
                }
            }
            
        }
        data[index-1].fixationFlag = true
        return true
        
    }
    
    func getGazeData(index: Int) -> CGPoint {
        if index < 0 || index > data.count - 1 {
            return CGPoint(x: 0, y: 0)
        } else {
            return data[index].gazePoint
        }
    }
    
    func getGazeDataIndex() -> Int {
        return data.count - 1
    }

    
    func getGazeWebData(index: Int) -> CGPoint {
        if index < 0 || index > data.count - 1 {
            return CGPoint(x: 0, y: 0)
        } else {
            return data[index].gazeWebPoint
        }
    }
}
