
import UIKit
import SceneKit
import CoreMotion

enum StereoEye {
    case left, right
}

class VRSceneGenerator: NSObject, GyroTrackerDelegate {
    func updatedTransform(_ transform: matrix_float4x4, imagePixelBuffer: CVPixelBuffer) {
        
    }
    
    func onGyroUpdate(to value: SCNVector3) {
        guard  let node = self.headNode else  {
            return
        }
        
        print("Setting rotation to", value)
        
        var transform = node.transform
        transform = SCNMatrix4Rotate(transform, value.x, 1, 0, 0)
        transform = SCNMatrix4Rotate(transform, value.y, 0, 1, 0)
        transform = SCNMatrix4Rotate(transform, value.z, 0, 0, 1)
        
        node.transform = transform
    }
    
    func onOrientationUpdate(to orientation: SCNVector4) {
        self.headNode?.orientation = orientation
    }
    
    var gyroTracker: GyroTracker!
    
    var leftView: SCNView?
    var rightView: SCNView?
    var cameraLeftNode: SCNNode?
    var cameraRightNode: SCNNode?
    var headNode: SCNNode?
    
    var imageContext = CIContext(options: nil)
    
    override init() {
        super.init()
        self.gyroTracker = GyroTracker()
//        self.runner = VRTracker()
        
        self.gyroTracker.delegate = self
//        runner.delegate = self
    }
    
    func attachStereoView(on view: UIView, with scene: SCNScene) {

        leftView = SCNView()
        rightView = SCNView()
        
        leftView?.backgroundColor = .clear
        rightView?.backgroundColor = .clear
        
        view.addSubview(leftView!)
        view.addSubview(rightView!)
        
        leftView?.translatesAutoresizingMaskIntoConstraints = false
        rightView?.translatesAutoresizingMaskIntoConstraints = false

        leftView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        leftView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        leftView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        leftView?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        rightView?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.layoutIfNeeded()
        
        leftView?.scene = scene
        rightView?.scene = scene
        
        attachStereoCamera(to: scene.rootNode)
        
        leftView?.pointOfView = cameraLeftNode
        rightView?.pointOfView = cameraRightNode
        
        leftView?.play(nil)
        rightView?.play(nil)
        
    }
    
    func attachStereoCamera(to node: SCNNode) {
        let head = SCNNode()
        let nodeLeft = camera(for: .left)
        self.cameraLeftNode = nodeLeft
        
        let nodeRight = camera(for: .right)
        self.cameraRightNode = nodeRight
        
        head.addChildNode(nodeLeft)
        head.addChildNode(nodeRight)
        headNode = head
        
        node.addChildNode(head)
    }
    
    
    
    func camera(for eye: StereoEye) -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.name = eye == .left ? "stereoLeft" : "stereoRight"
        cameraNode.position = SCNVector3(eye == .left ? -0.2 : 0.2, 0, 0)
        let camera = SCNCamera()
        camera.zNear = 0.01
        camera.zFar = 1000
        cameraNode.camera = camera
        return cameraNode
    }
    
    // MARK: - VRTracker delegate methods
//    func updatedTransform(_ transform: matrix_float4x4, imagePixelBuffer: CVPixelBuffer) {
//        headNode?.simdTransform = transform
//    }
    
}
