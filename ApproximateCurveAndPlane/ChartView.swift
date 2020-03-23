//
//  ChartView.swift
//  M200303Basic
//
//  Created by TATSUYA YAMAGUCHI on 2020/03/18.
//  Copyright © 2020 TATSUYA YAMAGUCHI. All rights reserved.
//

import Cocoa
import SceneKit

class ChartView: NSView {

    var linePoints: [simd_float2]?
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        backgroundColor = NSColor.white
        
        guard let linePoints = linePoints else { return }
        
        if linePoints.count < 2 { return }

        NSColor.gray.set()
        let figure = NSBezierPath()
        for (index, point) in linePoints.enumerated() {
            if index == 0 {
                figure.move(to: point.toCGPoint)
            } else {
                figure.line(to: point.toCGPoint)
            }
        }
        figure.lineWidth = 1
        figure.stroke()
    }
}
