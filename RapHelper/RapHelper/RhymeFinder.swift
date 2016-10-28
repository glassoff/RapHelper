import Foundation

class RhymeFinder {
    
    static func find(_ word: String, db: FMDatabase) -> String {
        let rs = try! db.executeQuery("SELECT * FROM words where suffix = \"\(word)\"", values: nil)
        var rhymes: [String] = []
        while rs.next() {
            if let x = rs.string(forColumn: "word") {
                rhymes.append(x)
            }
        }

        let bestRhyme = BeautyLogic.findBestWord(for: word, from: rhymes)

        return word
    }
    
}
