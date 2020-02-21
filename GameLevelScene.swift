import SpriteKit

class GameLevelScene : SKScene
{
    // -------------------- Attributes
    let touchSound: SKAction = SKAction.playSoundFileNamed("touch-sound", waitForCompletion: false)
    var playSound: Bool = true
    
    let menu: SKSpriteNode = SKSpriteNode(imageNamed: "menu")
    
    var levels: [SKSpriteNode] = [SKSpriteNode].init(repeating: SKSpriteNode(), count: 16)
    
    var levelFlags: [Bool] = []
    
    var minSize: CGFloat = 0
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
        
        menu.size = CGSize(width: minSize / 5, height: minSize / 5)
        menu.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        menu.zPosition = 0.1
        addChild(menu)
        
        let numLevelsOnRow: Int = 4
        let padding: CGFloat = size.width / 8
        let levelWidth: CGFloat = minSize / 8
        let xOffset: CGFloat = (size.width - (levelWidth * CGFloat(numLevelsOnRow) + padding * CGFloat(numLevelsOnRow - 1))) / 2
        for i in 1...16
        {
            let imageNamed: String = (levelFlags[i - 1]) ? "level\(i)" : "level-locked"
            levels[i - 1] = SKSpriteNode(imageNamed: imageNamed)
            levels[i - 1].size = CGSize(width: minSize / 8, height: minSize / 8)
            let xLevel: CGFloat = levelWidth * (CGFloat(i) - 0.5 - CGFloat(numLevelsOnRow * ((i - 1) / numLevelsOnRow))) +
                padding * CGFloat(i - 1 - numLevelsOnRow * ((i - 1) / numLevelsOnRow)) + xOffset
            let yLevel: CGFloat = size.height * (0.55 - 0.15 * CGFloat((i - 1) / numLevelsOnRow))
            levels[i - 1].position = CGPoint(x: xLevel, y: yLevel)
            levels[i - 1].zPosition = 0.1
            
            addChild(levels[i - 1])
        }
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
            return
        }
        for (i, level) in levels.enumerated()
        {
            if level.contains(touchLocation) && levelFlags[i]
            {
                let scene: GameScene = GameScene(size: size, levelFlags: levelFlags, playSound: playSound, map: i)
                view?.presentScene(scene)
                break
            }
        }
    }
    // --
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Error :(")
    }
}

