import ARKit

/// Class represents the Sun node
class SunNode: SCNNode {
    
    /// Name of the star in English
    let sunName: String = "Sun"
    /// Star spins clockwise from top
    let clockwiseSpin: Bool = false
    /// Number of hours the star takes to do full rotation
    let spinTime: Int = 587
    /// Diameter of the star in kilometers
    let diameter: Int = 1391400
    /// Fun fact
    let funFact: String = "The sun is 4.6 billion years old"
    
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
