import ARKit

/// Class represents a planet node
class PlanetNode: SCNNode {
    
    // MARK: Variables
    
    /// Name of the planet in English
    var planetName: String!
    /// Index of the planet to the sun, i.e sun is 0, mercury is 1...
    var index: Int!
    /// Distance to the sun in kilometers
    var distanceToSun: Float!
    /// Planet spins clockwise from top
    var clockwiseSpin: Bool!
    /// Number of hours the planet takes to do full rotation
    var spinTime: Int!
    /// Number of days the planet takes to do full orbit around the sun
    var orbitTime: Double!
    /// Diameter of the planet in kilometers
    var diameter: Float!
    /// Texture image of the planet
    var texture: UIImage!
    /// Fun fact
    var funFact: String!
    
    // MARK: Initialization Methods
    
    init(planet: PlanetViewModel, on anchor: ARPlaneAnchor) {
        super.init()
        
        self.planetName = planet.name
        self.index = planet.index
        self.distanceToSun = planet.distanceToSun
        self.clockwiseSpin = planet.clockwiseSpin
        self.spinTime = planet.spinTime
        self.orbitTime = planet.orbitTime
        self.diameter = planet.diameter
        self.texture = planet.texture
        self.funFact = planet.funFact
        
        setupPlanet(anchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helper Methods
    
    private func setupPlanet(_ anchor: ARPlaneAnchor) {
        calculatePlanetGeometry(anchor)
        calculatePlanetPosition(anchor)
    }
    
    /// Function calculates the geometry of the planet
    private func calculatePlanetGeometry(_ anchor: ARPlaneAnchor) {
        let earthSphere = SCNSphere(radius: PlanetUnitMapper.radiusScaleMapping(diameter: self.diameter, anchor: anchor))
        
        earthSphere.firstMaterial?.diffuse.contents = texture
        
        self.geometry = earthSphere
    }
    
    /// Function calculates the position of the planet
    private func calculatePlanetPosition(_ anchor: ARPlaneAnchor) {
        self.position = PlanetUnitMapper.positionMapping(distanceToSun: self.distanceToSun, anchor: anchor)
    }
}
