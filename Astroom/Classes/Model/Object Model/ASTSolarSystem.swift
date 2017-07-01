import ARKit

class ASTSolarSystem : SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        // Load the model of the solar system
        self.loadSolarSystemModel(modelName: "AllPlanets", fileExtension: "scn", directory: "art.scnassets/")
        
        // Calculate the solar systems position
        self.calculateSolarSystemPosition(anchor: anchor)
        
        // Calculate the solar systems scale
        self.calculateSolarSystemScale(anchor: anchor)
        
        // Calculate the solar systems orientation
        self.calculateSolarSystemOrientation()
    }
    
    func loadSolarSystemModel(modelName: String, fileExtension: String, directory: String) {
        
        guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)", inDirectory: "\(directory)\(modelName)") else {
            return
        }
        
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            child.movabilityHint = .movable
            self.addChildNode(child)
        }
    }
    
    private func calculateSolarSystemScale(anchor: ARPlaneAnchor) {
        //let xPosition = anchor.center.x
        //let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        //let zPosition = anchor.center.z
        
        self.boundingBox = (SCNVector3Make(2, 2, 2), SCNVector3Make(2, 2, 2))
    }
    
    private func calculateSolarSystemPosition(anchor: ARPlaneAnchor) {
        let xPosition = anchor.center.x
        let yPosition = (((anchor.extent.x + anchor.extent.z)/2)/2)
        let zPosition = anchor.center.z
        
        self.position = SCNVector3Make(xPosition, yPosition, zPosition)
    }
    
    private func calculateSolarSystemOrientation() {
        // Objects are are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        self.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    }
}
