import ARKit

class SunNode: SCNNode {
    
    let name = "Sun"
    let clockwiseSpin = false
    let spinTime = 587
    let diameter = 1391400
    let funFact = "The sun is 4.6 billion years old"
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        setupSun(anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupSun(_ anchor: ARPlaneAnchor) {
        calculateSunGeometry(anchor)
        calculateSunPosition(anchor)
    }
    
    /// Function calculates the geometry of the planet
    private func calculateSunGeometry(_ anchor: ARPlaneAnchor) {
        let size = (min(anchor.extent.x, anchor.extent.z)/2)
        let earthSphere = SCNSphere(radius: CGFloat(size))
        earthSphere.firstMaterial?.diffuse.contents = UIColor.orange
        self.geometry = earthSphere
    }
    
    /// Function calculates the position of the planet
    private func calculateSunPosition(_ anchor: ARPlaneAnchor) {
        let xPosition = anchor.center.x
        let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        let zPosition = anchor.center.z
        self.position = SCNVector3Make(xPosition, yPosition, zPosition)
    }
}
