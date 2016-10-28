import Foundation

class RhymeFinder {
    
    static func find(_ word: String, db: FMDatabase) -> String {
        let ending = "ением"

        let rs = try! db.executeQuery("SELECT * FROM words where suffix = \"\(word)\"", values: nil)
        while rs.next() {
            if let x = rs.string(forColumn: "word") {
                return x
            }
        }

        return word
    }
    
}
