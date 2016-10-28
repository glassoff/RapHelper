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
        let words: [YSKRecognitionWord] = bestHypothesis.words as! [YSKRecognitionWord]
        
        var str = ""
        
        for word in words {
            str += word.text + " "
        }
        
        textView.text = str
    }
    
}

