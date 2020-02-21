import SpriteKit

class GameMenuScene : SKScene
{
    // -------------------- Attributes
    let touchSound: SKAction = SKAction.playSoundFileNamed("touch-sound", waitForCompletion: false)
    var playSound: Bool = true
    let sound: SKSpriteNode = SKSpriteNode(imageNamed: "sound-on")
    let soundLabel: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    
    let play: SKSpriteNode = SKSpriteNode(imageNamed: "play")
    
    let gameSymbol: SKSpriteNode = SKSpriteNode(imageNamed: "game-symbol")
    
    var levelFlags: [Bool] = []
    
    var minSize: CGFloat = 0;
    // -------------------- Methods
    // --
    init(size: CGSize, levelFlags: [Bool])
    {
        super.init(size: size)
        minSize = (size.width < size.height) ? size.width : size.height
        
        self.levelFlags = levelFlags
        
        let background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
        background.size = size
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.zPosition = 0.0
        addChild(background)
        
        sound.size = CGSize(width: minSize / 10, height: minSize / 10)
        sound.position = CGPoint(x: size.width * 0.8, y: size.height * 0.8)
        sound.zPosition = 0.1
        addChild(sound)
        soundLabel.position = CGPoint(x: sound.position.x, y: sound.position.y - sound.size.height / 2 - 30.0)
        soundLabel.zPosition = 0.1
        soundLabel.text = "Sound on"
        soundLabel.fontSize = 15.0
        soundLabel.fontColor = UIColor.white
        addChild(soundLabel)
        
        play.size = CGSize(width: minSize / 4, height: minSize / 4)
        play.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        play.zPosition = 0.1
        addChild(play)
        
        gameSymbol.size = CGSize(width: minSize / 4, height: minSize / 4)
        gameSymbol.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        gameSymbol.zPosition = 0.1
        addChild(gameSymbol)
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
        if sound.contains(touchLocation) || soundLabel.contains(touchLocation)
        {
            if playSound
            {
                playSound = false
                sound.texture = SKTexture(imageNamed: "sound-off")
                soundLabel.text = "Sound off"
            }
            else
            {
                playSound = true
                sound.texture = SKTexture(imageNamed: "sound-on")
                soundLabel.text = "Sound on"
            }
        }
        if play.contains(touchLocation)
        {
            let actionWait: SKAction = SKAction.wait(forDuration: 0.5)
            let actionChangeScene: SKAction = SKAction.run
            {
                let scene: GameLevelScene = GameLevelScene(size: self.size, levelFlags: self.levelFlags, playSound: self.playSound)
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
