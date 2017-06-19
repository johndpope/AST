//
//  ViewController.swift
//  Astroom
//
//  Created by Ryan on 10/06/17.
//  Copyright © 2017 Ryan-King. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ASTMainViewController: UIViewController, ARSCNViewDelegate, ASTDeviceMotionDelegate {
    
    // Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var informationView: UIView!
    @IBOutlet var helperView: ASTHelperView!
    
    // Variables and Constants
    let arSession = ARSession()
    let deviceMotionManager = ASTDeviceMotion()
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint?
    var sessionConfig: ARSessionConfiguration = ARWorldTrackingSessionConfiguration()
    var use3DOFTrackingFallback = false
    var trackingFallbackTimer: Timer?
    var use3DOFTracking = false {
        didSet {
            if use3DOFTracking {
                sessionConfig = ARSessionConfiguration()
            }
            sessionConfig.isLightEstimationEnabled = true
            arSession.run(sessionConfig)
        }
    }
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup device motion manager
        deviceMotionManager.setupDeviceMotionManager()
        deviceMotionManager.motionDelegate = self
        
        // Setup Scene
        setupScene()
        // Setup Focus Square
        setupFocusSquare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true
        // Start the ARSession.
        restartPlaneDetection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the session on disappear
        arSession.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: Setup Methods
    
    func restartPlaneDetection() {
        // Configure session
        if let worldSessionConfig = sessionConfig as? ARWorldTrackingSessionConfiguration {
            worldSessionConfig.planeDetection = .horizontal
            arSession.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
        }
        
        // Reset timer
        if trackingFallbackTimer != nil {
            trackingFallbackTimer!.invalidate()
            trackingFallbackTimer = nil
        }
    }
    
    func setupScene() {
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/AllPlanets/AllPlanetsScene.scn")!
        //sceneView.scene = scene
        sceneView.session = arSession
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 2.0
        
        DispatchQueue.main.async {
            self.screenCenter = self.sceneView.bounds.mid
        }
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    // MARK: - Focus Square
    
    func setupFocusSquare() {
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
    }
    
    func updateFocusSquare() {
        guard let screenCenter = screenCenter else { return }
        
        let (worldPos, planeAnchor, _) = worldPositionFromScreenPosition(screenCenter, objectPos: focusSquare?.position)
        if let worldPos = worldPos {
            focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.arSession.currentFrame?.camera)
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // If light estimation is enabled, update the intensity of the model's lights and the environment map
            if let lightEstimate = self.arSession.currentFrame?.lightEstimate {
                self.enableEnvironmentMapWithIntensity(lightEstimate.ambientIntensity / 40)
            } else {
                self.enableEnvironmentMapWithIntensity(25)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//
//            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//
//            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//                
//            }
        }
    }
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        switch camera.trackingState {
        case .notAvailable:
                print("Camera unavailable")
        case .limited:
            if use3DOFTrackingFallback {
                // After 10 seconds of limited quality, fall back to 3DOF mode.
                trackingFallbackTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { _ in
                    self.use3DOFTracking = true
                    self.trackingFallbackTimer?.invalidate()
                    self.trackingFallbackTimer = nil
                })
            } else {
                //textManager.escalateFeedback(for: camera.trackingState, inSeconds: 10.0)
            }
        case .normal:
            if use3DOFTrackingFallback && trackingFallbackTimer != nil {
                trackingFallbackTimer!.invalidate()
                trackingFallbackTimer = nil
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
        guard let arError = error as? ARError else { return }
        
        let nsError = error as NSError
        var sessionErrorMsg = "\(nsError.localizedDescription) \(nsError.localizedFailureReason ?? "")"
        if let recoveryOptions = nsError.localizedRecoveryOptions {
            for option in recoveryOptions {
                sessionErrorMsg.append("\(option).")
            }
        }
        
        let isRecoverable = (arError.code == .worldTrackingFailed)
        if isRecoverable {
            sessionErrorMsg += "\nYou can try resetting the session or quit the application."
        } else {
            sessionErrorMsg += "\nThis is an unrecoverable error that requires to quit the application."
        }
        
        //displayErrorMessage(title: "We're sorry!", message: sessionErrorMsg, allowRestart: isRecoverable)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        //textManager.blurBackground()
        //textManager.showAlert(title: "Session Interrupted", message: "The session will be reset after the interruption has ended.")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        //textManager.unblurBackground()
        arSession.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        //restartExperience(self)
        //textManager.showMessage("RESETTING SESSION")
    }
    
    // MARK: Helper Methods
    
    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        
        // -------------------------------------------------------------------------------
        // 1. Always do a hit test against exisiting plane anchors first.
        //    (If any such anchors exist & only within their extents.)
        
        let planeHitTestResults = sceneView.hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {
            
            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor
            
            // Return immediately - this is the best possible outcome.
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        // -------------------------------------------------------------------------------
        // 2. Collect more information about the environment by hit testing against
        //    the feature point cloud, but do not return the result yet.
        
        var featureHitTestPosition: SCNVector3?
        var highQualityFeatureHitTestResult = false
        
        let highQualityfeatureHitTestResults = sceneView.hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0)
        
        if !highQualityfeatureHitTestResults.isEmpty {
            let result = highQualityfeatureHitTestResults[0]
            featureHitTestPosition = result.position
            highQualityFeatureHitTestResult = true
        }
        
        // -------------------------------------------------------------------------------
        // 3. If desired or necessary (no good feature hit test result): Hit test
        //    against an infinite, horizontal plane (ignoring the real world).
        
        if !highQualityFeatureHitTestResult {
            
            let pointOnPlane = objectPos ?? SCNVector3Zero
            
            let pointOnInfinitePlane = sceneView.hitTestWithInfiniteHorizontalPlane(position, pointOnPlane)
            if pointOnInfinitePlane != nil {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        
        // -------------------------------------------------------------------------------
        // 4. If available, return the result of the hit test against high quality
        //    features if the hit tests against infinite planes were skipped or no
        //    infinite plane was hit.
        
        if highQualityFeatureHitTestResult {
            return (featureHitTestPosition, nil, false)
        }
        
        // -------------------------------------------------------------------------------
        // 5. As a last resort, perform a second, unfiltered hit test against features.
        //    If there are no features in the scene, the result returned here will be nil.
        
        let unfilteredFeatureHitTestResults = sceneView.hitTestWithFeatures(position)
        if !unfilteredFeatureHitTestResults.isEmpty {
            let result = unfilteredFeatureHitTestResults[0]
            return (result.position, nil, false)
        }
        
        return (nil, nil, false)
    }
    
    // MARK: ASTDeviceMotionDelegate Methods
    
    // Function gets called when the device motion manger recognizes the orientation has changed state
    func orientationCorrectChanged(orientationCorrect: Bool) {
        if orientationCorrect {
            helperView.formatHelperViewForNoMessage()
        } else {
            helperView.formatHelperViewForMessage(ASTHelperConstants.orientationWarning)
        }
    }
}
