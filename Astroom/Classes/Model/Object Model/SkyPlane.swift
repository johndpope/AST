import ARKit

class ASTSkyPlane : SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        // Create the plane geometry
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        // Set up the material
        self.setUpSkyMaterialOn(plane: plane)
        
        // Create node with plane geometry and material
        self.geometry = plane
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        self.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    }
    
    private func setUpSkyMaterialOn(plane: SCNPlane) {
        let nightMaterial = SCNMaterial()
        nightMaterial.diffuse.contents = #imageLiteral(resourceName: "night")
        nightMaterial.isDoubleSided = true
        plane.materials = [nightMaterial]
    }
}
