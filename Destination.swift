import SpriteKit

// == Vị trí đích mà player muốn đến trong mỗi level, kích cỡ phải nhỏ hơn 1 square
class Destination
{
    // -------------------- Attributes
    var col: Int // thuộc cột col trong squaresLayer
    var row: Int // thuộc dòng row trong squaresLayer
    var sprite: SKSpriteNode? // sprite node hiện trên scene
    // -------------------- Methods
    // -- Khởi tạo 1 đích đến tại vị trí (col, row)
    init(col: Int, row: Int)
    {
        self.col = col
        self.row = row
        sprite = SKSpriteNode(imageNamed: "destination")
    }
}
