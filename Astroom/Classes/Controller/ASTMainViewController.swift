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

class ASTMainViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var informationView: UIView!
    @IBOutlet var helperView: ASTHelperView!
    
    // MARK: Variables and Constants
    
    // Custom objects
    let deviceMotionManager = ASTDeviceMotion()
    var skyPlane: ASTSkyPlane!
    var solarSystem: ASTSolarSystem!
    
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
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup helper view
        helperView.helperDelegate = self
        // Setup scene
        setUpScene()
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
        session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
        helperView.formatHelperViewForMessage(ASTHelperConstants.memoryWarning)
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
        sceneView.contentScaleFactor = 1.3
        
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
            helperView.formatHelperViewForMessage(ASTHelperConstants.trackingStateNotAvailable)
        case .limited:
            // Limited
            helperView.formatHelperViewForMessage(ASTHelperConstants.trackingStateLimited)
            // Set up our tracking fallback system
            setUpTrackingFallback()
        case .normal:
            // Normal
            helperView.formatHelperViewForMessage(ASTHelperConstants.trackingStateNormal)
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
        helperView.formatHelperViewForMessage(ASTHelperConstants.sessionInterrupted)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        restartSession(button: helperView.actionButton)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Add another plane node
        addPlane(node: node, on: planeAnchor)
        // Add solar system to the scene
        addSolarSytem(node: node, on: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Remove existing plane nodes
        removePlanes()
        // Add another plane node
        addPlane(node: node, on: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        // Remove existing plane nodes
        removePlanes()
    }
    
    // MARK: Helper Methods
    
    /// Add the solar system to the scene
    private func addSolarSytem(node: SCNNode, on planeAnchor: ARPlaneAnchor) {
        solarSystem = ASTSolarSystem(anchor: planeAnchor)
        node.addChildNode(solarSystem)
    }
    
    /// Removes the solar system from scene
    private func removeSolarSytem() {
        solarSystem.removeFromParentNode()
    }
    
    /// Add a plane to a given node
    private func addPlane(node: SCNNode, on planeAnchor: ARPlaneAnchor) {
        skyPlane = ASTSkyPlane(anchor: planeAnchor)
        node.addChildNode(skyPlane)
    }
    
    /// Removes planes from the given node
    private func removePlanes() {
        skyPlane.removeFromParentNode()
    }
    
    /// Function sets up error message for the ASTHelperView
    private func setUpErrorMessageWith(_ error: Error) -> ASTHelpViewModel? {
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
        
        return ASTHelpViewModel(image: #imageLiteral(resourceName: "ic_attention"), title: "Error", description: sessionErrorMsg)
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
    
    /// Function restarts the ARSession for the user, possibly because of an error
    private func restartSession(button: UIButton) {
        guard button.isUserInteractionEnabled else { return }
        
        DispatchQueue.main.async {
            // Disable the button temporarily
            button.isUserInteractionEnabled = false
            // Remove all nodes
            self.removePlanes()
            self.removeSolarSytem()
            // Restart plane detection
            self.restartPlaneDetection()
            // Display user a message
            self.helperView.formatHelperViewForMessage(ASTHelperConstants.newSession)
            // Reset our tracking bool
            self.use3DOFTracking = false
            
            // Disable Restart button for five seconds in order to give the session enough time to restart.
            DispatchQueue.main.asyncAfter(deadline: .now() + ASTUIConstants.actionButtonDisableDuration, execute: {
                button.isUserInteractionEnabled = true
            })
        }
    }
}

// MARK: ASTHelperViewDelegate Methods

extension ASTMainViewController: ASTHelperViewDelegate {
    /// Function gets called when the user presses the action button on the ASTHelperView
    func actionButtonPressed(button: UIButton) {
        restartSession(button: button)
    }
}
