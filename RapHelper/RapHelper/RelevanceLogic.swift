import UIKit

class RelevanceLogic: NSObject {

    static let vowelsStr = "а, о, э, и, у, ы, е, ё, ю, я"
    static let vowels = vowelsStr.components(separatedBy: ", ")

    static func isRelevant(_ word: String, forRhythm rhythm: String, lastIndex:Int) -> Bool {
        let syllables = RhythmGenerator.syllables(word)
        let startIndex = lastIndex - syllables.count + 1

        if startIndex < 0 {
            return false
        }

        return RhythmGenerator.rhythmIsGood(syllables, rhythm: rhythm, startIndex: startIndex, wholeText: false).0
    }
}
