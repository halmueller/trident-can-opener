import SceneKit
import SpriteKit

extension SCNNode {
    class func gizmoNode(_ axisLength: Double) -> SCNNode {
        let result = SCNNode()

		let axisLengthCG = CGFloat(axisLength)
		let offset = CGFloat(axisLengthCG/2.0)
		let axisSide = CGFloat(axisLength/10.0)
		let chamferRadius = CGFloat(axisSide)
		
		let xBox = SCNBox(width: axisLengthCG, height: axisSide, length: axisSide, chamferRadius: chamferRadius)
		xBox.firstMaterial?.diffuse.contents = NSColor.red

        let yBox = SCNBox(width: axisSide, height: axisLengthCG, length: axisSide, chamferRadius: chamferRadius)
		yBox.firstMaterial?.diffuse.contents = NSColor.green

        let zBox = SCNBox(width: axisSide, height: axisSide, length: axisLengthCG, chamferRadius: chamferRadius)
		zBox.firstMaterial?.diffuse.contents = NSColor.blue

        let xNode = SCNNode(geometry: xBox)
		let yNode = SCNNode(geometry: yBox)
		let zNode = SCNNode(geometry: zBox)
		result.addChildNode(xNode)
		result.addChildNode(yNode)
		result.addChildNode(zNode)
		xNode.position.x = offset
		yNode.position.y = offset
		zNode.position.z = offset

        return result
	}
}

