import SceneKit
import SpriteKit

public class GizmoNode: SCNNode {
	
	required public override init() {
		super.init()
		let axisLength = CGFloat(3.0)
		let offset = CGFloat(axisLength/2.0)
		let axisSide = CGFloat(0.2)
		let chamferRadius = CGFloat(axisSide)
		
		let xBox = SCNBox(width: axisLength, height: axisSide, length: axisSide, chamferRadius: chamferRadius)
		xBox.firstMaterial?.diffuse.contents = NSColor.red

        let yBox = SCNBox(width: axisSide, height: axisLength, length: axisSide, chamferRadius: chamferRadius)
		yBox.firstMaterial?.diffuse.contents = NSColor.green

        let zBox = SCNBox(width: axisSide, height: axisSide, length: axisLength, chamferRadius: chamferRadius)
		zBox.firstMaterial?.diffuse.contents = NSColor.blue

        let xNode = SCNNode(geometry: xBox)
		let yNode = SCNNode(geometry: yBox)
		let zNode = SCNNode(geometry: zBox)
		self.addChildNode(xNode)
		self.addChildNode(yNode)
		self.addChildNode(zNode)
		xNode.position.x = offset
		yNode.position.y = offset
		zNode.position.z = offset
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

