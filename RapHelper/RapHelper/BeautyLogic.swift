import UIKit

class BeautyLogic: NSObject {

    static let frequencies = ["о" : 0.928,
                              "а" : 0.866,
                              "е" : 0.810,
                              "и" : 0.745,
                              "н" : 0.635,
                              "т" : 0.630,
                              "р" : 0.553,
                              "с" : 0.545,
                              "л" : 0.432,
                              "в" : 0.419,
                              "к" : 0.347,
                              "п" : 0.335,
                              "м" : 0.329,
                              "у" : 0.290,
                              "д" : 0.256,
                              "я" : 0.222,
                              "ы" : 0.211,
                              "з" : 0.181,
                              "б" : 0.151,
                              "г" : 0.141,
                              "й" : 0.131,
                              "ч" : 0.127,
                              "ю" : 0.103,
                              "х" : 0.092,
                              "ж" : 0.078,
                              "ш" : 0.077,
                              "ц" : 0.052,
                              "щ" : 0.049,
                              "ф" : 0.040,
                              "э" : 0.017]

    static let vowelsStr = "а, о, э, и, у, ы, е, ё, ю, я"
    static let vowels = vowelsStr.components(separatedBy: ", ")

    static func findBestSoundWord(for phrase: String, from strings: [Word], lastIndex: Int) -> Word {
        let stringsMatchTuples = strings.map({($0, LowelMatchLogic.lowelMatchPercent($0.text, forFullWord: phrase, lastIndex: lastIndex))}).sorted(by: {$0.1 > $1.1})

        if Int(arc4random_uniform(3)) != 0 {
            return stringsMatchTuples.first!.0
        }

        let phraseLetterKeys = frequencies.keys

        var phraseLetterFrequencies: [String : Double] = [:]
        for key in phraseLetterKeys {
            phraseLetterFrequencies[key] = 0
        }

        var totalCharacters = 0
        for character in phrase.characters.map({String($0)}) {
            if let value = phraseLetterFrequencies[character] {
                phraseLetterFrequencies[character] = value + 1
                totalCharacters += 1
            }
        }

        for key in phraseLetterFrequencies.keys {
            phraseLetterFrequencies[key] = phraseLetterFrequencies[key]! / frequencies[key]!
        }

        let stringsTuples = strings.map { string -> (Word, Double) in
            var totalWeight: Double = 0
            for character in string.text!.characters.map({String($0)}) {
                if let value = phraseLetterFrequencies[character] {
                    totalWeight += value
                }
            }

            return (string, totalWeight)
            }.sorted(by: {$0.1 > $1.1})

        return stringsTuples.first?.0 ?? Word()
    }
}
