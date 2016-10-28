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

        textView.text = words.joined(separator: " ")

        let wholeText = accentedPhrase.map({$0.accentText!}).joined(separator: " ")

        textView.text.append("\n")
        textView.text.append(FinalGenerator.generateFinalString(for: wholeText))
    }
}
