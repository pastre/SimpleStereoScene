//
//  GyroTracker.swift
//  Celeste
//
//  Created by Bruno Pastre on 10/09/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import CoreMotion
import SceneKit

protocol GyroTrackerDelegate {
    func onGyroUpdate(to euler: SCNVector3)
    func onOrientationUpdate(to orientation: SCNVector4)
}

class GyroTracker {
    
    let updateDelta: TimeInterval = 1/60
    
    var delegate: GyroTrackerDelegate?
    var gyro: CMMotionManager!
    
    
    var currentX: Double!
    var currentY: Double!
    var currentZ: Double!
    
    init() {
        self.currentX = 0
        self.currentY = 0
        self.currentZ = 0
        
        self.gyro = CMMotionManager()
        self.gyro.deviceMotionUpdateInterval = self.updateDelta
        self.gyro.startDeviceMotionUpdates()
//        self.gyro.startGyroUpdates()
        
        Timer.scheduledTimer(withTimeInterval: self.updateDelta, repeats: true) { (_) in
            self.updateGyro()
        }
    }
    
    func updateGyro(){
        
        guard let data = self.gyro.deviceMotion else { return }
        
        let orientation = data.gaze(atOrientation: UIApplication.shared.statusBarOrientation)
        
        self.delegate?.onOrientationUpdate(to: orientation)
        
//        print("Gyro data is", data)
    }
    
}

extension CMDeviceMotion {
    
    func gaze(atOrientation orientation: UIInterfaceOrientation) -> SCNVector4 {
        
        let attitude = self.attitude.quaternion
        let aq = GLKQuaternionMake(Float(attitude.x), Float(attitude.y), Float(attitude.z), Float(attitude.w))
        
        let final: SCNVector4
        
        switch orientation {
            
        case .landscapeRight:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(Float.pi / 2, 0, 1, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: -q.y, y: q.x, z: q.z, w: q.w)
            
        case .landscapeLeft:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(-Float.pi / 2, 0, 1, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: q.y, y: -q.x, z: q.z, w: q.w)
            
        case .portraitUpsideDown:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(Float.pi / 2, 1, 0, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: -q.x, y: -q.y, z: q.z, w: q.w)
            
        case .unknown:
            
            fallthrough
            
        case .portrait:
            
            fallthrough
            
        @unknown default:
            
            let cq = GLKQuaternionMakeWithAngleAndAxis(-Float.pi / 2, 1, 0, 0)
            let q = GLKQuaternionMultiply(cq, aq)
            
            final = SCNVector4(x: q.x, y: q.y, z: q.z, w: q.w)
        }
        
        return final
    }
}
