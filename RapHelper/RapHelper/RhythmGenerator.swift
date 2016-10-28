import UIKit

class RhythmGenerator: NSObject {

    static let vowelsStr = "а, о, э, и, у, ы, е, ё, ю, я"
    static let vowels = vowelsStr.components(separatedBy: ", ")

    static let consonantStr = "б, в, г, д, ж, з, й, к, л, м, н, п, р, с, т, ф, х, ц, ч, ш, щ"
    static let consonants = consonantStr.components(separatedBy: ", ")

    static let accent = "'".characters.first!
    static let yo = "ё".characters.first!

    static func rhythm(with string: String) -> [Bool] {


        let words = string.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        var syllables: [Bool?] = []

        for word in words {
            let onlyVowels = word.characters.filter{vowels.contains(String($0)) || $0 == "'"}

            if onlyVowels.count == 1 {
                syllables.append(nil)
                continue
            }

            if onlyVowels.index(of: accent) == nil && onlyVowels.index(of: yo) == nil {
                for _ in onlyVowels {
                    syllables.append(nil)
                }
                continue
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
        }

        let rhythmes = ["0001", "0010", "0100", "1000", "100", "010", "001", "01", "10"]

        var goodRhythmes: [String] = []

        for rhymeToTest in rhythmes {
            let rhymeToTestCharacters = rhymeToTest.characters.map{String($0)}

            if syllables.count/rhymeToTestCharacters.count < 2 {
                continue
            }

            var rhymeToTestIsGood = true

            for (index, syllable) in syllables.enumerated() {
                if let syllable = syllable {
                    let testCharacter = rhymeToTestCharacters[index % rhymeToTestCharacters.count]
                    if testCharacter == "1" && !syllable {
                        rhymeToTestIsGood = false
                        break
                    }
                }
            }

            if rhymeToTestIsGood {
                goodRhythmes.append(rhymeToTest)
            }
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

        return boolRhymeToReturn
    }

    static func ending(with fullText: String) -> String {
        let rhyme = rhythm(with: fullText)

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
