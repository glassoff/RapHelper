import Foundation

class RhymeFinder {

    // TODO: add same
    
    static func find(_ word: String) -> [Word] {
        let dbQueue = (UIApplication.shared.delegate as! AppDelegate).dbQueue

        var words = [Word]()

        var result: FMResultSet?
        dbQueue?.inDatabase({ (db) in
            result = try! db!.executeQuery("SELECT * FROM words where suffix = \"\(word)\"", values: nil)

            if let result = result {
                while result.next() == true {
                    let word = Word()
                    word.accentText = result.string(forColumn: "word_accent")
                    word.text = result.string(forColumn: "word")
                    word.priority = result.int(forColumn: "priority")
                    words.append(word)
                }

                result.close()
            }

        })
        


        return words
    }
}
