//
//  ViewController.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var recognizer: YSKRecognizer?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        YSKSpeechKit.sharedInstance().configure(withAPIKey: "9837dca0-7cc1-42ef-bd85-b2999b21ff60")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recognizeBtnAction(_ sender: AnyObject) {
        recognizer = YSKRecognizer(language: YSKRecognitionLanguageRussian, model: YSKRecognitionModelFreeform)
        recognizer?.delegate = self
        recognizer?.isVADEnabled = true
        
        recognizer?.start()
        
        recordButton.backgroundColor = UIColor.green
    }
    
}

extension ViewController: YSKRecognizerDelegate {
    
    func recognizerDidStartRecording(_ recognizer: YSKRecognizer!) {
        
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didFailWithError error: Error!) {
        print("ERROR!")
        
        recordButton.backgroundColor = UIColor.clear
    }
    
    func recognizerDidDetectSpeech(_ recognizer: YSKRecognizer!) {
        
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        recordButton.backgroundColor = UIColor.clear
        
        guard results.hypotheses.count > 0 else {
            return
        }
        
        let bestHypothesis = results.hypotheses.first as! YSKRecognitionHypothesis
        let ysWords: [YSKRecognitionWord] = bestHypothesis.words as! [YSKRecognitionWord]
        
        var words = [String]()
        
        for word in ysWords {
            words.append(word.text)
        }
        
        let accentedPhrase = Accenter.setAccents(inPhrase: words)

        let wholeText = accentedPhrase.map({$0.accentText!}).joined(separator: " ")
        textView.text = words.joined(separator: " ")

        let rhythmTuple = RhythmGenerator.rhythm(with: wholeText)
        let rhythm = rhythmTuple.1
        let syllables = rhythmTuple.0

        let ending = RhythmGenerator.ending(with: wholeText)

        let bestRhymes = RhymeFinder.find(ending).filter({RelevanceLogic.isRelevant($0.accentText!, forRhythm: rhythm, lastIndex: syllables.count - 1)}).filter({PhraseBuilder.findPreviousWords(forWord: $0.text!).count > 0})


        var textGenerated = false
        var appemptsCount = 0
        let maxAppemptsCount = 20
        var newWords: [Word] = []

        while !textGenerated && appemptsCount < maxAppemptsCount {
            let bestRhyme = BeautyLogic.findBestWord(for: wholeText, from: bestRhymes)  // TODO: different generate
            var syllablesToFill = syllables.count - RhythmGenerator.syllables(bestRhyme.accentText!).count
            newWords = [bestRhyme]
            if syllablesToFill == 0 {
                textGenerated = true
            } else {
                var lastWord = bestRhyme
                while syllablesToFill > 0 {
                    var previousWords = PhraseBuilder.findPreviousWords(forWord: lastWord.text!).filter({(RhythmGenerator.syllables($0.accentText!).count <= syllablesToFill) && RelevanceLogic.isRelevant($0.accentText!, forRhythm: rhythm, lastIndex: syllablesToFill - 1)})
                    if previousWords.count == 0 {
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
    }
}
