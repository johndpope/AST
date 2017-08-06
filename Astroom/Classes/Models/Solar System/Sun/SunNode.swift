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
    let diameter: Float = 1391400
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
        let earthSphere = SCNSphere(radius: PlanetUnitMapper.radiusScaleMapping(diameter: self.diameter, anchor: anchor))
        earthSphere.firstMaterial?.diffuse.contents = UIColor.orange
        self.geometry = earthSphere
    }
    
    /// Function calculates the position of the planet
    private func calculateSunPosition(_ anchor: ARPlaneAnchor) {
        self.position = PlanetUnitMapper.positionMapping(distanceToSun: 0, anchor: anchor)
    }
}
