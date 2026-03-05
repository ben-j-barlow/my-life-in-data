from pathlib import Path

from wc_pull_helpers import extract_columns, scrape_module_webpage

extracted_data = extract_columns(
    file=Path(__file__).parent.parent / "data/modules.csv", id_col="id", field="link"
)

module_description = {}
for _id, link in extracted_data.items():
    with open(
        Path(__file__).parent.parent / f"data/module_description/{_id}.txt", "w"
    ) as file:
        file.write(scrape_module_webpage(webpage=link))
