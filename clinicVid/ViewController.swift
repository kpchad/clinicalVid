//
//  ViewController.swift
//  clinicVid
//
//  Created by Kyle Chadwick on 12/19/17.
//  Copyright © 2017 Kyle Chadwick. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
     let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // turn on vertical plane detection
        configuration.planeDetection = .vertical
        
        // run configuration
        sceneView.session.run(configuration)

        sceneView.delegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return}
        let wallArtNode = createWallArt(planeAnchor: planeAnchor)
        node.addChildNode(wallArtNode)
        print("vertical surface detected")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return}
        print("updating wall's anchor...")
        node.enumerateChildNodes{(childNode, _) in
            childNode.removeFromParentNode()
        }
        let wallArtNode = createWallArt(planeAnchor: planeAnchor)
        node.addChildNode(wallArtNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func createWallArt(planeAnchor: ARPlaneAnchor) -> SCNNode {
        //let wallArtNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))
        let wallArtNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        wallArtNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "wallArt")
        wallArtNode.geometry?.firstMaterial?.isDoubleSided = true
        //wallArtNode.position = SCNVector3(0,0,-1)
        wallArtNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        wallArtNode.eulerAngles = SCNVector3(3.14/2, 0,0)
        print("art added")
        return wallArtNode
    }

    func createArt() -> SCNNode {
        let ArtNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))
        ArtNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "wallArt")
        ArtNode.position = SCNVector3(0,0,-1)
        print("art added")
        return ArtNode
    }
    
    @IBAction func mask(_ sender: Any) {
        // add masking plane to background
    }
}
