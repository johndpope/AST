import ARKit

class PlutoNode: SCNNode {
    init(anchor: ARPlaneAnchor) {
        super.init()
        setupPluto(anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupPluto(_ anchor: ARPlaneAnchor) {
        calculatePlanetGeometry(anchor)
        calculatePlanetPosition(anchor)
    }
    
    /// Function calculates the geometry of the planet
    private func calculatePlanetGeometry(_ anchor: ARPlaneAnchor) {
        let size = (min(anchor.extent.x, anchor.extent.z)/4)
        let plutoSphere = SCNSphere(radius: CGFloat(size))
        plutoSphere.firstMaterial?.diffuse.contents = UIColor.blue
        self.geometry = plutoSphere
    }
    
    /// Function calculates the position of the planet
    private func calculatePlanetPosition(_ anchor: ARPlaneAnchor) {
        let xPosition = anchor.center.x + 1.5
        let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        let zPosition = anchor.center.z
        self.position = SCNVector3Make(xPosition, yPosition, zPosition)
    }
}
