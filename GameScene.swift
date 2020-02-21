import SpriteKit

// == Màn hình hiển thị nội dung game
class GameScene: SKScene
{
    // -------------------- Attributes
    // -- Các sound sử dụng trong game
    let passingBarSound: SKAction = SKAction.playSoundFileNamed("passing-bar-sound", waitForCompletion: false) // sound khi player đi qua thanh chắn
    let moveSound: SKAction = SKAction.playSoundFileNamed("move-sound", waitForCompletion: false) // sound khi player di chuyển
    let matchSound: SKAction = SKAction.playSoundFileNamed("match-sound", waitForCompletion: false) // sound khi player đến được đích
    var playSound: Bool = true // cờ kiểm tra sound on/off
    // -- Kích cỡ 1 block cờ
    var tileWidth: CGFloat = 0.0
    var tileHeight: CGFloat = 0.0
    var minSize: CGFloat = 0.0
    // -- Options
    let replay: SKSpriteNode = SKSpriteNode(imageNamed: "replay")
    let menu: SKSpriteNode = SKSpriteNode(imageNamed: "menu")
    // -- Các button di chuyển
    var isMove: Bool = false
    // -- Cấp độ
    var level: Level!
    let levelLabel: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    var map: Int = 0
    var levelFlags: [Bool] = []
    // -- Các layer chứa nội dung game
    let gameLayer: SKNode = SKNode() // chứa tất cả các layer khác
    let tileSquaresLayer: SKNode = SKNode() // chứa các node tile của square
    let squaresLayer: SKNode = SKNode() // chứa các node square
    let tileCorner2DsLayer: SKNode = SKNode() // chứa các node tile của corner2D
    let corner2DsLayer: SKNode = SKNode() // chứa các node corner2D
    // -------------------- Methods
    // -- Khởi tạo màn chơi
    init(size: CGSize, levelFlags: [Bool], playSound: Bool, map: Int)
    {
        super.init(size: size)
        minSize = (size.width < size.height) ? size.width : size.height
        anchorPoint = CGPoint(x: 0.5, y: 0.5) // Gốc toạ độ nằm giữa màn hình
        self.levelFlags = levelFlags
        self.playSound = playSound
        self.map = map
        beginGame(map: map)
        
        // Thiết lập background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = size
        background.zPosition = 0.05
        
        addChild(gameLayer)
        
        let layerPosition: CGPoint = CGPoint(x: -tileWidth * CGFloat(numCols) / 2, y: -tileHeight * CGFloat(numRows) / 2)
        
        tileSquaresLayer.position = layerPosition
        tileSquaresLayer.zPosition = 0.0
        squaresLayer.position = layerPosition
        squaresLayer.zPosition = 0.1
        tileCorner2DsLayer.position = CGPoint(x: layerPosition.x - tileWidth / 2, y: layerPosition.y - tileHeight / 2)
        tileCorner2DsLayer.zPosition = 0.0
        corner2DsLayer.position = CGPoint(x: layerPosition.x - tileWidth / 2, y: layerPosition.y - tileHeight / 2)
        corner2DsLayer.zPosition = 0.1
        
        gameLayer.addChild(background)
        gameLayer.addChild(tileSquaresLayer)
        gameLayer.addChild(squaresLayer)
        gameLayer.addChild(tileCorner2DsLayer)
        gameLayer.addChild(corner2DsLayer)
    }
    // --
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Error :(")
    }
    // Tạo map thông qua level
    func beginGame(map: Int)
    {
        tileWidth = minSize / 12
        tileHeight = minSize / 12
        
        replay.size = CGSize(width: minSize / 16, height: minSize / 16)
        replay.position = pointFor(col: 0, row: numRows - 1)
        replay.position.x -= tileWidth / 2
        replay.position.y += tileHeight / 4
        replay.zPosition = 0.1
        squaresLayer.addChild(replay)
        
        menu.size = CGSize(width: minSize / 16, height: minSize / 16)
        menu.position = pointFor(col: 1, row: numRows - 1)
        menu.position.x -= tileWidth / 2
        menu.position.y += tileHeight / 4
        menu.zPosition = 0.1
        squaresLayer.addChild(menu)
        
        level = Level(fileNamed: "Level-\(map)")
        levelLabel.position = pointFor(col: numCols - 1, row: numRows - 1)
        levelLabel.position.y -= (levelLabel.fontSize / 2 - tileHeight / 4)
        levelLabel.zPosition = 0.1
        levelLabel.text = "\(map + 1)/16"
        levelLabel.fontSize = minSize / 20
        levelLabel.fontColor = UIColor.white
        squaresLayer.addChild(levelLabel)
        
        addTileSquares()
        addTileCorner2Ds()
        
        let newSquares: Set<Square> = level.setSquares()
        addSquareSprites(for: newSquares)
        
        let newCorner2Ds: Set<Corner2D> = level.setCorner2Ds()
        addCorner2DSprites(for: newCorner2Ds)
        
        let newPlayer: Player = level.player!
        addPlayerSprite(player: newPlayer)
        
        let newDestination: Destination = level.destination!
        addDestinaionSprite(destination: newDestination)
    }
    //--
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch: UITouch = touches.first
            else
        {
            return
        }
        
        let touchLocation: CGPoint = touch.location(in: squaresLayer)
        
        if replay.contains(touchLocation)
        {
            let scene: GameScene = GameScene(size: size, levelFlags: levelFlags, playSound: playSound, map: map)
            view?.presentScene(scene)
            return
        }
        if menu.contains(touchLocation)
        {
            let scene: GameLevelScene = GameLevelScene(size: size, levelFlags: levelFlags, playSound: playSound)
            view?.presentScene(scene)
            return
        }
    }
    // --
    func moveDirecting(src: CGPoint, dest: CGPoint)
    {
        let tanSD: CGFloat = abs(src.y - dest.y) / abs(src.x - dest.x)
        
        if src.y < dest.y && tanSD >= 1.0
        {
            level.player?.direction = PlayerDirection.UP
        }
        else if src.x < dest.x && tanSD >= 0 && tanSD < 1.0
        {
            level.player?.direction = PlayerDirection.RIGHT
        }
        else if src.y > dest.y && tanSD >= 1.0
        {
            level.player?.direction = PlayerDirection.DOWN
        }
        else if src.x > dest.x && tanSD >= 0 && tanSD < 1.0
        {
            level.player?.direction = PlayerDirection.LEFT
        }
    }
    //--
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch: UITouch = touches.first
            else
        {
            return
        }
        
        let touchLocation: CGPoint = touch.location(in: squaresLayer)
        let touchPrevious: CGPoint = touch.previousLocation(in: squaresLayer)
        
        moveDirecting(src: touchPrevious, dest: touchLocation)
    }
    // --
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if isMove == false
        {
            isMove = true
            checkActionFor(player: level.player!)
            level.player!.direction = PlayerDirection.STOP
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                self.isMove = false
            }
        }
    }
    // --
    func checkActionFor(player: Player)
    {
        // Các biến cần dùng
        let col: Int = player.col
        let row: Int = player.row
        
        let tileSquareLeft: Tile? = level.tileSquareAt(col: col - 1, row: row)
        let tileSquareRight: Tile? = level.tileSquareAt(col: col + 1, row: row)
        let tileSquareTop: Tile? = level.tileSquareAt(col: col, row: row + 1)
        let tileSquareBottom: Tile? = level.tileSquareAt(col: col, row: row - 1)
        let square: Square? = level.squareAt(col: col, row: row)
        let squareLeft: Square? = level.squareAt(col: col - 1, row: row)
        let squareRight: Square? = level.squareAt(col: col + 1, row: row)
        let squareTop: Square? = level.squareAt(col: col, row: row + 1)
        let squareBottom: Square? = level.squareAt(col: col, row: row - 1)
        
        let tileCorner2DZero: Tile? = level.tileCorner2DAt(col: col, row: row + 1)
        let tileCorner2DOne: Tile? = level.tileCorner2DAt(col: col + 1, row: row + 1)
        let tileCorner2DTwo: Tile? = level.tileCorner2DAt(col: col + 1, row: row)
        let tileCorner2DThree: Tile? = level.tileCorner2DAt(col: col, row: row)
        let corner2DZero: Corner2D? = level.corner2DAt(col: col, row: row + 1)
        let corner2DOne: Corner2D? = level.corner2DAt(col: col + 1, row: row + 1)
        let corner2DTwo: Corner2D? = level.corner2DAt(col: col + 1, row: row)
        let corner2DThree: Corner2D? = level.corner2DAt(col: col, row: row)
        
        if player.direction == PlayerDirection.LEFT
        {
            // Kiểm tra square
            if square == nil || square!.type.spriteName.contains("left") || tileSquareLeft == nil || squareLeft!.type.spriteName.contains("right")
            {
                return
            }
            // Kiểm tra corner2DZero & corner2DThree
            if (tileCorner2DZero == nil && tileCorner2DThree == nil) ||
                (corner2DZero?.cornerAt(num: 2) == nil && corner2DZero?.cornerAt(num: 3) == nil &&
                    corner2DThree?.cornerAt(num: 1) == nil && corner2DThree?.cornerAt(num: 0) == nil)
            {
                moveFor(player: player, direction: PlayerDirection.LEFT)
                return
            }
            // Kiểm tra thanh chắn
            if (corner2DZero?.cornerAt(num: 2) != nil && corner2DZero?.barAt(num: 2)?.type == BarType.VERTICAL) ||
                (corner2DThree?.cornerAt(num: 1) != nil && corner2DThree?.barAt(num: 1)?.type == BarType.VERTICAL)
            {
                return
            }
            // Kiểm tra xoay thanh chắn
            moveFor(player: player, direction: PlayerDirection.LEFT)
            if corner2DZero?.cornerAt(num: 2) != nil && corner2DZero?.barAt(num: 2)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DZero!.barAt(num: 2)!, left: false)
            }
            if corner2DZero?.cornerAt(num: 3) != nil && corner2DZero?.barAt(num: 3)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DZero!.barAt(num: 3)!, left: false)
            }
            if corner2DThree?.cornerAt(num: 1) != nil && corner2DThree?.barAt(num: 1)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DThree!.barAt(num: 1)!, left: true)
            }
            if corner2DThree?.cornerAt(num: 0) != nil && corner2DThree?.barAt(num: 0)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DThree!.barAt(num: 0)!, left: true)
            }
        }
        else if player.direction == PlayerDirection.RIGHT
        {
            // Kiểm tra square
            if square == nil || square!.type.spriteName.contains("right") || tileSquareRight == nil || squareRight!.type.spriteName.contains("left")
            {
                return
            }
            // Kiểm tra corner2DOne & corner2DTwo
            if (tileCorner2DOne == nil && tileCorner2DTwo == nil) ||
                (corner2DOne?.cornerAt(num: 3) == nil && corner2DOne?.cornerAt(num: 2) == nil &&
                    corner2DTwo?.cornerAt(num: 0) == nil && corner2DTwo?.cornerAt(num: 1) == nil)
            {
                moveFor(player: player, direction: PlayerDirection.RIGHT)
                return
            }
            // Kiểm tra thanh chắn
            if (corner2DOne?.cornerAt(num: 3) != nil && corner2DOne?.barAt(num: 3)?.type == BarType.VERTICAL) ||
                (corner2DTwo?.cornerAt(num: 0) != nil && corner2DTwo?.barAt(num: 0)?.type == BarType.VERTICAL)
            {
                return
            }
            // Kiểm tra xoay thanh chắn
            moveFor(player: player, direction: PlayerDirection.RIGHT)
            if corner2DOne?.cornerAt(num: 3) != nil && corner2DOne?.barAt(num: 3)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DOne!.barAt(num: 3)!, left: true)
            }
            if corner2DOne?.cornerAt(num: 2) != nil && corner2DOne?.barAt(num: 2)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DOne!.barAt(num: 2)!, left: true)
            }
            if corner2DTwo?.cornerAt(num: 0) != nil && corner2DTwo?.barAt(num: 0)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DTwo!.barAt(num: 0)!, left: false)
            }
            if corner2DTwo?.cornerAt(num: 1) != nil && corner2DTwo?.barAt(num: 1)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DTwo!.barAt(num: 1)!, left: false)
            }
        }
        else if player.direction == PlayerDirection.UP
        {
            // Kiểm tra square
            if square == nil || square!.type.spriteName.contains("top") || tileSquareTop == nil || squareTop!.type.spriteName.contains("bottom")
            {
                return
            }
            // Kiểm tra corner2DZero & corner2DOne
            if (tileCorner2DZero == nil && tileCorner2DOne == nil) ||
                (corner2DZero?.cornerAt(num: 2) == nil && corner2DZero?.cornerAt(num: 1) == nil &&
                    corner2DOne?.cornerAt(num: 3) == nil && corner2DOne?.cornerAt(num: 0) == nil)
            {
                moveFor(player: player, direction: PlayerDirection.UP)
                return
            }
            // Kiểm tra thanh chắn
            if (corner2DZero?.cornerAt(num: 2) != nil && corner2DZero?.barAt(num: 2)?.type == BarType.HORIZONTAL) ||
                (corner2DOne?.cornerAt(num: 3) != nil && corner2DOne?.barAt(num: 3)?.type == BarType.HORIZONTAL)
            {
                return
            }
            // Kiểm tra xoay thanh chắn
            moveFor(player: player, direction: PlayerDirection.UP)
            if corner2DZero?.cornerAt(num: 2) != nil && corner2DZero?.barAt(num: 2)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DZero!.barAt(num: 2)!, left: true)
            }
            if corner2DZero?.cornerAt(num: 1) != nil && corner2DZero?.barAt(num: 1)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DZero!.barAt(num: 1)!, left: true)
            }
            if corner2DOne?.cornerAt(num: 3) != nil && corner2DOne?.barAt(num: 3)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DOne!.barAt(num: 3)!, left: false)
            }
            if corner2DOne?.cornerAt(num: 0) != nil && corner2DOne?.barAt(num: 0)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DOne!.barAt(num: 0)!, left: false)
            }
        }
        else if player.direction == PlayerDirection.DOWN
        {
            // Kiểm tra square
            if square == nil || square!.type.spriteName.contains("bottom") || tileSquareBottom == nil || squareBottom!.type.spriteName.contains("top")
            {
                return
            }
            // Kiểm tra corner2DTwo & corner2DThree
            if (tileCorner2DTwo == nil && tileCorner2DThree == nil) ||
                (corner2DTwo?.cornerAt(num: 0) == nil && corner2DTwo?.cornerAt(num: 3) == nil &&
                    corner2DThree?.cornerAt(num: 1) == nil && corner2DThree?.cornerAt(num: 2) == nil)
            {
                moveFor(player: player, direction: PlayerDirection.DOWN)
                return
            }
            // Kiểm tra thanh chắn
            if (corner2DTwo?.cornerAt(num: 0) != nil && corner2DTwo?.barAt(num: 0)?.type == BarType.HORIZONTAL) ||
                (corner2DThree?.cornerAt(num: 1) != nil && corner2DThree?.barAt(num: 1)?.type == BarType.HORIZONTAL)
            {
                return
            }
            // Kiểm tra xoay thanh chắn
            moveFor(player: player, direction: PlayerDirection.DOWN)
            if corner2DTwo?.cornerAt(num: 0) != nil && corner2DTwo?.barAt(num: 0)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DTwo!.barAt(num: 0)!, left: true)
            }
            if corner2DTwo?.cornerAt(num: 3) != nil && corner2DTwo?.barAt(num: 3)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DTwo!.barAt(num: 3)!, left: true)
            }
            if corner2DThree?.cornerAt(num: 1) != nil && corner2DThree?.barAt(num: 1)?.type == BarType.VERTICAL
            {
                rotateFor(bar: corner2DThree!.barAt(num: 1)!, left: false)
            }
            if corner2DThree?.cornerAt(num: 2) != nil && corner2DThree?.barAt(num: 2)?.type == BarType.HORIZONTAL
            {
                rotateFor(bar: corner2DThree!.barAt(num: 2)!, left: false)
            }
        }
    }
    // --
    func moveFor(player: Player, direction: PlayerDirection)
    {
        if playSound
        {
            self.run(moveSound)
        }
        
        let duration: Double = 0.1
        switch direction
        {
        case PlayerDirection.LEFT:
            if level.tileSquareAt(col: player.col - 1, row: player.row) != nil
            {
                player.sprite?.size = CGSize(width: tileWidth * 0.8, height: tileHeight * 0.4)
                let actionMove: SKAction = SKAction.move(to: pointFor(col: player.col - 1, row: player.row), duration: duration)
                let actionMoveDone: SKAction = SKAction.run
                {
                    player.sprite?.size = CGSize(width: self.tileWidth * 0.6, height: self.tileHeight * 0.6)
                    player.direction = PlayerDirection.STOP
                    player.col -= 1
                }
                player.sprite?.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        case PlayerDirection.RIGHT:
            if level.tileSquareAt(col: player.col + 1, row: player.row) != nil
            {
                player.sprite?.size = CGSize(width: tileWidth * 0.8, height: tileHeight * 0.4)
                let actionMove: SKAction = SKAction.move(to: pointFor(col: player.col + 1, row: player.row), duration: duration)
                let actionMoveDone: SKAction = SKAction.run
                {
                    player.sprite?.size = CGSize(width: self.tileWidth * 0.6, height: self.tileHeight * 0.6)
                    player.direction = PlayerDirection.STOP
                    player.col += 1
                }
                player.sprite?.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        case PlayerDirection.UP:
            if level.tileSquareAt(col: player.col, row: player.row + 1) != nil
            {
                player.sprite?.size = CGSize(width: tileWidth * 0.4, height: tileHeight * 0.8)
                let actionMove: SKAction = SKAction.move(to: pointFor(col: player.col, row: player.row + 1), duration: duration)
                let actionMoveDone: SKAction = SKAction.run
                {
                    player.sprite?.size = CGSize(width: self.tileWidth * 0.6, height: self.tileHeight * 0.6)
                    player.direction = PlayerDirection.STOP
                    player.row += 1
                }
                player.sprite?.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        case PlayerDirection.DOWN:
            if level.tileSquareAt(col: player.col, row: player.row - 1) != nil
            {
                player.sprite?.size = CGSize(width: tileWidth * 0.4, height: tileHeight * 0.8)
                let actionMove: SKAction = SKAction.move(to: pointFor(col: player.col, row: player.row - 1), duration: duration)
                let actionMoveDone: SKAction = SKAction.run
                {
                    player.sprite?.size = CGSize(width: self.tileWidth * 0.6, height: self.tileHeight * 0.6)
                    player.direction = PlayerDirection.STOP
                    player.row -= 1
                }
                player.sprite?.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        default:
            break
        }
    }
    // --
    func rotateFor(bar: Bar, left: Bool)
    {
        if playSound
        {
            self.run(passingBarSound)
        }
        
        let duration: Double = 0.1
        if left
        {
            let actionRotate: SKAction = SKAction.rotate(toAngle: bar.sprite!.zRotation + CGFloat.pi / 2, duration: duration)
            let actionRotateDone: SKAction = SKAction.run
            {
                bar.type = (bar.type == BarType.VERTICAL) ? BarType.HORIZONTAL : BarType.VERTICAL
            }
            bar.sprite?.run(SKAction.sequence([actionRotate, actionRotateDone]))
        }
        else
        {
            let actionRotate: SKAction = SKAction.rotate(toAngle: bar.sprite!.zRotation - CGFloat.pi / 2, duration: duration)
            let actionRotateDone: SKAction = SKAction.run
            {
                bar.type = (bar.type == BarType.VERTICAL) ? BarType.HORIZONTAL : BarType.VERTICAL
            }
            bar.sprite?.run(SKAction.sequence([actionRotate, actionRotateDone]))
        }
    }
    // -- Toạ độ cho vị trí (col, row)
    private func pointFor(col: Int, row: Int) -> CGPoint
    {
        return CGPoint(x: CGFloat(col) * tileWidth + tileWidth / 2, y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    // -- Là hàm đối của hàm pointFor, chuyển toạ độ point -> bộ (bool, col, row) trong squaresLayer, giá trị bool thể hiện tính hợp lệ của point
    private func convertPoint(point: CGPoint) -> (Bool, Int, Int)
    {
        if point.x >= 0 && point.x < tileWidth * CGFloat(numCols) && point.y >= 0 && point.y < tileHeight * CGFloat(numRows)
        {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        }
        return (false, 0, 0)
    }
    // -- Toạ độ cho vị trí (col, row, num) của góc
    private func pointFor(col: Int, row: Int, num: Int) -> CGPoint
    {
        var point: CGPoint = pointFor(col: col, row: row)
        switch num
        {
        case 0:
            point.x -= tileWidth / 4
            point.y += tileHeight / 4
        case 1:
            point.x += tileWidth / 4
            point.y += tileHeight / 4
        case 2:
            point.x += tileWidth / 4
            point.y -= tileHeight / 4
        case 3:
            point.x -= tileWidth / 4
            point.y -= tileHeight / 4
        default:
            break
        }
        return point
    }
    // -- Thêm các node tile square vào tileSquaresLayer
    func addTileSquares()
    {
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                let tileNode: SKSpriteNode = SKSpriteNode(imageNamed: "Unknown")
                tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                tileNode.position = pointFor(col: col, row: row)
                tileSquaresLayer.addChild(tileNode)
            }
        }
    }
    // -- Thêm các node tile corner2D vào tileCorner2DsLayer
    func addTileCorner2Ds()
    {
        for row in 0...numRows
        {
            for col in 0...numCols
            {
                let tileNode: SKSpriteNode = SKSpriteNode(imageNamed: "Unknown")
                tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                tileNode.position = pointFor(col: col, row: row)
                tileCorner2DsLayer.addChild(tileNode)
            }
        }
    }
    // -- Thêm các node sprite ô vuông vào squaresLayer
    func addSquareSprites(for squares: Set<Square>)
    {
        for square in squares
        {
            let sprite: SKSpriteNode = square.sprite!
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(col: square.col, row: square.row)
            squaresLayer.addChild(sprite)
        }
    }
    // -- Cập nhật vị trí của thanh chắn bar theo góc corner mà nó đặt vào
    func updateBarPosionAndSize(corner: inout Corner)
    {
        if let cornerSprite: SKSpriteNode = corner.sprite, let barSprite: SKSpriteNode = corner.bar?.sprite
        {
            let xBar: CGFloat
            let yBar: CGFloat
            let cornerPos: CGPoint = cornerSprite.position
            if corner.bar?.type == BarType.VERTICAL
            {
                barSprite.size = CGSize(width: tileHeight / 10, height: tileHeight)
                
                switch corner.type
                {
                case CornerType.ZERO:
                    barSprite.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                    xBar = cornerPos.x + tileWidth / 4
                    yBar = cornerPos.y - tileHeight / 4
                case CornerType.ONE:
                    barSprite.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                    xBar = cornerPos.x - tileWidth / 4
                    yBar = cornerPos.y - tileHeight / 4
                case CornerType.TWO:
                    barSprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                    xBar = cornerPos.x - tileWidth / 4
                    yBar = cornerPos.y + tileHeight / 4
                case CornerType.THREE:
                    barSprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                    xBar = cornerPos.x + tileWidth / 4
                    yBar = cornerPos.y + tileHeight / 4
                }
            }
            else
            {
                barSprite.size = CGSize(width: tileWidth, height: tileHeight / 10)
                
                switch corner.type
                {
                case CornerType.ZERO:
                    barSprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
                    xBar = cornerPos.x + tileWidth / 4
                    yBar = cornerPos.y - tileHeight / 4
                case CornerType.ONE:
                    barSprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
                    xBar = cornerPos.x - tileWidth / 4
                    yBar = cornerPos.y - tileHeight / 4
                case CornerType.TWO:
                    barSprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
                    xBar = cornerPos.x - tileWidth / 4
                    yBar = cornerPos.y + tileHeight / 4
                case CornerType.THREE:
                    barSprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
                    xBar = cornerPos.x + tileWidth / 4
                    yBar = cornerPos.y + tileHeight / 4
                }
            }
            barSprite.position = CGPoint(x: xBar, y: yBar)
            barSprite.zPosition = 0.1
            corner.bar?.sprite = barSprite
        }
    }
    // -- Thêm các node sprite corner vào corner2DsLayer
    func addCorner2DSprites(for corner2Ds: Set<Corner2D>)
    {
        for corner2D in corner2Ds
        {
            if var cornerZero: Corner = corner2D.corners[0, 0]
            {
                let spriteZero: SKSpriteNode = (cornerZero.sprite)!
                spriteZero.size = CGSize(width: tileWidth / 2, height: tileHeight / 2)
                spriteZero.position = pointFor(col: corner2D.col, row: corner2D.row, num: 0)
                spriteZero.zPosition = 0.2
                
                updateBarPosionAndSize(corner: &cornerZero)
                let spriteBarZero: SKSpriteNode = (cornerZero.bar?.sprite)!
                
                corner2DsLayer.addChild(spriteZero)
                corner2DsLayer.addChild(spriteBarZero)
            }
            if var cornerOne: Corner = corner2D.corners[0, 1]
            {
                let spriteOne: SKSpriteNode = (cornerOne.sprite)!
                spriteOne.size = CGSize(width: tileWidth / 2, height: tileHeight / 2)
                spriteOne.position = pointFor(col: corner2D.col, row: corner2D.row, num: 1)
                spriteOne.zPosition = 0.2
                
                updateBarPosionAndSize(corner: &cornerOne)
                let spriteBarOne: SKSpriteNode = (cornerOne.bar?.sprite)!
                
                corner2DsLayer.addChild(spriteOne)
                corner2DsLayer.addChild(spriteBarOne)
            }
            if var cornerTwo: Corner = corner2D.corners[1, 1]
            {
                let spriteTwo: SKSpriteNode = (cornerTwo.sprite)!
                spriteTwo.size = CGSize(width: tileWidth / 2, height: tileHeight / 2)
                spriteTwo.position = pointFor(col: corner2D.col, row: corner2D.row, num: 2)
                spriteTwo.zPosition = 0.2
                
                updateBarPosionAndSize(corner: &cornerTwo)
                let spriteBarTwo: SKSpriteNode = (cornerTwo.bar?.sprite)!
                
                corner2DsLayer.addChild(spriteTwo)
                corner2DsLayer.addChild(spriteBarTwo)
            }
            if var cornerThree: Corner = corner2D.corners[1, 0]
            {
                let spriteThree: SKSpriteNode = (cornerThree.sprite)!
                spriteThree.size = CGSize(width: tileWidth / 2, height: tileHeight / 2)
                spriteThree.position = pointFor(col: corner2D.col, row: corner2D.row, num: 3)
                spriteThree.zPosition = 0.2
                
                updateBarPosionAndSize(corner: &cornerThree)
                let spriteBarThree: SKSpriteNode = (cornerThree.bar?.sprite)!
                
                corner2DsLayer.addChild(spriteThree)
                corner2DsLayer.addChild(spriteBarThree)
            }
        }
    }
    // -- Thêm node sprite player vào squaresLayer
    func addPlayerSprite(player: Player)
    {
        let sprite: SKSpriteNode = player.sprite!
        sprite.size = CGSize(width: tileWidth * 0.6, height: tileHeight * 0.6)
        sprite.position = pointFor(col: player.col, row: player.row)
        sprite.zPosition = 0.2
        squaresLayer.addChild(sprite)
    }
    // -- Thêm node sprite destination vào squaresLayer
    func addDestinaionSprite(destination: Destination)
    {
        let sprite: SKSpriteNode = destination.sprite!
        sprite.size = CGSize(width: tileWidth * 0.6, height: tileHeight * 0.6)
        sprite.position = pointFor(col: destination.col, row: destination.row)
        sprite.zPosition = 0.1
        squaresLayer.addChild(sprite)
    }
    // --
    override func update(_ currentTime: TimeInterval)
    {
        if level.player?.col == level.destination?.col && level.player?.row == level.destination?.row
        {
            if playSound
            {
                self.run(matchSound)
            }
            
            if map < 15
            {
                levelFlags[map + 1] = true
                UserDefaults.standard.set(true, forKey: "\(map + 1)")
                let scene: GameScene = GameScene(size: size, levelFlags: levelFlags, playSound: playSound, map: map + 1)
                self.view?.presentScene(scene)
            }
            else
            {
                let scene: GameWonScene = GameWonScene(size: size, levelFlags: levelFlags, playSound: playSound)
                self.view?.presentScene(scene)
            }
        }
    }
}
