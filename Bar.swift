import SpriteKit

// == Loại của thanh chắn
enum BarType: Int
{
    case VERTICAL = 0, HORIZONTAL
    
    var spriteName: String
    {
        let spriteNames: [String] = ["bar-vertical",
                                     "bar-horizontal"]
        return spriteNames[rawValue]
    }
}
// == Thanh chắn, gắn vào 1 góc corner cố định, xoay theo chiều cho phép của corner mỗi khi player đi ngang
class Bar
{
    // -------------------- Attributes
    var type: BarType // loại
    var sprite: SKSpriteNode? // sprite node hiện trên scene
    // -------------------- Methods
    // -- Khởi tạo thanh chắn, mặc định là nằm dọc
    init(type: BarType = BarType.VERTICAL)
    {
        self.type = type
        sprite = SKSpriteNode(imageNamed: type.spriteName)
    }
}
