import SpriteKit

// == Một mảng 2 chiều gồm 4 góc corner thuộc 4 loại khác nhau
class Corner2D : Hashable
{
    // -------------------- Attributes
    var col: Int // thuộc cột col trong corner2DsLayer
    var row: Int // thuộc dòng row trong corner2DsLayer
    var corners: Array2D<Corner> = Array2D<Corner>(numCols: 2, numRows: 2) // mảng 4 góc khác nhau
    // -------------------- Methods
    // -- Khởi tạo 1 mảng 2 chiều gồm 4 corner có giá trị nil
    init(col: Int, row: Int)
    {
        self.col = col
        self.row = row
    }
    // -- Giá trị để hash code
    var hashValue: Int
    {
        return row * 13 + col
    }
    // -- Quá tải toán tử so sánh bằng
    static func ==(lhs: Corner2D, rhs: Corner2D) -> Bool
    {
        return (lhs.col == rhs.col && lhs.row == rhs.row)
    }
    // -- Lấy giá trị corner
    func cornerAt(num: Int) -> Corner?
    {
        switch num
        {
        case 0:
            return corners[0, 0]
        case 1:
            return corners[0, 1]
        case 2:
            return corners[1, 1]
        case 3:
            return corners[1, 0]
        default:
            return nil
        }
    }
    // -- Lấy giá trị bar
    func barAt(num: Int) -> Bar?
    {
        switch num
        {
        case 0:
            return corners[0, 0]?.bar
        case 1:
            return corners[0, 1]?.bar
        case 2:
            return corners[1, 1]?.bar
        case 3:
            return corners[1, 0]?.bar
        default:
            return nil
        }
    }
}
