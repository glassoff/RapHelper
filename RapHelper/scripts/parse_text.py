#!/usr/local/bin/python3

import sqlite3
import sys
import re
import appdb
import codecs
import os.path


clear_pattern = re.compile('[^\w-]+')
sentence_ends = set(['!', '?', '.', '…'])
SENTENCE_CONST = "*new_sentence*"

MISSING_WORDS_FNAME = 'missing_words.txt'

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

def sentence_start(prev_word):
    for end in sentence_ends:
        if prev_word.endswith(end):
            return True
    return False

def process_word(word, prev_word, result):
    word = clear_word(word)
    if not (word in result):
        result[word] = WordInfo()
    word_info = result[word]
    word_info.count += 1

    if (prev_word is None) or sentence_start(prev_word):
        inc_by_key(SENTENCE_CONST, word_info.related)
    else:
        clear_prev_word = clear_word(prev_word)
        inc_by_key(clear_prev_word, word_info.related)


def process_text(text, result):
    words = text.split()
    if len(words) == 0:
        return

    for index in range(1, len(words) - 1):
        process_word(words[index], words[index - 1], result)

    # proceed first word
    if len(words) > 0:
        process_word(words[0], None, result)


def parse_file(fname):
    result = {}
    with codecs.open(fname, 'r', 'utf8') as f:
        text = f.read()
    process_text(text, result)
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
    guarantee_sentence_word_exists(db)

    missing_words = load_missing_words()

    for word in result:
        for related_word in result[word].related:

            word_id = get_word_id(db, word)
            related_word_id = get_word_id(db, related_word)

            if (word_id is None) or (related_word_id is None):
                if word_id is None and word != '': missing_words.add(word)
                if related_word_id is None and related_word != '': missing_words.add(related_word)
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

    save_missing_words(missing_words)


def guarantee_sentence_word_exists(db):
    db.execute('INSERT OR IGNORE INTO words (word, word_accent, suffix, count, priority) VALUES (?, ?, ?, ?, ?)', (SENTENCE_CONST, SENTENCE_CONST, SENTENCE_CONST, 0, 0))

def save_missing_words(s):
    with open(MISSING_WORDS_FNAME, 'w') as f:
        text = ','.join(s)
        f.write(text)

def load_missing_words():
    if not os.path.isfile(MISSING_WORDS_FNAME):
        return set()

    with open(MISSING_WORDS_FNAME, 'r') as f:
        text = f.read()
        return set(text.split(','))

def main():
    fname = sys.argv[1]    
    result = parse_file(fname)
    save_result_to_db(result)


if __name__ == '__main__':
    main()

