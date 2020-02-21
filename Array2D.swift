import Foundation

// == Mảng 2 chiều
struct Array2D<T>
{
    // -------------------- Attributes
    let numCols: Int // số cột
    let numRows: Int// số dòng
    private var arr: [T?]
    // -------------------- Methods
    // -- Khởi tạo mảng 2 chiều với giá trị của mỗi phần tử là nil
    init(numCols: Int, numRows: Int)
    {
        self.numCols = numCols
        self.numRows = numRows
        arr = Array<T?>(repeating: nil, count: numCols * numRows)
    }
    // -- Kiểm tra tính hợp lệ của chỉ số (cột, dòng)
    func isValidIndex(col: Int, row: Int) -> Bool
    {
        return col >= 0 && col < numCols && row >= 0 && row < numRows
    }
    // -- Quá tải toán tử [] để set/get phần tử mảng
    subscript(col: Int, row: Int) -> T?
    {
        set(newValue)
        {
            if isValidIndex(col: col, row: row)
            {
                arr[row * numCols + col] = newValue
            }
        }
        get
        {
            if isValidIndex(col: col, row: row)
            {
                return arr[row * numCols + col]
            }
            return nil
        }
    }
}
