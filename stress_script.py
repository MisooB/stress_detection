import json
import re


def create_word_dict(fp):
    word_dict = {}
    file_name = ""
    for line in fp:
        if (line[0]) == "[":
            file_name = line.replace("[", "").replace("]", "").replace("\n", "")
        if "SWAC_TEXT" in line:
            word = line.replace("SWAC_TEXT=", "").replace("\n", "").split()
            if len(word) == 1:
                if (syllable_count(word[0]) > 1 and not '-' in word[0] and not '.' in word[0]):
                    word = re.sub(r'[^\w\s]', '', word[0])
                    if (word.lower() in stress_dict.keys()):
                        word_dict[word.lower()] = {"file_name": file_name, "stress_seq": stress_dict[word.lower()]}
    return word_dict


def syllable_count(word):
    word = word.lower()
    count = 0
    vowels = "aeiouy"
    if word[0] in vowels:
        count += 1
    for index in range(1, len(word)):
        if word[index] in vowels and word[index - 1] not in vowels:
            count += 1
            if word.endswith("e"):
                count -= 1
    if count == 0:
        count += 1
    return count


def create_stress_dict(fp):
    stress_dict = {}
    for line in fp:
        stress_sequence = line.split("  ")
        word = stress_sequence[0].lower()
        stress_sequence = re.sub('[^0-9]', '', stress_sequence[1])
        stress_dict[word] = stress_sequence
    return stress_dict


with open("stress_dictionary.txt", "r") as fp2:
    stress_dict = create_stress_dict(fp2)

with open("sounds\dataset4\index.tags.txt", "r") as fp:
    word_dict = create_word_dict(fp)

with open('word_dict4.json', 'w') as fp:
    json.dump(word_dict, fp)

# with open('stress_dict.json', 'w') as fp:
#     json.dump(stress_dict, fp)
