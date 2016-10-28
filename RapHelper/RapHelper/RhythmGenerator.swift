import UIKit

class RhythmGenerator: NSObject {

    static let vowelsStr = "а, о, э, и, у, ы, е, ё, ю, я"
    static let vowels = vowelsStr.components(separatedBy: ", ")

    static let consonantStr = "б, в, г, д, ж, з, й, к, л, м, н, п, р, с, т, ф, х, ц, ч, ш, щ, ь, ъ"
    static let consonants = consonantStr.components(separatedBy: ", ")

    static let accent = "'".characters.first!
    static let yo = "ё".characters.first!

    static func rhythm(with string: String) -> ([Bool], String) {


        let words = string.lowercased().components(separatedBy: CharacterSet.whitespacesAndNewlines)

        var syllables: [Bool?] = []

        for word in words {
            let wordSyllables = RhythmGenerator.syllables(word)
            syllables.append(contentsOf: wordSyllables)
        }

        let rhythmes = ["0001", "0010", "0100", "1000", "100", "010", "001", "01", "10"]

        var goodRhythmes: [String] = []

        for rhythm in rhythmes {
            if rhythmIsGood(syllables, rhythm: rhythm) {
                goodRhythmes.append(rhythm)
            }
        }


        if goodRhythmes.contains("0100") && goodRhythmes.contains("0001") && goodRhythmes.contains("01") {
            goodRhythmes = ["01"]
        }

        if goodRhythmes.contains("1000") && goodRhythmes.contains("0010") && goodRhythmes.contains("10") {
            goodRhythmes = ["10"]
        }

        print(goodRhythmes)

        let rhymeToReturnCharacters = (goodRhythmes.first ?? rhythmes.last!).characters.map{String($0)}

        var boolRhymeToReturn: [Bool] = []

        for i in 0..<syllables.count {
            let rhymeChar = rhymeToReturnCharacters[i % rhymeToReturnCharacters.count]
            if rhymeChar == "0" {
                boolRhymeToReturn.append(false)
            } else {
                boolRhymeToReturn.append(true)
            }
        }

        return (boolRhymeToReturn, goodRhythmes.first ?? rhythmes.last!)
    }

    static func rhythmIsGood(_ syllables: [Bool?], rhythm rhythm_: String, startIndex: Int = 0, wholeText: Bool = true) -> Bool {
        var rhythm = rhythm_
        for _ in 0..<startIndex {
            rhythm.append(rhythm.characters.first!)
            rhythm.characters.removeFirst()
        }

        let rhythmToTestCharacters = rhythm.characters.map{String($0)}

        if wholeText && syllables.count/rhythmToTestCharacters.count < 2 {
            return false
        }

        var rhythmToTestIsGood = true

        for (index, syllable) in syllables.enumerated() {
            if let syllable = syllable {
                let testCharacter = rhythmToTestCharacters[index % rhythmToTestCharacters.count]
                if testCharacter == "1" && !syllable {
                    rhythmToTestIsGood = false
                    break
                }
            }
        }

        return rhythmToTestIsGood
    }

    static func syllables(_ word: String) -> [Bool?] {

        let onlyVowels = word.lowercased().characters.filter{vowels.contains(String($0)) || $0 == "'"}

        var syllables: [Bool?] = []

        if onlyVowels.count == 1 {
            syllables.append(nil)
            return syllables
        }

        if onlyVowels.index(of: accent) == nil && onlyVowels.index(of: yo) == nil {
            for _ in onlyVowels {
                syllables.append(nil)
            }
            return syllables
        }

        for vowel in onlyVowels {
            if vowel == "ё" {
                syllables.append(true)
            } else if vowel == accent {
                syllables.removeLast()
                syllables.append(true)
            } else {
                syllables.append(false)
            }
        }

        return syllables
    }

    static func ending(with fullText: String) -> String {
        let rhyme = rhythm(with: fullText).0

        let lastOneInvertedIndex: Int = rhyme.reversed().index(of: true)!

        let vowelIndexToStart = (rhyme.count - lastOneInvertedIndex) - 1
        var result: String = ""

        var currentVowelIndex = -1

        for character in fullText.characters.map({String($0)}) {
            if vowels.contains(character) {
                currentVowelIndex += 1
            }
            if currentVowelIndex >= vowelIndexToStart {
                if vowels.contains(character) || consonants.contains(character) {
                    result.append(character.characters.first!)
                }
            }
        }
        
        return result
    }
}
