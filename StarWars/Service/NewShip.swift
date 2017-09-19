//
//  NewShip.swift
//  StarWars
//
//  Created by chenxi on 2017/9/17.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import SceneKit
import ARKit

extension ARSCNView {
    func addShip() {
        let ship = Ship()
        
        let xy = randNum(type: 0)
        let z = randNum(type: 1)
        
        
        ship.position = SCNVector3(xy, xy, z)
        
        //摄像头方向运动
//        if let currentFrame = self.session.currentFrame {
//            let matrix = SCNMatrix4(currentFrame.camera.transform)
//            let direction = SCNVector3(matrix.m31, matrix.m32, matrix.m33)
//
//            ship.physicsBody?.applyForce(direction, asImpulse: true)
//
//        }
        
        self.scene.rootNode.addChildNode(ship)
        
    }
}

func randNum(type:Int = 0) -> Float {
    
    var randNum = Int(arc4random_uniform(8)) + 1
    var flag:Float
    
    if type == 1 {
        randNum += 10
        flag = -0.1
    } else {
        let flagNum = Int(arc4random_uniform(2))
        flag = (flagNum == 1) ? 0.1 : -0.1;
    }
    
    return Float(randNum) * flag
}



