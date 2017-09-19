//
//  ViewController.swift
//  StarWars
//
//  Created by chenxi on 2017/9/17.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, SCNPhysicsContactDelegate{

    @IBOutlet weak var arscnView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        
        arscnView.isUserInteractionEnabled = true
        
        arscnView.addGestureRecognizer(tap)
        
        let scene = SCNScene()
        arscnView.scene = scene
        arscnView.showsStatistics = true
        
        arscnView.scene.physicsWorld.contactDelegate = self
        
        //启动完成后添加飞船
        for _ in 1...3 {
            arscnView.addShip()
        }
        
    }
    
    @objc func tapClick() {
        //点击屏幕发射子弹
        
        print("发射子弹")
        
        arscnView.shootBullet()
        
        playSound(of: .torpedo)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = .horizontal
        config.isLightEstimationEnabled = true
        
        arscnView.session.run(config)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func removeNodeDynamic(node: SCNNode, isExplode: Bool) {
        playSound(of: .collision)
        
        if isExplode {
            
            playSound(of: .explosion)
            
            let psNode = SCNNode()
            
            if let ps = SCNParticleSystem(named: "explosion", inDirectory: nil) {
                psNode.addParticleSystem(ps)
            }
            
            psNode.position = node.position
            
            arscnView.scene.rootNode.addChildNode(psNode)
        }
        
        node.removeFromParentNode()
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("击中")
        
        removeNodeDynamic(node: contact.nodeB, isExplode: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.removeNodeDynamic(node: contact.nodeA, isExplode: true)
            
            self.arscnView.addShip()
        }
    }
    
}

