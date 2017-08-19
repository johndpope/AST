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

class MainViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var helperView: HelperView!
    
    // MARK: Variables and Constants
    
    // Custom objects
    var skyPlane: SkyPlane!
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
    
    // ARSession
    let session = ARSession()
    var sessionConfig: ARSessionConfiguration = ARWorldTrackingSessionConfiguration()
    var screenCenter: CGPoint?
    
    // Tracking fallback
    var use3DOFTracking = false {
        didSet {
            if use3DOFTracking {
                sessionConfig = ARSessionConfiguration()
            }
            sessionConfig.isLightEstimationEnabled = true
            session.run(sessionConfig)
        }
    }
    var use3DOFTrackingFallback = false
    var trackingFallbackTimer: Timer?
    
    // Focus square
    var focusSquare: FocusSquare?
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup scene
        setUpScene()
        setUpFocusSquare()
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
        session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        helperView.formatHelperViewForMessage(HelperConstants.memoryWarning)
        session.pause()
    }
    
    // MARK: ARKit Methods
    
    func setUpScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.0
        
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
    
    func restartPlaneDetection() {
        // Configure session
        if let worldSessionConfig = sessionConfig as? ARWorldTrackingSessionConfiguration {
            worldSessionConfig.planeDetection = .horizontal
            session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            // Not available
            helperView.formatHelperViewForMessage(HelperConstants.trackingStateNotAvailable)
        case .limited:
            // Limited
            helperView.formatHelperViewForMessage(HelperConstants.trackingStateLimited)
            // Set up our tracking fallback system
            setUpTrackingFallback()
        case .normal:
            // Normal
            helperView.formatHelperViewForMessage(HelperConstants.trackingStateNormal)
            // Disable our tracking fallback system
            disableTrackingFallback()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard let errorMessage = self.setUpErrorMessageWith(error) else {
            return
        }
        
        helperView.formatHelperViewForMessage(errorMessage)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        helperView.formatHelperViewForMessage(HelperConstants.sessionInterrupted)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Add solar system to the scene
        SolarSytemHelper.addSolarSystem(mainVC: self, node: node, on: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Remove all nodes
        //removeAllNodes()
        // Add all nodes back
        //addAllNodes(node: node, on: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // Remove existing plane nodes
        SolarSytemHelper.removeSolarSystem(mainVC: self)
    }
    
    // MARK: Focus Square
    
    func setUpFocusSquare() {
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
    }
    
    func updateFocusSquare() {
        guard let screenCenter = screenCenter else { return }
        sun != nil ? focusSquare?.hide() : focusSquare?.unhide()
        
        let (worldPos, planeAnchor, _) = worldPositionFromScreenPosition(screenCenter, objectPos: focusSquare?.position)
        if let worldPos = worldPos {
            focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
        }
    }
    
    // MARK: Action Methods
    
    @IBAction func shareButtonPressed() {
        
    }
    
    @IBAction func restartButtonPressed(sender: AnyObject) {
        let restartButton = sender as! UIButton
        restartSession(button: restartButton)
    }
    
    // MARK: Helper Methods
    
    /// Function sets up error message for the HelperView
    private func setUpErrorMessageWith(_ error: Error) -> HelpViewModel? {
        guard let arError = error as? ARError else {
            return nil
        }
        
        let nsError = error as NSError
        var sessionErrorMsg = "\(nsError.localizedDescription) \(nsError.localizedFailureReason ?? "")"
        if let recoveryOptions = nsError.localizedRecoveryOptions {
            for option in recoveryOptions {
                sessionErrorMsg.append("\(option).")
            }
        }
        
        // Check if it is recoverable
        if (arError.code == .worldTrackingFailed) {
            sessionErrorMsg += "\nYou can try resetting the session or quit the application."
        } else {
            sessionErrorMsg += "\nThis is an unrecoverable error that requires to quit or restart the application."
        }
        
        return HelpViewModel(image: #imageLiteral(resourceName: "ic_attention"), title: "Error", description: sessionErrorMsg)
    }
    
    /// Function sets up tracking fallback option
    private func setUpTrackingFallback() {
        if use3DOFTrackingFallback {
            // After 10 seconds of limited quality, fall back to 3DOF mode.
            trackingFallbackTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { _ in
                self.use3DOFTracking = true
                self.trackingFallbackTimer?.invalidate()
                self.trackingFallbackTimer = nil
            })
        }
    }
    
    /// Function disables tracking fallback option
    private func disableTrackingFallback() {
        if use3DOFTrackingFallback && trackingFallbackTimer != nil {
            trackingFallbackTimer!.invalidate()
            trackingFallbackTimer = nil
        }
    }
    
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
    
    /// Function restarts the ARSession for the user, possibly because of an error
    private func restartSession(button: UIButton) {
        guard button.isUserInteractionEnabled else { return }
        
        DispatchQueue.main.async {
            // Disable the button temporarily
            button.isUserInteractionEnabled = false
            // Remove all nodes
            SolarSytemHelper.removeSolarSystem(mainVC: self)
            // Re set up focus square
            self.setUpFocusSquare()
            // Restart plane detection
            self.restartPlaneDetection()
            // Display user a message
            self.helperView.formatHelperViewForMessage(HelperConstants.newSession)
            // Reset our tracking bool
            self.use3DOFTracking = false
            
            // Disable Restart button for five seconds in order to give the session enough time to restart.
            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.actionButtonDisableDuration, execute: {
                button.isUserInteractionEnabled = true
            })
        }
    }
}
