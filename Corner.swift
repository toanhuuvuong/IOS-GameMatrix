import SpriteKit

// == Loại góc
enum CornerType: Int
{
    case ZERO = 0, ONE, TWO, THREE
    
    var spriteName: String
    {
        let spriteNames: [String] = ["corner-zero",
                                     "corner-one",
                                     "corner-two",
                                     "corner-three"]
        return spriteNames[rawValue]
    }
}
// == 1 góc, làm đế cho thanh chắn bar đặt vào, làm góc chỉ hướng xoay cho thanh chắn bar
class Corner
{
    // -------------------- Attributes
    var type: CornerType // loại
    var sprite: SKSpriteNode? // sprite node hiện trên scene
    var bar: Bar? // 1 thanh chắn
    // -------------------- Methods
    // -- Khởi tạo 1 cặp (corner - bar), mặc định là (góc 0 - thanh chắn đứng)
    init(type: CornerType = CornerType.ZERO, barType: BarType = BarType.VERTICAL)
    {
        self.type = type
        sprite = SKSpriteNode(imageNamed: type.spriteName)
        bar = Bar(type: barType)
    }
}
