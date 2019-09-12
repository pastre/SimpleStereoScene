## Simple Stereo Scene
Simple Stereo Scene is built to allow a simple creation of Stereographic SceneKit scenes. It's main goal is to allow for a low-impact and fast transformation from any SCNScene to something that can be experienced with any VR glasses.
### Example
```
import SceneKit

class MyStereoViewController: UIViewController{
    let stereoGenerator = VRSceneGenerator()
    let sceneToPresent = SCNScene(named: "my_scene_name")
    func viewDidLoad(){
        self.stereoGenerator.attachStereoView(on: self.view, with: self.sceneToPresent)
    }
}
```


#### Usage

Instantiate a ```VRSceneGenerator``` object, and call it's ```attachStereoView(on : UIView, with : SCNScene)``` method. This will  transform the scene you provided to a stereographic scene, and then attach it to the view you specified. The ```VRSceneGenerator``` will read data from a ```CMMotionManager ``` and cast that movement into a head node it adds to the scene.
