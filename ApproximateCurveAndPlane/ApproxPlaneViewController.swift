//
//  ApproxPlaneViewController.swift
//  ApproximateCurveAndPlane
//
//  Created by TATSUYA YAMAGUCHI on 2020/03/19.
//  Copyright © 2020 TATSUYA YAMAGUCHI. All rights reserved.
//

import Cocoa
import SceneKit

class ApproxPlaneViewController: NSViewController {

    @IBOutlet weak var scnView: SCNView!
    
    private let scene: SCNScene! = SCNScene(named: "art.scnassets/ship.scn")
    
    let points: [simd_float3] = [
        [-3.0, 0.0, 3.0],
        [2.5, 0.7, 2.2],
        [-1.0, 1.2, 2.0],
        [2.4, 0.3, 0.5],
        [-2.1, 1.7, 1.3],
        [1.6, 0.6, -2.1],
        [-2.0, 1.2, -1.1],
        [3.5, 1.3, -1.9],
        [-3.2, 2.9, -2.0],
        [3.7, 1.2, -3.7],
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupScene()
        calculateApproximatePlane()
        
    }
    
    private func setupScene() {
        
        DrawFunctions.setupSCNView(scnView, with:scene)
        DrawFunctions.drawCoordinateLinesOnScene(scene)
    }
    
    private func calculateApproximatePlane() {
        
        // 1) draw points' dots
        
        let node = DrawFunctions.makeDotsNode(points, radius: Float(10))
        node.geometry?.firstMaterial?.diffuse.contents = NSColor.red
        scene.rootNode.addChildNode(node)
        
        
        // 2) make matrix
        
        let degree = 2
        var matrixArray: [Float] = Array(repeating: 0.0, count: (degree+1)*(degree+2))
        
        matrixArray[0] = Float(points.count)
        matrixArray[1] = points.reduce(0) { $0 + $1.x }
        matrixArray[2] = points.reduce(0) { $0 + $1.y }
        matrixArray[3] = matrixArray[1]
        matrixArray[4] = points.reduce(0) { $0 + powf($1.x, 2.0) }
        matrixArray[5] = points.reduce(0) { $0 + $1.x*$1.y }
        matrixArray[6] = matrixArray[2]
        matrixArray[7] = matrixArray[5]
        matrixArray[8] = points.reduce(0) { $0 + powf($1.y, 2.0) }
        
        matrixArray[9] = points.reduce(0) { $0 + $1.z }
        matrixArray[10] = points.reduce(0) { $0 + $1.x*$1.z }
        matrixArray[11] = points.reduce(0) { $0 + $1.y*$1.z }
        
        let r = CalcuFunctions.calculateCoefficients(matrixArray: matrixArray,
                                                    degree: degree)
        
        
        print("coefficients: ",r)
        
        
        
        //---------------------------------------------------
        //calculate by inverse matrix (without Gauss-Jordan elimination)
        let m0: simd_float3 = [matrixArray[0],
                               matrixArray[1],
                               matrixArray[2]]
        let m1: simd_float3 = [matrixArray[3],
                               matrixArray[4],
                               matrixArray[5]]
        let m2: simd_float3 = [matrixArray[6],
                               matrixArray[7],
                               matrixArray[8]]
        let m: simd_float3x3 = simd_float3x3(m0, m1, m2)
        let b: simd_float3 = [matrixArray[9],
                              matrixArray[10],
                              matrixArray[11]]
        let invM = simd_inverse(m)
        let answer = invM * b
        print("answer: ", answer)// same with coefficients :)
        // simd can calculate inverse matrix under 4 degree, so you can use inverse matrix. I noticed it later.
        //---------------------------------------------------
        

        
        
        // 3) draw least squares plane (by many small dots)
        // z=a+bx+cy : plane equation
        var planeDots: [simd_float3] = []
        for y: Float in stride(from: -10, to: 10, by: 0.1) {
            for x: Float in stride(from: -10, to: 10, by: 0.1) {
                let z = r[0] + r[1]*x + r[2]*y
                planeDots.append(simd_float3(x, y, z))
            }
        }
        let planeDotsNode = DrawFunctions.makeDotsNode(planeDots, radius: Float(1))
        planeDotsNode.geometry?.firstMaterial?.diffuse.contents = NSColor(white: 0.5, alpha: 0.5)
        scene.rootNode.addChildNode(planeDotsNode)
    }
}
