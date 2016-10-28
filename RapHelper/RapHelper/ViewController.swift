//
//  ViewController.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

let normalButtonColor = UIColor.green
let activeButtonColor = UIColor.purple

let normalButtonText = "Нажми"
let activeButtonText = "Зачитай"

class ViewController: UIViewController {
    
    var recognizer: YSKRecognizer?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        YSKSpeechKit.sharedInstance().configure(withAPIKey: "9837dca0-7cc1-42ef-bd85-b2999b21ff60")
        
        recordButton.backgroundColor = normalButtonColor
        recordButton.setTitle(normalButtonText, for: .normal)
        recordButton.setTitle(activeButtonText, for: .selected)
        recordButton.setTitle(activeButtonText, for: .highlighted)
        
        recordButton.layer.cornerRadius = 50.0
        recordButton.layer.masksToBounds = true
        recordButton.layer.borderWidth = 1
        recordButton.layer.borderColor = UIColor.gray.cgColor
    }

    @IBAction func recognizeButtonTouchStart(_ sender: AnyObject) {
        recognizer = YSKRecognizer(language: YSKRecognitionLanguageRussian, model: YSKRecognitionModelFreeform)
        recognizer?.delegate = self
        recognizer?.isVADEnabled = false
        
        recognizer?.start()
        
        recordButton.backgroundColor = activeButtonColor
    }

    @IBAction func recognizeBtnAction(_ sender: AnyObject) {
        recordButton.isHighlighted = true
        recognizer?.finishRecording()
    }
    
}

extension ViewController: YSKRecognizerDelegate {
    
    func recognizerDidStartRecording(_ recognizer: YSKRecognizer!) {
        
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didFailWithError error: Error!) {
        print("ERROR!")
        
        recordButton.backgroundColor = normalButtonColor
    }
    
    func recognizerDidDetectSpeech(_ recognizer: YSKRecognizer!) {
        
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        recordButton.backgroundColor = normalButtonColor
        recordButton.isHighlighted = false
        
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

        textView.text = words.joined(separator: " ")

        DispatchQueue.global().async {
            let wholeText = accentedPhrase.map({$0.accentText!}).joined(separator: " ")
            let finalString =  FinalGenerator.generateFinalString(for: wholeText)
            
            DispatchQueue.main.async {
                self.textView.text.append("\n")
                self.textView.text.append(finalString)
            }
        }
        
    }
}
