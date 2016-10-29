#!/usr/local/bin/python3

import appdb

def main():
    conn = appdb.connect()
    conn.execute('BEGIN TRANSACTION')
    conn.execute('CREATE INDEX words_word_idx ON words (word)')
    conn.execute('CREATE INDEX words_suffix_idx ON words (suffix)')
    conn.execute('CREATE INDEX related_words_word_id_idx ON related_words (word_id)')
    conn.execute('COMMIT')
    conn.close()

if __name__ == '__main__':
    main()
