import os
import string
import re
import typing
from pathlib import Path

from wordcloud import WordCloud
import matplotlib.pyplot as plt





def remove_extra_spaces(text: str) -> str:
    # Replace multiple spaces, new lines, and tabs with a single space
    cleaned_text = re.sub(r"\s+", " ", text.replace("\n", " "))
    return cleaned_text


def remove_punctuation(text: str) -> str:
    # Create a translation table using the string.punctuation string
    translator = str.maketrans("", "", string.punctuation)
    # Apply the translation table to remove punctuation
    text_without_punct = text.translate(translator)
    return text_without_punct


def read_files(directory: Path) -> dict[bytes, str]:
    file_dict = {}
    for filename in sorted(os.listdir(directory), key=lambda x: int(x[:-4])):
        if filename.endswith(".txt"):
            filepath = os.path.join(directory, filename)
            with open(filepath, "r") as file:
                file_contents = file.read()
                file_dict[filename] = file_contents
    return file_dict


def generate_wordcloud(text: str, stopwords: list[str], path: "Path") -> None:
    # Create a WordCloud object with desired configurations
    wordcloud = WordCloud(
        collocations=True,
        width=800,
        height=400,
        background_color="white",
        stopwords=set(stopwords),
    )

    # Generate the word cloud from the input text
    wordcloud.generate(text)

    # Display the word cloud using matplotlib
    plt.figure(figsize=(20, 10))
    plt.imshow(wordcloud, interpolation="bilinear")
    plt.axis("off")
    plt.savefig(path)


def read_stopwords() -> list[str]:
    with open(Path(__file__).parent.parent / "data/stopwords.txt", "r") as file:
        word_list = file.read().splitlines()
    return word_list
