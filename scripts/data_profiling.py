import sweetviz as sv
import pandas as pd
from pathlib import Path

def load_data(file):
    file_path = Path(file)
    if file_path.exists():
        df = pd.read_csv(file_path)
        print(f"File loaded successfully from {file_path}")
        return df
    else:
        print(f"File not found: {file_path}")
        return None
    
def display_report(df, output_file):
    report = sv.analyze(df)
    report.show_html(output_file, open_browser=False)

df = load_data("data/source_crm/sales_details.csv")
if df is not None: 
    display_report(df, "crm_sales_report.html")