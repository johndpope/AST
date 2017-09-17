import ARKit

/// Class represents the Sun node
class SunNode: SCNNode {
    
    /// Name of the star in English
    let sunName: String = "Sun"
    /// Star spins clockwise from top
    let clockwiseSpin: Bool = false
    /// Number of hours the star takes to do full rotation
    let spinTime: Double = 587
    /// Diameter of the star in kilometers
    let diameter: Float = 20
    /// Texture image of the planet
    var texture: UIImage!
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
        rotatePlanetOnAxis()
    }
    
    /// Function calculates the geometry of the planet
    private func calculateSunGeometry(_ anchor: ARPlaneAnchor) {
        let earthSphere = SCNSphere(radius: PlanetUnitMapper.radiusScaleMapping(diameter: self.diameter, anchor: anchor))
        earthSphere.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "SunText.jpg")
        self.geometry = earthSphere
    }
    
    /// Function calculates the position of the planet
    private func calculateSunPosition(_ anchor: ARPlaneAnchor) {
        self.position = PlanetUnitMapper.positionMapping(distanceToSun: 0, anchor: anchor)
    }
    
    /// Function rotates the planet on its own axis
    private func rotatePlanetOnAxis() {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = SCNVector4Make(0.0, 1.0, 0.0, Float.pi*2)
        animation.duration = PlanetUnitMapper.axisRotationMapping(spinTime: spinTime)
        animation.repeatCount = MAXFLOAT
        addAnimation(animation, forKey: nil)
    }
}
