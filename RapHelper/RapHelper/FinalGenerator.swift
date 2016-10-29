import UIKit

class FinalGenerator: NSObject {

    static func generateFinalString(for wholeText: String, canTryNonInsureSyllable: Bool = true) -> String {
        let rhythmTuple = RhythmGenerator.rhythm(with: wholeText)
        let rhythm = rhythmTuple.1
        let syllables = rhythmTuple.0

        let ending = RhythmGenerator.ending(with: wholeText)

        let lastRawWord = wholeText.components(separatedBy: " ").filter({$0 != "."}).last?.replacingOccurrences(of: "'", with: "")

        var bestRhymes = Array(RhymeFinder.find(ending.0).filter({(lastRawWord != $0.text) && RelevanceLogic.isRelevant($0.accentText!, forRhythm: rhythm, lastIndex: syllables.count - 1)}).filter({PhraseBuilder.findPreviousWords(forWord: $0.text!).count > 0}))

        var canReduceEnding = ending.1

        if bestRhymes.count == 0 && canReduceEnding {
            canReduceEnding = false
            var newChars = ending.0.characters
            newChars.removeFirst()
            let newEnding = String(newChars)

            bestRhymes = Array(RhymeFinder.find(newEnding).filter({(lastRawWord != $0.text) && RelevanceLogic.isRelevant($0.accentText!, forRhythm: rhythm, lastIndex: syllables.count - 1)}).filter({PhraseBuilder.findPreviousWords(forWord: $0.text!).count > 0}))

        }

        var textGenerated = false
        var appemptsCount = 0
        let maxAppemptsCount = 20
        var newWords: [Word] = []

        while !textGenerated && appemptsCount < maxAppemptsCount {
            let bestRhyme = BeautyLogic.findBestWord(for: wholeText, from: bestRhymes)  // TODO: different generate
            guard bestRhyme.accentText != nil else {
                break
            }
            var syllablesToFill = syllables.count - RhythmGenerator.syllables(bestRhyme.accentText!).count
            newWords = [bestRhyme]
            if syllablesToFill == 0 {
                textGenerated = true
            } else {
                var lastWord = bestRhyme
                while syllablesToFill > 0 {
                    var previousWords = PhraseBuilder.findPreviousWords(forWord: lastWord.text!).filter({
                        !(canTryNonInsureSyllable && (RhythmGenerator.syllableInsurance($0.accentText) <= 0)
                        && RhythmGenerator.syllables($0.accentText!).count <= syllablesToFill)
                        && RelevanceLogic.isRelevant($0.accentText!, forRhythm: rhythm, lastIndex: syllablesToFill - 1)
                        && PhraseBuilder.findPreviousWords(forWord: $0.text!).count > 0})
                    if previousWords.count == 0 {
                        bestRhymes = bestRhymes.filter({$0 != bestRhyme})

                        if bestRhymes.count == 0 && canReduceEnding {
                            canReduceEnding = false
                            var newChars = ending.0.characters
                            newChars.removeFirst()
                            let newEnding = String(newChars)

                            bestRhymes = Array(RhymeFinder.find(newEnding).filter({(lastRawWord != $0.text) && RelevanceLogic.isRelevant($0.accentText!, forRhythm: rhythm, lastIndex: syllables.count - 1)}).filter({PhraseBuilder.findPreviousWords(forWord: $0.text!).count > 0}))

                        }
                        break
                    }
                    let goodBeginningWords = previousWords.filter({(RhythmGenerator.syllables($0.accentText!).count == syllablesToFill) && PhraseBuilder.canBeInTheBeginning($0.text!)})
                    if goodBeginningWords.count > 0 {
                        previousWords = goodBeginningWords
                    }
                    // TODO: insert here word frequency!
                    let bestWord = BeautyLogic.findBestWord(for: wholeText, from: previousWords)
                    lastWord = bestWord
                    newWords.insert(bestWord, at: 0)
                    syllablesToFill -= RhythmGenerator.syllables(bestWord.accentText!).count
                }

                if syllablesToFill == 0 {
                    textGenerated = true
                    break
                }
            }
            appemptsCount += 1
        }

        return textGenerated ? newWords.map({$0.text}).joined(separator: " ") : canTryNonInsureSyllable ? generateFinalString(for: wholeText, canTryNonInsureSyllable: false) : "не получилось зачитать, сорь"
    }
}
