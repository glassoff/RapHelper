import sqlite3
import codecs
import appdb

def extract_suffix(word):
    index = word.find("'")
    if index < 0:
        return word

    start = word[index-1] if index > 0 else ''
    end = word[index+1:] if index < len(word) - 1 else ''
    return start + end

def save_word(word):
    if word == '':
        return

    word_accent = word
    word_clear = word.replace("'", '')
    suffix = extract_suffix(word)

    db.execute('''INSERT OR IGNORE INTO words (word, word_accent, suffix) VALUES (?, ?, ?)''', (word_clear, word_accent, suffix))

def parse_dict():
    db.execute('BEGIN TRANSACTION')
    with codecs.open('words.txt', 'r', 'cp1251') as f:
        for line in f:
            for word in line.split(','):
                word_to_save = word
                if '#' in word:
                    word_to_save = word.split('#')[-1]
                save_word(word_to_save.strip())
    db.execute('COMMIT')


def main():
    global db
    db = appdb.connect()
    appdb.create_db(db)
    parse_dict()
    db.close()


if __name__ == '__main__':
    main()

