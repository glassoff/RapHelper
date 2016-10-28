import sqlite3

def create_db(db):
    db.execute('''CREATE TABLE IF NOT EXISTS words (word_id INTEGER PRIMARY KEY, word text UNIQUE, word_accent text, suffix text) ''')
    db.execute('''CREATE TABLE IF NOT EXISTS related_words (word_id INTEGER, related_word_id INTEGER, count INTEGER, PRIMARY KEY (word_id, related_word_id))''')
    db.commit()

def connect():
    db = sqlite3.connect('words.db')
    db.isolation_level = None
    return db
