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
    @IBOutlet var actionButton: UIButton!
    
    let deviceMotionManager = ASTDeviceMotion()
    let session = ARSession()
    var sessionConfig: ARSessionConfiguration = ARWorldTrackingSessionConfiguration()
    var skyPlane: ASTSkyPlane!

    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup device motion manager
        deviceMotionManager.setupDeviceMotionManager()
        deviceMotionManager.motionDelegate = self
        
        // Setup Scene
        setupScene()
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
    
    // MARK: - ARKit / ARSCNView
    var screenCenter: CGPoint?
    
    func setupScene() {
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
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Add another plane node
        addPlane(node: node, on: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // Remove existing plane nodes
        removePlanes(node: node)
        // Add another plane node
        addPlane(node: node, on: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        // Remove existing plane nodes
        removePlanes(node: node)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
            case .notAvailable:
                // Not available
                helperView.formatHelperViewForMessage(ASTHelperConstants.trackingStateNotAvailable)
            case .limited:
                // Limited
                helperView.formatHelperViewForMessage(ASTHelperConstants.trackingStateLimited)
            case .normal:
                // Normal
                helperView.formatHelperViewForMessage(ASTHelperConstants.trackingStateNormal)
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
        
        let errorMessage = ASTHelpViewModel(image: #imageLiteral(resourceName: "ic_attention"), title: "Error", description: sessionErrorMsg)
        helperView.formatHelperViewForMessage(errorMessage)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        helperView.formatHelperViewForMessage(ASTHelperConstants.sessionInterrupted)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        restartSession(self)
    }
    
    // MARK: Action Methods
    
    @IBAction func restartSession(_ sender: Any) {
        guard actionButton.isUserInteractionEnabled else { return }
        
        DispatchQueue.main.async {
            // Disable the button temporarily
            self.actionButton.isUserInteractionEnabled = false
            // Display user a message
            self.helperView.formatHelperViewForMessage(ASTHelperConstants.newSession)
            
            // Disable Restart button for five seconds in order to give the session enough time to restart.
            DispatchQueue.main.asyncAfter(deadline: .now() + ASTUIConstants.actionButtonDisableDuration, execute: {
                self.actionButton.isUserInteractionEnabled = true
            })
        }
    }
    
    // MARK: Helper Methods
    
    /// Add a plane to a given node
    private func addPlane(node: SCNNode, on planeAnchor: ARPlaneAnchor) {
        skyPlane = ASTSkyPlane(anchor: planeAnchor)
        node.addChildNode(skyPlane)
    }
    
    /// Removes planes from the given node
    private func removePlanes(node: SCNNode) {
        skyPlane.removeFromParentNode()
    }
    
    // MARK: ASTDeviceMotionDelegate Methods
    
    // Function gets called when the device motion manger recognizes the orientation has changed state
    func orientationCorrectChanged(orientationCorrect: Bool) {
//        if orientationCorrect {
//            helperView.formatHelperViewForNoMessage()
//        } else {
//            helperView.formatHelperViewForMessage(ASTHelperConstants.orientationWarning)
//        }
    }
}
