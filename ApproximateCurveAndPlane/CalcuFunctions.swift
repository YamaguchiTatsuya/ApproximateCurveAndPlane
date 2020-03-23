//
//  CalcuFunctions.swift
//  ApproximateCurveAndPlane
//
//  Created by TATSUYA YAMAGUCHI on 2020/03/19.
//  Copyright © 2020 TATSUYA YAMAGUCHI. All rights reserved.
//

import Cocoa
import SceneKit

class CalcuFunctions: NSObject {

    class func calculateApproximateCurve(for points: [simd_float2], degree: Int) -> [Float] {
        
        var xpow: [Float] = Array(repeating: 0.0, count: degree*2+1)
        var xpowy: [Float] = Array(repeating: 0.0, count: degree+1)
        
        for point in points {
            //left
            for jj in 0...degree*2 {
                xpow[jj] = xpow[jj] + powf(Float(point.x), Float(jj))
            }
            
            //right
            for jj in 0...degree {
                xpowy[jj] = xpowy[jj] + Float(point.y) * powf(Float(point.x), Float(jj))
            }
        }
        
        var matrixArray: [Float] = Array(repeating: 0.0, count: (degree+1)*(degree+2))
        
        //left
        for jj in 0...degree {
            for ii in 0...degree {
                matrixArray[jj*(degree+1)+ii] = xpow[jj+ii]
            }
        }
        //right
        for ii in 0...degree {
            matrixArray[(degree+1)*(degree+1)+ii] = xpowy[ii]
        }
        
        return calculateCoefficients(matrixArray: matrixArray,
                                     degree: degree)
    }
    
    class func calculateCoefficients(matrixArray: [Float], degree: Int) -> [Float] {
        
        //calculate coefficients with Gauss-Jordan elimination method
        
        var matrixArray = matrixArray
        let nn = degree+1
        
        for ii in 0..<nn {
            let temp1 = matrixArray[ii*nn+ii]
            for kk in ii..<nn+1 {
                matrixArray[kk*nn+ii] = matrixArray[kk*nn+ii]/temp1
            }
            
            for jj in 0..<nn {
                if jj != ii {
                    let temp2 = matrixArray[ii*nn+jj]
                    for kk in ii..<nn+1 {
                        matrixArray[kk*nn+jj] = matrixArray[kk*nn+jj] - temp2 * matrixArray[kk*nn+ii]
                    }
                }
            }
        }
        
        var coefficients: [Float] = []
        for ii in 0..<nn {
            coefficients.append(matrixArray[nn*nn+ii])
        }
        
        return coefficients
    }
}
