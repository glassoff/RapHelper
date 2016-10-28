#!/usr/local/bin/python3

import sqlite3
import sys
import re
import appdb
import codecs

clear_pattern = re.compile('[\W]+')

class WordInfo:
    def __init__(self):
        self.related = {}
        self.count = 0

def clear_word(word):
   return clear_pattern.sub('', word).lower()

def inc_by_key(key, dic):
    if not (key in dic):
        dic[key] = 0
    dic[key] += 1

def process_line(line, result):
    words = line.split()
    for index in range(1, len(words) - 1):
        word = clear_word(words[index])
        prev_word = words[index - 1]
        if not (word in result):
            result[word] = WordInfo()
        word_info = result[word]
        word_info.count += 1
        
        clear_prev_word = clear_word(prev_word)
        inc_by_key(clear_prev_word, word_info.related)

def parse_file(fname):
    result = {}
    with codecs.open(fname, 'r', 'cp1251') as f:
        for line in f:
            process_line(line, result)
    return result

def get_word_id(db, word):
    cur = db.execute('SELECT word_id from words where word = ?', (word, ))
    res = cur.fetchone()
    if res is None:
        return None
    return res[0]

def save_result_to_db(result):
    db = appdb.connect()
    db.execute('BEGIN TRANSACTION')
    for word in result:
        for related_word in result[word].related:

            word_id = get_word_id(db, word)
            related_word_id = get_word_id(db, related_word)

            if (word_id is None) or (related_word_id is None):
                continue

            params = {'word_id': word_id, 
                      'related_word_id': related_word_id,
                      'count': result[word].related[related_word]}

            db.execute('INSERT OR IGNORE INTO related_words (word_id, related_word_id, count) VALUES (:word_id, :related_word_id, 0)', params)
            db.execute('UPDATE related_words SET count = count + :count WHERE word_id = :word_id AND related_word_id = :related_word_id', params)

            params = {'word_id': word_id,
                       'count': result[word].count}
            db.execute('UPDATE words SET count = count + :count where word_id = :word_id', params)

    db.execute('COMMIT')
    db.close()

def main():
    fname = sys.argv[1]    
    result = parse_file(fname)
    save_result_to_db(result)


if __name__ == '__main__':
    main()

