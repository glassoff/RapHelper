#!/usr/local/bin/python3

import sys

def replace_accents(text):
    result = text.replace('\u0301', "'")
    words = list(filter(lambda x: x.find("'") >= 0, result.split(',')))
    return ','.join(words)

def main():
    fname = sys.argv[1]
    outfname = sys.argv[2]
    with open(fname, 'r') as f:
        corrected = replace_accents(f.read())
    with open(outfname, 'w') as f:
        f.write(corrected)    

if __name__ == '__main__':
    main()
