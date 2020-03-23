//
//  Extensions.swift
//  ApproximateCurveAndPlane
//
//  Created by TATSUYA YAMAGUCHI on 2020/03/19.
//  Copyright © 2020 TATSUYA YAMAGUCHI. All rights reserved.
//

import Cocoa
import SceneKit

extension NSView {
    
    var x: CGFloat {
        return frame.origin.x
    }

    var y: CGFloat {
        return frame.origin.y
    }
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var center: CGPoint {
        get {
            return CGPoint(x: x + width/2,
                           y: y + height/2)
        }
        set {
            let center = newValue
            setFrameOrigin(CGPoint(x: center.x - width/2,
                                   y: center.y - height/2))
        }
    }
    
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
}

extension simd_float2 {
    var toCGPoint: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
