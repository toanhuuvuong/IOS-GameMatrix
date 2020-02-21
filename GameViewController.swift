import SpriteKit

class GameViewController: UIViewController
{
    // -------------------- Attributes
    // -------------------- Methods
    // -- Khung đã được tải lên
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let skView = self.view as! SKView?
        {
            skView.ignoresSiblingOrder = true
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.isMultipleTouchEnabled = false
            
            var levelFlags: [Bool] = [Bool].init(repeating: false, count: 16)
            
            if UserDefaults.standard.bool(forKey: "0") == false
            {
                levelFlags = [true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
                UserDefaults.standard.set(true, forKey: "0")
            }
            else
            {
                for i in 0...15
                {
                    levelFlags[i] = UserDefaults.standard.bool(forKey: "\(i)")
                }
            }
            
            let scene: GameMenuScene = GameMenuScene(size: skView.bounds.size, levelFlags: levelFlags)
            scene.scaleMode = SKSceneScaleMode.aspectFill
            
            skView.presentScene(scene)
        }
    }
    // --
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
}
