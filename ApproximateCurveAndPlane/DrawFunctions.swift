//
//  DrawFunctions.swift
//  ApproximateCurveAndPlane
//
//  Created by TATSUYA YAMAGUCHI on 2020/03/19.
//  Copyright © 2020 TATSUYA YAMAGUCHI. All rights reserved.
//

import Cocoa
import SceneKit

class DrawFunctions: NSObject {

    //MARK: - in NSView
    
    class func DrawDot(_ p: simd_float2, _ view: NSView, color: NSColor) {
        
        let diameter = 10
        let dot = NSView(frame: NSRect(x: 0, y: 0, width: diameter, height: diameter))
        dot.backgroundColor = color
        dot.center = p.toCGPoint
        dot.layer?.cornerRadius = CGFloat(diameter/2)
        view.addSubview(dot)
    }
    
    //MARK: - for SceneKit
    
    class func setupSCNView(_ scnView: SCNView, with scene: SCNScene) {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.simdPosition = simd_float3(0, 3, 10)
        
        scnView.scene = scene
        
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor(white: 0.999, alpha: 1)
        scnView.isPlaying = true
        scnView.loops = true
    }
    
    class func drawCoordinateLinesOnScene(_ mainScene: SCNScene) {
        
        func DrawLineNode(_ positions: [SCNVector3], _ color: NSColor) {
            let indices: [Int32] = [0, 1]
//            let indexData = Data(bytes: UnsafeRawPointer(indices), count: 2*MemoryLayout<Int>.size)
            let indexData = Data(bytes: indices, count: 2*MemoryLayout<Int>.size)

            let vertexSource = SCNGeometrySource(vertices: positions)
            
            let element = SCNGeometryElement(data: indexData,
                                             primitiveType: SCNGeometryPrimitiveType.line,
                                             primitiveCount: 2,
                                             bytesPerIndex: MemoryLayout<Int32>.size)

            let line = SCNGeometry(sources: [vertexSource],
                                          elements: [element])
            let lineNode = SCNNode(geometry: line)

            line.materials.first?.diffuse.contents = color
            line.materials.first?.emission.contents = color
            
            mainScene.rootNode.addChildNode(lineNode)
        }
        
        
        let halfLength: Float = 10.0
        
        let xPositions = [SCNVector3(-halfLength, 0, 0),
                          SCNVector3(halfLength, 0, 0)]
        let xColor = NSColor.red
        
        let yPositions = [SCNVector3(0, -halfLength, 0),
                          SCNVector3(0, halfLength, 0)]
        let yColor = NSColor.green
        
        let zPositions = [SCNVector3(0, 0, -halfLength) ,
                         SCNVector3(0, 0, halfLength)]
        let zColor = NSColor.blue
        
        DrawLineNode(xPositions , xColor)
        DrawLineNode(yPositions , yColor)
        DrawLineNode(zPositions , zColor)
    }
    
    class func makeDotsNode(_ vertices: [simd_float3], radius: Float) -> SCNNode {
        
        let nofDots = vertices.count
//        let data = Data(bytes: UnsafeRawPointer(vertices) , count: nofDots*MemoryLayout<simd_float3>.size)
        let data = Data(bytes: vertices , count: nofDots*MemoryLayout<simd_float3>.size)

        let vertexSource = SCNGeometrySource(data: data,
                                             semantic: SCNGeometrySource.Semantic.vertex,
                                             vectorCount: nofDots,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<simd_float3>.size)
        let element = SCNGeometryElement(data: nil,
                                         primitiveType: .point,
                                         primitiveCount: nofDots,
                                         bytesPerIndex: 0)
        element.pointSize = 2.0*CGFloat(radius)
        element.minimumPointScreenSpaceRadius = CGFloat(radius)
        element.maximumPointScreenSpaceRadius = CGFloat(radius)
        
        let dots = SCNGeometry(sources: [vertexSource],
                               elements: [element])
        
        let node = SCNNode(geometry: dots)
        
        return node
    }
    
}
