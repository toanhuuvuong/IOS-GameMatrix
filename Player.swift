import SpriteKit

// == Hướng di chuyển của người chơi
enum PlayerDirection: Int
{
    case STOP = 0, LEFT, RIGHT, UP, DOWN
    
    var spriteName: String
    {
        return "player"
    }
}
// == Người chơi, kích cỡ phải nhỏ hơn 1 square
class Player
{
    // -------------------- Attributes
    var col: Int // thuộc cột col trong squaresLayer
    var row: Int // thuộc dòng row trong squaresLayer
    var direction: PlayerDirection // hướng di chuyển
    var sprite: SKSpriteNode? // sprite node hiện trên scene
    // -------------------- Methods
    // -- Khởi tạo người chơi, mặc định đang đứng yên
    init(col: Int, row: Int, direction: PlayerDirection = PlayerDirection.STOP)
    {
        self.col = col
        self.row = row
        self.direction = direction
        sprite = SKSpriteNode(imageNamed: direction.spriteName)
    }
}
