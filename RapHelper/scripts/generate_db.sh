rm words.db

echo "Parsing normal words dictionary..."
./parse_dict.py "seed/words.txt" 0

echo "Parsing fucks dictionary..."
./parse_dict.py "seed/fucks.txt" 1

echo "Analize words usage..."
./parse_text.py "seed/voina.txt"
./parse_text.py "seed/voina2.txt"

echo "Done. See results in words.db"
