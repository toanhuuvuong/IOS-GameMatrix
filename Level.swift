import SpriteKit

let numCols: Int = 11
let numRows: Int = 8

// == Level chứa map
class Level
{
    // -------------------- Attributes
    private var tileSquares: Array2D<Tile> = Array2D<Tile>(numCols: numCols, numRows: numRows) // mảng 2 chiều 11 x 8 cờ ô vuông
    private var squares: Array2D<Square> = Array2D<Square>(numCols: numCols, numRows: numRows) // mảng 2 chiều 11 x 8 ô vuông
    private var tileCorner2Ds: Array2D<Tile> = Array2D<Tile>(numCols: numCols + 1, numRows: numRows + 1) // mảng 2 chiều 12 x 9 cờ corner2D
    private var corner2Ds: Array2D<Corner2D> = Array2D<Corner2D>(numCols: numCols + 1, numRows: numRows + 1) // mảng 2 chiều 12 x 9 của các 4 góc
    
    var player: Player?
    var destination: Destination?
    // -------------------- Methods
    // -- Khởi tạo level được đọc từ file .JSON
    init(fileNamed: String)
    {
        guard let levelData: LevelData = LevelData.loadFrom(fileNamed: fileNamed)
            else
        {
            return
        }
        
        let squareArr: [[Int]] = levelData.squares // mảng 2 chiều cờ square
        for (row, rowArr) in squareArr.enumerated() // row: chỉ số dòng & rowArr: mảng 1 chiều dòng
        {
            let squareRow: Int = numRows - row - 1 // tính lại squareRow (vì góc toạ độ của squaresLayer nằm ở góc trái-dưới, góc toạ độ mảng 2 chiều squareArr  nằm ở góc trái trên)
            
            for (col, value) in rowArr.enumerated() // col: chỉ số cột & value: giá trị tại (cột col, dòng row)
            {
                if value != 0
                {
                    tileSquares[col, squareRow] = Tile() // cờ square != nil
                    switch value
                    {
                    case 1:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.LEFT)
                    case 2:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.RIGHT)
                    case 3:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.TOP)
                    case 4:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.BOTTOM)
                    case 5:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.UP_LEFT)
                    case 6:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.UP_RIGHT)
                    case 7:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.BOTTOM_LEFT)
                    case 8:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.BOTTOM_RIGHT)
                    case 9:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.LEFT_RIGHT)
                    case 10:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.TOP_BOTTOM)
                    case 11:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.TOP_LEFT_BOTTOM)
                    case 12:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.RIGHT_TOP_LEFT)
                    case 13:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.BOTTOM_RIGHT_TOP)
                    case 14:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.LEFT_BOTTOM_RIGHT)
                    case 15:
                        squares[col, squareRow] = Square(col: col, row: squareRow, type: SquareType.NONE)
                    default:
                        break
                    }
                }
            }
            
            let corner2DArr: [[[Int]]] = levelData.corner2Ds // mảng 2 chiều cờ corner2D
            for (row, rowArr) in corner2DArr.enumerated()
            {
                let corner2DRow: Int = numRows - row
                
                for (col, value) in rowArr.enumerated()
                {
                    if value != []
                    {
                        tileCorner2Ds[col, corner2DRow] = Tile()
                        corner2Ds[col, corner2DRow] = Corner2D(col: col, row: corner2DRow)
                        if value[0] != 0
                        {
                            corner2Ds[col, corner2DRow]?.corners[0, 0] = Corner(type: CornerType.ZERO, barType: (value[0] == 1) ? BarType.VERTICAL : BarType.HORIZONTAL)
                        }
                        if value[1] != 0
                        {
                            corner2Ds[col, corner2DRow]?.corners[0, 1] = Corner(type: CornerType.ONE, barType: (value[1] == 1) ? BarType.VERTICAL : BarType.HORIZONTAL)
                        }
                        if value[2] != 0
                        {
                            corner2Ds[col, corner2DRow]?.corners[1, 1] = Corner(type: CornerType.TWO, barType: (value[2] == 1) ? BarType.VERTICAL : BarType.HORIZONTAL)
                        }
                        if value[3] != 0
                        {
                            corner2Ds[col, corner2DRow]?.corners[1, 0] = Corner(type: CornerType.THREE, barType: (value[3] == 1) ? BarType.VERTICAL : BarType.HORIZONTAL)
                        }
                    }
                }
            }
            
            let playerPos: [Int] = levelData.playerPos
            player = Player(col: playerPos[0], row: playerPos[1])
            
            let destinationPos: [Int] = levelData.destinationPos
            destination = Destination(col: destinationPos[0], row: destinationPos[1])
        }
    }
    // -- Cờ square tại vị trí (col, row )
    func tileSquareAt(col: Int, row: Int) -> Tile?
    {
        if col >= 0 && col < numCols && row >= 0 && row < numRows
        {
            return tileSquares[col, row]
        }
        return nil
    }
    // -- Ô vuông tại vị trí (col, row)
    func squareAt(col: Int, row: Int) -> Square?
    {
        if col >= 0 && col < numCols && row >= 0 && row < numRows
        {
            return squares[col, row]
        }
        return nil
    }
    // -- Cờ corner2D tại vị trí (col, row )
    func tileCorner2DAt(col: Int, row: Int) -> Tile?
    {
        if col >= 0 && col <= numCols && row >= 0 && row <= numRows
        {
            return tileCorner2Ds[col, row]
        }
        return nil
    }
    // -- 1 góc 2 chiều tại vị trí (col, row)
    func corner2DAt(col: Int, row: Int) -> Corner2D?
    {
        if col >= 0 && col <= numCols && row >= 0 && row <= numRows
        {
            return corner2Ds[col, row]
        }
        return nil
    }
    // -- 1 góc có số thứ tự num trong 4 góc tại vị trí (col, row)
    func cornerAt(col: Int, row: Int, num: Int) -> Corner?
    {
        if col >= 0 && col <= numCols && row >= 0 && row <= numRows
        {
            return corner2Ds[col, row]?.cornerAt(num: num)
        }
        return nil
    }
    // -- 1 góc có số thứ tự num trong 4 góc tại vị trí (col, row)
    func barAt(col: Int, row: Int, num: Int) -> Bar?
    {
        if col >= 0 && col <= numCols && row >= 0 && row <= numRows
        {
            return corner2Ds[col, row]?.barAt(num: num)
        }
        return nil
    }
    // -- Thiết lập 1 mảng set các ô vuông trong map
    func setSquares() -> Set<Square>
    {
        var set: Set<Square> = []
        
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                if tileSquares[col, row] != nil
                {
                    set.insert(squares[col, row]!)
                }
            }
        }
        
        return set
    }
    // -- Thiết lập 1 mảng set các 4 góc trong map
    func setCorner2Ds() -> Set<Corner2D>
    {
        var set: Set<Corner2D> = []
        
        for row in 0...numRows
        {
            for col in 0...numCols
            {
                if tileCorner2Ds[col, row] != nil
                {
                    set.insert(corner2Ds[col, row]!)
                }
            }
        }
        
        return set
    }
    // -- Thiết lập player
    func setPlayer() -> Player?
    {
        return player
    }
    // -- Thiết lập destination
    func setDestination() -> Destination?
    {
        return destination
    }
}

