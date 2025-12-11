
import Foundation

class FastMathStatsManager: ObservableObject {
    static let shared = FastMathStatsManager()
    
    @Published var records: [FMRecord] = []
    
    private let key = "FastMathScores"
    
    init() {
        loadScores()
    }
    
    func loadScores() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([FMRecord].self, from: data) {
            records = decoded.sorted { $0.score > $1.score }
        }
    }
    
    func addScore(_ score: Int) {
        if records.contains(where: { $0.score == score }) { return }
        
        let newRecord = FMRecord(score: score, date: Date())
        
        var updated = records
        updated.append(newRecord)
        updated.sort { $0.score > $1.score }
        
        records = updated
        
        if let encode = try? JSONEncoder().encode(updated) {
            UserDefaults.standard.set(encode, forKey: key)
        }
    }
}
