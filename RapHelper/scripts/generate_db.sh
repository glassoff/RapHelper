rm words.db
rm missing_words.txt

echo "Parsing normal words dictionary..."
./parse_dict.py "seed/words.txt" 0

echo "Parsing fucks dictionary..."
./parse_dict.py "seed/fucks.txt" 1

echo "Parsing corrections dictionary..."
./parse_dict.py "seed/corrected_dict.txt" 1

echo "Training by Miron..." && ./parse_text.py "seed/miron.txt"
echo "Training by Leningrad..." && ./parse_text.py "seed/leningrad.txt"
echo "Training by Versus..." && ./parse_text.py "seed/versus.txt"
echo "Training by Pelevin" && ./parse_text.py "seed/pelevin.txt"
echo "Training by Irvin" && ./parse_text.py "seed/irvin_acid_house.txt"
echo "Training by Irvin" && ./parse_text.py "seed/irvin_extasy.txt"

echo "Done. See results in words.db. See missing words in missing_words.txt"
