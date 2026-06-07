import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

import pandas as pd
import sweetviz as sv
from scripts.config import DATA_DIR, REPORTS_DIR, logger

DATASETS = {
    "crm_cust_info": DATA_DIR / "source_crm" / "cust_info.csv",
    "crm_prd_info": DATA_DIR / "source_crm" / "prd_info.csv",
    "crm_sales_details": DATA_DIR / "source_crm" / "sales_details.csv",
    "erp_cust_az12": DATA_DIR / "source_erp" / "cust_az12.csv",
    "erp_loc_a101": DATA_DIR / "source_erp" / "loc_a101.csv",
    "erp_px_cat_g1v2": DATA_DIR / "source_erp" / "px_cat_g1v2.csv",
}

def load_data(file_path):
    if not file_path.exists():
        logger.warning(f"Missing: {file_path}")
        return None

    df = pd.read_csv(file_path)
    logger.info(f"Loaded ({len(df):,} rows × {df.shape[1]} columns)")
    return df

def generate_report(name, df):
    output_file = REPORTS_DIR / f"{name}_report.html"

    sv.analyze(df).show_html(
        filepath=str(output_file),
        open_browser=False
    )

    logger.info(f"Saved: {output_file}")


def run_profile(name, file_path):
    df = load_data(file_path)

    if df is None:
        return

    generate_report(name, df)

def main():
    logger.info("\nData Profiling — Source Datasets")
    for name, path in DATASETS.items():
        logger.info(f"\n[{name}]")
        run_profile(name, path)

    logger.info("\nAll profiling reports generated.")

if __name__ == "__main__":
    main()