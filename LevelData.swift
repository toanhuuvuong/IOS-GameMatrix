import Foundation

// == Lớp chứa dữ liệu của màn chơi load từ file .JSON
class LevelData : Codable
{
    // -------------------- Attributes
    var squares: [[Int]] // map các ô vuông
    var corner2Ds: [[[Int]]] // map các corner2D
    var playerPos: [Int] // vị trí khởi tạo của player
    var destinationPos: [Int] // vị trí khởi tạo của đích đến
    // -------------------- Methods
    // -- Load map từ file .JSON
    static func loadFrom(fileNamed: String) -> LevelData?
    {
        var data: Data?
        var levelData: LevelData?
        
        if let url: URL = Bundle.main.url(forResource: fileNamed, withExtension: "json")
        {
            do
            {
                data = try Data(contentsOf: url)
            }
            catch
            {
                print("Counldn't load data from \(fileNamed), error: \(error)")
                return nil
            }
            do
            {
                let decoder: JSONDecoder = JSONDecoder()
                levelData = try decoder.decode(LevelData.self, from: data!)
            }
            catch
            {
                print("Couldn't decode data from \(fileNamed), error: \(error)")
                return nil
            }
        }
        
        return levelData
    }
}
