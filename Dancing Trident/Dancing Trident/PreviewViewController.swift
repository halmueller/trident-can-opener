//
//  PreviewViewController.swift
//  Dancing Trident
//
//  Created by Hal Mueller on 7/25/18.
//  Copyright © 2018 Hal Mueller. All rights reserved.
//

import Cocoa
import SceneKit

class PreviewViewController: NSViewController {

    var vehicleNode: SCNNode? = nil
    @IBOutlet weak var scnView: SCNView!

    @objc var pitchDegrees = 0.0 {
        didSet {
            self.adjustVehicleAttitude()
        }
    }
    @objc var yawDegrees = 0.0 {
        didSet {
            self.adjustVehicleAttitude()
        }
    }
    @objc var rollDegrees = 0.0 {
        didSet {
            self.adjustVehicleAttitude()
        }
    }
    @objc var useGizmo = false {
        didSet {
            if useGizmo {
                vehicleNode = gizmoNode
            }
            else {
                vehicleNode = tridentNode
            }
        }
    }
    let gizmoNode = SCNNode.gizmoNode(0.5)
    let tridentNode = SCNNode.tridentNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        let scene = SCNScene.standardScene()
        useGizmo = false
        scene.rootNode.addChildNode(vehicleNode!)

        // set the scene to the view
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.pointOfView?.position = SCNVector3(x: 0, y: 0, z: 1.5)
        scnView.pointOfView?.camera?.usesOrthographicProjection = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = NSColor.black

        self.adjustVehicleAttitude()
    }

    func adjustVehicleAttitude() {
        vehicleNode?.eulerAngles = SCNVector3(Attitude.scenekitPitchRadians(pitchDegrees),
                                              Attitude.scenekitYawRadians(yawDegrees),
                                              Attitude.scenekitRollRadians(rollDegrees))
    }
}
