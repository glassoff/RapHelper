import UIKit

class LowelMatchLogic: NSObject {
    static let vowelsStr = "а, о, э, и, у, ы, е, ё, ю, я"
    static let vowels = vowelsStr.components(separatedBy: ", ")

    static func lowelMatchPercent(_ word: String, forFullWord fullWord: String, lastIndex:Int) -> Double {
        let fullWordVowels = fullWord.characters.map({String($0)}).filter({vowels.contains($0)})
        let wordVowels = word.characters.map({String($0)}).filter({vowels.contains($0)})
        let startIndex = lastIndex - wordVowels.count + 1

        if startIndex < 0 || wordVowels.count == 0 || fullWordVowels.count == 0{
            return 0
        }

        var totalMatches = 0
        for i in 0..<wordVowels.count {
            if wordVowels.count <= i || fullWordVowels.count <= i+startIndex {
                break
            }
            if wordVowels[i] == fullWordVowels[i+startIndex] {
                totalMatches += 1
            }
        }

        return Double(totalMatches)/Double(wordVowels.count)
    }
}
