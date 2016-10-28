#!/usr/local/bin/python3

import sqlite3
import sys
import re

clear_pattern = re.compile('[\W]+')

class WordInfo:
    def __init__(self):
        self.related = {}
        self.count = 0

def clear_word(word):
   return clear_pattern.sub('', word).lower()

result = {}

def inc_by_key(key, dic):
    if not (key in dic):
        dic[key] = 0
    dic[key] += 1

def process_line(line):
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
    global result
    result = {}
    with open(fname) as f:
        for line in f:
            process_line(line)

def main():
    fname = sys.argv[1]
    parse_file(fname)

if __name__ == '__main__':
    main()

