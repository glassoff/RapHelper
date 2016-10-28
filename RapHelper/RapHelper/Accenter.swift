//
//  Accenter.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import Foundation

class Accenter {
    
    class func setAccents(inPhrase phraseWords: [String]) -> [String] {
        print(phraseWords)
        
        let db = (UIApplication.shared.delegate as! AppDelegate).db
        
        let wordsParams = "'" + phraseWords.joined(separator: "', '") + "'"
        
        let result = try! db?.executeQuery("SELECT word, word_accent FROM words WHERE word IN (\(wordsParams))", values: nil)
        
        var resultWords = [String: String]()
        
        while result?.next() == true {
            let word = result?.string(forColumn: "word")
            let wordAccent = result?.string(forColumn: "word_accent")
            
            resultWords[word!] = wordAccent
        }
        
        result?.close()
        
        var resultPhraseWords = [String]()
        
        for initialWord in phraseWords {
            if resultWords[initialWord] != nil {
                resultPhraseWords.append(resultWords[initialWord]!)
            } else {
                resultPhraseWords.append(initialWord)
            }
        }
        
        print(resultPhraseWords)
        
        return resultPhraseWords
    }
    
}
