import SpriteKit

// == Các loại ô vuông
enum SquareType: Int
{
    case LEFT = 0, RIGHT, TOP, BOTTOM, UP_LEFT, UP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT, LEFT_RIGHT, TOP_BOTTOM, TOP_LEFT_BOTTOM, RIGHT_TOP_LEFT, BOTTOM_RIGHT_TOP, LEFT_BOTTOM_RIGHT, NONE
    
    var spriteName: String
    {
        let spriteNames: [String] = ["square-left",
                                     "square-right",
                                     "square-top",
                                     "square-bottom",
                                     "square-top-left",
                                     "square-top-right",
                                     "square-bottom-left",
                                     "square-bottom-right",
                                     "square-left-right",
                                     "square-top-bottom",
                                     "square-top-left-bottom",
                                     "square-right-top-left",
                                     "square-bottom-right-top",
                                     "square-left-bottom-right",
                                     "square-none"]
        return spriteNames[rawValue]
    }
}
// == 1 ô vuông trong map
class Square : Hashable
{
    // -------------------- Attributes
    var col: Int // thuộc cột col trong squaresLayer
    var row: Int // thuộc dòng row trong squaresLayer
    var type: SquareType // loại
    var sprite: SKSpriteNode? // sprite node hiện trên scene
    // -------------------- Methods
    // -- Khởi tạo 1 ô vuông, mặc định không viền
    init(col: Int, row: Int, type: SquareType = SquareType.NONE)
    {
        self.col = col
        self.row = row
        self.type = type
        sprite = SKSpriteNode(imageNamed: type.spriteName)
    }
    // -- Giá trị để hash code
    var hashValue: Int
    {
        return row * 12 + col
    }
    // -- Quá tải toán tử so sánh bằng
    static func ==(lhs: Square, rhs: Square) -> Bool
    {
        return (lhs.col == rhs.col && lhs.row == rhs.row)
    }
}
