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

let normalButtonColor = UIColor.brown
let activeButtonColor = UIColor.purple

let normalButtonText = "Нажми"
let activeButtonText = "Зачитай"

class ViewController: UIViewController {

    static let vowelsStr = "а, о, э, и, у, ы, е, ё, ю, я"
    static let vowels = vowelsStr.components(separatedBy: ", ")

    static let consonantStr = "б, в, г, д, ж, з, й, к, л, м, н, п, р, с, т, ф, х, ц, ч, ш, щ, ь, ъ"
    static let consonants = consonantStr.components(separatedBy: ", ")

    var recognizer: YSKRecognizer?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underTextView: UIView!
    
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
        
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(eventEditingChanged), for: .editingChanged)
        
        textView.textColor = UIColor.white
        
        underTextView.layer.cornerRadius = 10
        underTextView.clipsToBounds = true
        
        textView.backgroundColor = UIColor.clear //UIColor.gray.withAlphaComponent(0.2)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = textView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        underTextView.addSubview(blurEffectView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func recognize(phrase words: [String]) {
        let normalizedWords = words.map{ $0.lowercased().characters.map({String($0)}).filter({ViewController.vowels.contains($0) || ViewController.consonants.contains($0)}).joined() }
        let accentedPhrase = Accenter.setAccents(inPhrase: normalizedWords)
        
        textView.text = normalizedWords.joined(separator: " ")
        textView.text.append("\n ...")
        
        DispatchQueue.global().async {
            let wholeText = accentedPhrase.map({$0.accentText!}).joined(separator: " ")
            let finalString =  FinalGenerator.generateFinalString(for: wholeText)
            
            DispatchQueue.main.async {
                self.textView.text.append("\n")
                self.textView.text.append(finalString)
            }
        }
    }
    
    func recognizeFromTextField() {
        let string = textField.text!
        
        textView.text = string
        
        let words = string.components(separatedBy: " ")
        recognize(phrase: words)
    }
    
    @objc
    public func eventEditingChanged(sender: UITextField) {
        let range = textField.text?.range(of: "\u{FFFC}")
        if range != nil {
            recognizeFromTextField()
        }
    }
    
    @objc
    public func keyboardDidShow(n: NSNotification) {
        let rectValue = n.userInfo?["UIKeyboardBoundsUserInfoKey"] as! NSValue
        let rect = rectValue.cgRectValue
        
        textFieldBottomConstraint.constant = rect.size.height + 5
    }
    
    @objc
    public func keyboardDidHide(n: NSNotification) {
        textFieldBottomConstraint.constant = 20
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
        
        recognize(phrase: words)
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        recognizeFromTextField()
        textField.text = ""
    }
    
}
