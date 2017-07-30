import ARKit

class PlanetNode: SCNNode {
    
    var planetName: String!
    var index: Int!
    var clockwiseSpin: Bool!
    var spinTime: Int!
    var orbitTime: Double!
    var diameter: Int!
    var texture: UIImage!
    var funFact: String!
    
    init(planet: PlanetViewModel, on anchor: ARPlaneAnchor) {
        super.init()
        
        self.planetName = planet.name
        self.index = planet.index
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
    
    private func setupPlanet(_ anchor: ARPlaneAnchor) {
        calculatePlanetGeometry(anchor)
        calculatePlanetPosition(anchor)
    }
    
    /// Function calculates the geometry of the planet
    private func calculatePlanetGeometry(_ anchor: ARPlaneAnchor) {
        let size = (min(anchor.extent.x, anchor.extent.z)/8)
        let earthSphere = SCNSphere(radius: CGFloat(size))
        earthSphere.firstMaterial?.diffuse.contents = texture
        self.geometry = earthSphere
    }
    
    /// Function calculates the position of the planet
    private func calculatePlanetPosition(_ anchor: ARPlaneAnchor) {
        let xPosition = anchor.center.x + 0.5
        let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        let zPosition = anchor.center.z
        self.position = SCNVector3Make(xPosition, yPosition, zPosition)
    }
}
