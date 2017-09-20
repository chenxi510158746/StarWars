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
import ReplayKit

class ViewController: UIViewController, SCNPhysicsContactDelegate, RPPreviewViewControllerDelegate{

    var isOpen:Bool! = false
    
    @IBOutlet weak var arscnView: ARSCNView!
    
    @IBOutlet weak var replayBtn: UIButton!
    
    @IBAction func runReplay(_ sender: UIButton) {
        let recorder = RPScreenRecorder.shared()
        
        if isOpen {
            self.isOpen = false
            sender.setTitle("启动录制", for: .normal)
            sender.tintColor = UIColor.white
            sender.backgroundColor = UIColor.green
            recorder.stopRecording(handler: { (previewViewController, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "停止错误！")
                } else {
                    previewViewController?.previewControllerDelegate = self;
                    self.present(previewViewController!, animated: true, completion: {
                        
                    })
                    
                }
            })
            
        } else {
            self.isOpen = true
            sender.setTitle("正在录制", for: .normal)
            sender.tintColor = UIColor.white
            sender.backgroundColor = UIColor.red
            recorder.startRecording(handler: { (error) in
                if error != nil {
                    print(error?.localizedDescription ?? "开始错误！")
                } else {
                    
                }
            })
            
        }
    }
    
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
        
        replayBtn.setTitle("启动录制", for: .normal)
        replayBtn.tintColor = UIColor.white
        replayBtn.backgroundColor = UIColor.green
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
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true) {
            
        }
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        previewController.dismiss(animated: true) {
            
        }
    }
    
}

