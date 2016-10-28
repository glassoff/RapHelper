//
//  PhraseBuilder.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import Foundation

class Word {
    var text: String!
    var accentText: String!
    var priority: Int32!
}

class PhraseBuilder {
    
    class func findPreviousWords(forWord word: String) -> [Word] {
        let db = (UIApplication.shared.delegate as! AppDelegate).db

        let sql = "SELECT * FROM words WHERE word_id IN (SELECT related_word_id FROM related_words WHERE word_id = (SELECT word_id FROM words WHERE word = '\(word)') ORDER BY count)"
        
        let result = try! db?.executeQuery(sql, values: nil)
        
        var words = [Word]()
        
        while result?.next() == true {
            let word = Word()
            word.accentText = result?.string(forColumn: "word_accent")
            word.text = result?.string(forColumn: "word")
            word.priority = result?.int(forColumn: "priority")
            words.append(word)
        }
        
        result?.close()

        return words
    }

    class func canBeInTheBeginning(_ word: String) -> Bool {
        let previousWords = findPreviousWords(forWord: word)
        let result = previousWords.map({$0.text!}).contains("*new_sentence*")

        return result
    }
}