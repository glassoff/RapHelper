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
        
        let dbQueue = (UIApplication.shared.delegate as! AppDelegate).dbQueue
        
        let wordsParams = "'" + phraseWords.joined(separator: "', '") + "'"
        
        var result: FMResultSet?

        var resultWords = [String: Word]()

        dbQueue?.inDatabase({ (db) in
            result = try! db?.executeQuery("SELECT * FROM words WHERE word IN (\(wordsParams))", values: nil)

            while result?.next() == true {
                let word = Word()
                word.accentText = result?.string(forColumn: "word_accent")
                word.text = result?.string(forColumn: "word")
                word.priority = result?.int(forColumn: "priority")
                word.count = result?.int(forColumn: "count")
                resultWords[word.text!] = word
            }

            result?.close()
        })

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
