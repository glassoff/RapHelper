//
//  PhraseBuilder.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import Foundation

class PhraseBuilder {
    
    class func findPreviousWords(forWord word: String) -> [String] {
        let db = (UIApplication.shared.delegate as! AppDelegate).db
        
        let sql = "SELECT * FROM words WHERE word_id IN (SELECT related_word_id FROM related_words WHERE word_id = (SELECT word_id FROM words WHERE word = '\(word)') ORDER BY count)"
        
        let result = try! db?.executeQuery(sql, values: nil)
        
        var words = [String]()
        
        while result?.next() == true {
            let word = result?.string(forColumn: "word")
            words.append(word!)
        }
        
        result?.close()
        
        print(words)
        
        return words
    }
    
}
