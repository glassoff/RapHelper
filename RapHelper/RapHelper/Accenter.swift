//
//  Accenter.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import Foundation

class Accenter {
    
    class func setAccents(inPhrase phraseWords: [String]) -> [Word] {
        print(phraseWords)
        
        let db = (UIApplication.shared.delegate as! AppDelegate).db
        
        let wordsParams = "'" + phraseWords.joined(separator: "', '") + "'"
        
        let result = try! db?.executeQuery("SELECT word, word_accent FROM words WHERE word IN (\(wordsParams))", values: nil)
        
        var resultWords = [String: Word]()

        while result?.next() == true {
            let word = Word()
            word.accentText = result?.string(forColumn: "word_accent")
            word.text = result?.string(forColumn: "word")
            word.priority = result?.int(forColumn: "priority")
            resultWords[word.text!] = word
        }
        
        result?.close()
        
        var resultPhraseWords = [Word]()
        
        for initialWord in phraseWords {
            if resultWords[initialWord] != nil {
                resultPhraseWords.append(resultWords[initialWord]!)
            } else {
                let word = Word()
                word.accentText = initialWord
                word.text = initialWord
                word.priority = 0

                resultPhraseWords.append(word)
            }
        }

        return resultPhraseWords
    }
    
}
