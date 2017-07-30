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
    let deviceMotionManager = DeviceMotion()
    var skyPlane: ASTSkyPlane!
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
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - ARSCNViewDelegate
    
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
    
    /// Function restarts the ARSession for the user, possibly because of an error
    private func restartSession(button: UIButton) {
        guard button.isUserInteractionEnabled else { return }
        
        DispatchQueue.main.async {
            // Disable the button temporarily
            button.isUserInteractionEnabled = false
            // Remove all nodes
            SolarSytemHelper.removeSolarSystem(mainVC: self)
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
