import ARKit

class JupiterNode: SCNNode {
    init(anchor: ARPlaneAnchor) {
        super.init()
        setupJupiter(anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupJupiter(_ anchor: ARPlaneAnchor) {
        calculatePlanetGeometry(anchor)
        calculatePlanetPosition(anchor)
    }
    
    /// Function calculates the geometry of the planet
    private func calculatePlanetGeometry(_ anchor: ARPlaneAnchor) {
        let size = (min(anchor.extent.x, anchor.extent.z)/4)
        let jupiterSphere = SCNSphere(radius: CGFloat(size))
        jupiterSphere.firstMaterial?.diffuse.contents = UIColor.blue
        self.geometry = jupiterSphere
    }
    
    /// Function calculates the position of the planet
    private func calculatePlanetPosition(_ anchor: ARPlaneAnchor) {
        let xPosition = anchor.center.x + 1.5
        let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        let zPosition = anchor.center.z
        self.position = SCNVector3Make(xPosition, yPosition, zPosition)
    }
}

