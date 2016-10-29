import Foundation

class RhymeFinder {

    // TODO: add same

    static func find(_ word: String) -> [Word] {
        var endingsToTry: [String] = []
        endingsToTry.append(word)
        endingsToTry.append(contentsOf: allEndings(from: word))
        var allWords: [Word] = []
        for ending in endingsToTry {
            allWords.append(contentsOf: tryToFind(ending))
        }
        
        let sortedWords = allWords.sorted(by: { (word1, word2) -> Bool in
            func sortK(word: Word) -> Int32 {
                return word.count + 10000000 * word.priority
            }
            
            return sortK(word: word1) > sortK(word: word2)
        })
        
        if sortedWords.count > 20 {
            return Array(sortedWords[0..<20])
        } else {
            return sortedWords
        }
    }

    private static func allEndings(from ending: String) -> [String] {
        let sames = ["м":"н",
                     "н":"м",
                     "ж":"ш",
                     "ш":"ж",
                     "б":"п",
                     "п":"б",
                     "к":"г",
                     "г":"к",
                     "д":"т",
                     "т":"д",
                     "з":"с",
                     "с":"з",
                     "в":"ф",
                     "ф":"в"]

        let samesLast = ["е":"и",
                         "и":"е"]

        let charArray = ending.characters.map({String($0)})

        var result: [String] = []
        for _ in 0..<5 {
            var sampleChars: String = ""
            for (index, character) in charArray.enumerated() {
                if let sameChar = sames[character], Int(arc4random_uniform(3)) != 0 {
                    sampleChars.append(sameChar)
                } else if let sameChar = samesLast[character], index == charArray.count - 1, Int(arc4random_uniform(4)) != 0 {
                    sampleChars.append(sameChar)
                } else {
                    sampleChars.append(character)
                }
            }

            result.append(sampleChars)
        }

        return Array(Set(result))
    }

    private static func tryToFind(_ word: String) -> [Word] {
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
                    word.count = result.int(forColumn: "count")
                    words.append(word)
                }

                result.close()
            }

        })

        return words
    }
}
