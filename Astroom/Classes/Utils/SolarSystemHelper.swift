import ARKit

class SolarSytemHelper {
    /// Function is a helper method to add all of the objects in the solar system to the scene
    static func addSolarSystem(mainVC: MainViewController, node: SCNNode, on planeAnchor: ARPlaneAnchor) {
        // Sky Plane
        if mainVC.skyPlane == nil {
            mainVC.skyPlane = ASTSkyPlane(anchor: planeAnchor)
            node.addChildNode(mainVC.skyPlane)
        }
        
        // Sun
        if mainVC.sun == nil {
            mainVC.sun = SunNode(anchor: planeAnchor)
            node.addChildNode(mainVC.sun)
        }
        
        // Mercury
        if mainVC.mercury == nil {
            mainVC.mercury = PlanetNode(planet: PlanetConstants.mercury, on: planeAnchor)
            node.addChildNode(mainVC.mercury)
        }
        
        // Venus
        if mainVC.venus == nil {
            mainVC.venus = PlanetNode(planet: PlanetConstants.venus, on: planeAnchor)
            node.addChildNode(mainVC.venus)
        }
        
        // Earth
        if mainVC.earth == nil {
            mainVC.earth = PlanetNode(planet: PlanetConstants.earth, on: planeAnchor)
            node.addChildNode(mainVC.earth)
        }
    }
    
    /// Function is a helper method to remove all of the objects in the solar system from the scene
    static func removeSolarSystem(mainVC: MainViewController) {
        if mainVC.skyPlane != nil {
            mainVC.skyPlane.removeFromParentNode()
            mainVC.skyPlane = nil
        }
        
        if mainVC.sun != nil {
            mainVC.sun.removeFromParentNode()
            mainVC.sun = nil
        }
        
        if mainVC.mercury != nil {
            mainVC.mercury.removeFromParentNode()
            mainVC.mercury = nil
        }
        
        if mainVC.venus != nil {
            mainVC.venus.removeFromParentNode()
            mainVC.venus = nil
        }
        
        if mainVC.earth != nil {
            mainVC.earth.removeFromParentNode()
            mainVC.earth = nil
        }
        
        if mainVC.mars != nil {
            mainVC.mars.removeFromParentNode()
            mainVC.mars = nil
        }
        
        if mainVC.jupiter != nil {
            mainVC.jupiter.removeFromParentNode()
            mainVC.jupiter = nil
        }
        
        if mainVC.saturn != nil {
            mainVC.saturn.removeFromParentNode()
            mainVC.saturn = nil
        }
        
        if mainVC.uranus != nil {
            mainVC.uranus.removeFromParentNode()
            mainVC.uranus = nil
        }
        
        if mainVC.neptune != nil {
            mainVC.neptune.removeFromParentNode()
            mainVC.neptune = nil
        }
        
        if mainVC.pluto != nil {
            mainVC.pluto.removeFromParentNode()
            mainVC.pluto = nil
        }
    }
}