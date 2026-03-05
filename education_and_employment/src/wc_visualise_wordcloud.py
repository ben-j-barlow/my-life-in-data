from pathlib import Path
import re
from wordcloud import STOPWORDS

from wc_visualise_helpers import (
    read_files,
    remove_extra_spaces,
    remove_punctuation,
    generate_wordcloud,
    read_stopwords
)


def produce_wordcloud(path: [str, Path] = Path(__file__).parent.parent / "plot/module_wordcloud.png"):
    files_dictionary = read_files(
        directory=Path(__file__).parent.parent / "data/module_description"
    )

    text = " ".join(list(files_dictionary.values()))
    text = text.lower()
    text = re.sub(r"\d+", "", text)
    text = remove_extra_spaces(text)
    text = remove_punctuation(text)

    stopwords = STOPWORDS.union(set(read_stopwords()))

    generate_wordcloud(
        text=text, stopwords=stopwords, path=path
    )

produce_wordcloud()
