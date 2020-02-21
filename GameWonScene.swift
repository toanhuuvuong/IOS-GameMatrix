import SpriteKit

class GameWonScene : SKScene
{
    // -------------------- Attributes
    let touchSound: SKAction = SKAction.playSoundFileNamed("touch-sound", waitForCompletion: false)
    var playSound: Bool = true
    
    let menu: SKSpriteNode = SKSpriteNode(imageNamed: "menu")
    
    var levelFlags: [Bool] = []
    
    var minSize: CGFloat = 0.0
    // -------------------- Methods
    // --
    init(size: CGSize, levelFlags: [Bool], playSound: Bool)
    {
        super.init(size: size)
        
        self.levelFlags = levelFlags
        self.playSound = playSound
        minSize = (size.width < size.height) ? size.width : size.height
        
        let background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
        background.size = size
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.zPosition = 0.0
        addChild(background)
        
        let messageLabel: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        messageLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        messageLabel.zPosition = 0.1
        messageLabel.text = "YOU WON!"
        messageLabel.fontSize = minSize / 7
        messageLabel.fontColor = UIColor.white
        addChild(messageLabel)
        
        menu.size = CGSize(width: minSize / 4, height: minSize / 4)
        menu.position = CGPoint(x: size.width * 0.5, y: size.height * 0.4)
        menu.zPosition = 0.1
        addChild(menu)
    }
    // --
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if playSound
        {
            self.run(touchSound)
        }
        
        let touch: UITouch = touches.first!
        let touchLocation: CGPoint = touch.location(in: self)
        if menu.contains(touchLocation)
        {
            let actionWait: SKAction = SKAction.wait(forDuration: 0.5)
            let actionChangeScene: SKAction = SKAction.run
            {
                let scene: GameMenuScene = GameMenuScene(size: self.size, levelFlags: self.levelFlags)
                self.view?.presentScene(scene)
            }
            self.run(SKAction.sequence([actionWait, actionChangeScene]))
        }
    }
    // --
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Error :(")
    }
}
