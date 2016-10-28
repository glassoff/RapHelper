#!/usr/local/bin/python3

import sqlite3
import appdb
import sys
import codecs

def extract_suffix(word):
    index = word.find("'")
    if index < 0:
        return word

    start = word[index-1] if index > 0 else ''
    end = word[index+1:] if index < len(word) - 1 else ''
    return start + end

def save_word(word, priority):
    if word == '':
        return

    word_accent = word
    word_clear = word.replace("'", '').replace("`", '')
    suffix = extract_suffix(word)

    db.execute('''INSERT OR IGNORE INTO words (word, word_accent, suffix, count, priority) VALUES (?, ?, ?, ?, ?)''', (word_clear, word_accent, suffix, 0, priority))

def parse_dict(fname, priority):
    db.execute('BEGIN TRANSACTION')
    with codecs.open(fname, 'r', 'utf8') as f:
        for line in f:
            for word in line.split(','):
                word_to_save = word
                if '#' in word:
                    word_to_save = word.split('#')[-1]
                save_word(word_to_save.strip(), priority)
    db.execute('COMMIT')


def main():
    fname = sys.argv[1]
    priority = sys.argv[2]

    global db
    db = appdb.connect()
    appdb.create_db(db)
    parse_dict(fname, priority)
    db.close()


if __name__ == '__main__':
    main()

