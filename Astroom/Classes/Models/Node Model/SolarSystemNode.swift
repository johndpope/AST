import ARKit

class SolarSystemNode : SCNNode {
    
    var sun: SunNode!
    var mercury: PlanetNode!
    var venus: PlanetNode!
    var earth: PlanetNode!
    var mars: PlanetNode!
    var jupiter: PlanetNode!
    var saturn: PlanetNode!
    var uranus: PlanetNode!
    var neptune: PlanetNode!
    var pluto: PlanetNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        addPlanetsToSolarSystem(on: anchor)
    }
    
    /// Function is a helper method to add all of the objects in the solar system to the scene
    func addPlanetsToSolarSystem(on planeAnchor: ARPlaneAnchor) {
        // Sun
        if sun == nil {
            sun = SunNode(anchor: planeAnchor)
            addChildNode(sun)
        }
        
        // Mercury
        if mercury == nil {
            mercury = PlanetNode(planet: PlanetConstants.mercury, on: planeAnchor)
            addChildNode(mercury)
        }
        
        // Venus
        if venus == nil {
            venus = PlanetNode(planet: PlanetConstants.venus, on: planeAnchor)
            addChildNode(venus)
        }
        
        // Earth
        if earth == nil {
            earth = PlanetNode(planet: PlanetConstants.earth, on: planeAnchor)
            addChildNode(earth)
        }
        
        // Mars
        if mars == nil {
            mars = PlanetNode(planet: PlanetConstants.mars, on: planeAnchor)
            addChildNode(mars)
        }
        
        // Jupiter
        if jupiter == nil {
            jupiter = PlanetNode(planet: PlanetConstants.jupiter, on: planeAnchor)
            addChildNode(jupiter)
        }
        
        // Saturn
        if saturn == nil {
            saturn = PlanetNode(planet: PlanetConstants.saturn, on: planeAnchor)
            addChildNode(saturn)
        }
        
        // Uranus
        if uranus == nil {
            uranus = PlanetNode(planet: PlanetConstants.uranus, on: planeAnchor)
            addChildNode(uranus)
        }
        
        // Neptune
        if neptune == nil {
            neptune = PlanetNode(planet: PlanetConstants.neptune, on: planeAnchor)
            addChildNode(neptune)
        }
        
        // Pluto
        if pluto == nil {
            pluto = PlanetNode(planet: PlanetConstants.pluto, on: planeAnchor)
            addChildNode(pluto)
        }
    }
    
    /// Function is a helper method to remove all of the objects in the solar system from the scene
    func removePlanetsFromSolarSystem() {
        if sun != nil {
            sun.removeFromParentNode()
            sun = nil
        }
        
        if mercury != nil {
            mercury.removeFromParentNode()
            mercury = nil
        }
        
        if venus != nil {
            venus.removeFromParentNode()
            venus = nil
        }
        
        if earth != nil {
            earth.removeFromParentNode()
            earth = nil
        }
        
        if mars != nil {
            mars.removeFromParentNode()
            mars = nil
        }
        
        if jupiter != nil {
            jupiter.removeFromParentNode()
            jupiter = nil
        }
        
        if saturn != nil {
            saturn.removeFromParentNode()
            saturn = nil
        }
        
        if uranus != nil {
            uranus.removeFromParentNode()
            uranus = nil
        }
        
        if neptune != nil {
            neptune.removeFromParentNode()
            neptune = nil
        }
        
        if pluto != nil {
            pluto.removeFromParentNode()
            pluto = nil
        }
    }
    
    /// Function orbits the planet around the sun
    private func rotatePlanetOnOrbit(planet: PlanetNode, _ anchor: ARPlaneAnchor) {
        planet.pivot = sun.pivot
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = SCNVector4Make(0.0, 1.0, 0.0, Float.pi*2)
        animation.duration = 2
        animation.repeatCount = MAXFLOAT
        planet.addAnimation(animation, forKey: nil)
    }
}
