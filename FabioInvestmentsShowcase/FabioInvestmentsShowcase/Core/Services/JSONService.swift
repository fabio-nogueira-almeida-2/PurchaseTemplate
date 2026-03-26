import Foundation

class JSONService {
    static let shared = JSONService()
    
    private init() {}
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            print("❌ JSON file not found: \(filename).json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let result = try decoder.decode(type, from: data)
            print("✅ Successfully loaded JSON: \(filename).json")
            return result
        } catch {
            print("❌ Error loading JSON \(filename).json: \(error)")
            return nil
        }
    }
    
    func loadJSONWithDelay<T: Decodable>(filename: String, type: T.Type, delay: TimeInterval = 1.0, completion: @escaping (Result<T, ApiError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let result = self.loadJSON(filename: filename, type: type) {
                completion(.success(result))
            } else {
                completion(.failure(.decodingError))
            }
        }
    }
}
