import Foundation

class RhymeFinder {
    
    static func find(_ word: String, db: FMDatabase) -> String {
        let ending = "ением"

        let rs = try! db.executeQuery("SELECT * FROM words where suffix = \"\(word)\"", values: nil)
        while rs.next() {
            let x = rs.string(forColumn: "x")
            let y = rs.string(forColumn: "y")
            let z = rs.string(forColumn: "z")
            print("x = \(x); y = \(y); z = \(z)")
        }

        return word
    }
    
}
