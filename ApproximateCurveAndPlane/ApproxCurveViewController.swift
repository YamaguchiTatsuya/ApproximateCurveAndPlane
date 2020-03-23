//
//  ApproxCurveViewController.swift
//  ApproximateCurveAndPlane
//
//  Created by TATSUYA YAMAGUCHI on 2020/03/19.
//  Copyright © 2020 TATSUYA YAMAGUCHI. All rights reserved.
//

import Cocoa
import SceneKit

class ApproxCurveViewController: NSViewController {

    let points: [simd_float2] = [
        [0.0, 0.0],
        [0.5, 0.7],
        [1.0, 1.2],
        [1.4, 2.3],
        [2.1, 2.7],
        [2.6, 3.6],
        [3.0, 4.2],
        [3.5, 4.3],
        [4.2, 4.9],
        [4.7, 5.2],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        calculateApproximateCurve()
    }
    
    private func calculateApproximateCurve() {
        
        // 1) draw points' dots on chartView
        
        let chartLength = 500//both x and y, px
        let drawRate = 1.0 / Float(6) * Float(chartLength)
        
        let chartView = ChartView(frame: NSRect(x: 0, y: 0, width: chartLength, height: chartLength))
        
        for point in points {
            let point_px = point * drawRate
            DrawFunctions.DrawDot(point_px, chartView, color: NSColor.red)
        }
        
    
        // 2) calculate approx curve's coeffcients
        
        let degree = 2 // you can change
        let coefficients = CalcuFunctions.calculateApproximateCurve(for: points,
                                                                   degree: degree)

        
        // 3) draw approx curve line
        var linePoints: [simd_float2] = []

        for x: Float in stride(from: 0, to: 6, by: 0.1) {
            var y = Float(0)
            for ii in 0...degree {
                y = y + coefficients[ii] * powf(x, Float(ii))
            }
            let point = simd_float2(x, y)
            let point_px = point * drawRate
            linePoints.append(point_px)
        }
        chartView.linePoints = linePoints
        chartView.setNeedsDisplay(chartView.bounds)
        
        self.view.addSubview(chartView)
    }
    
}
