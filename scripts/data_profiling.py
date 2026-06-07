import sweetviz as sv
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
REPORTS_DIR = BASE_DIR / "reports"
REPORTS_DIR.mkdir(exist_ok=True)

DATASETS = {
    "crm_cust_info":    DATA_DIR / "source_crm" / "cust_info.csv",
    "crm_prd_info":     DATA_DIR / "source_crm" / "prd_info.csv",
    "crm_sales_details":DATA_DIR / "source_crm" / "sales_details.csv",
    "erp_cust_az12":    DATA_DIR / "source_erp" / "cust_az12.csv",
    "erp_loc_a101":     DATA_DIR / "source_erp" / "loc_a101.csv",
    "erp_px_cat_g1v2":  DATA_DIR / "source_erp" / "px_cat_g1v2.csv",
}

def load_data(file_path: Path) -> pd.DataFrame | None:
    if file_path.exists():
        df = pd.read_csv(file_path)
        print(f"  [OK] Loaded: {file_path.name}  ({len(df):,} rows x {len(df.columns)} cols)")
        return df
    else:
        print(f"  [ERROR] File not found: {file_path}")
        return None

def generate_report(name: str, df: pd.DataFrame):
    output_file = REPORTS_DIR / f"{name}_report.html"
    report = sv.analyze(df)
    report.show_html(str(output_file), open_browser=False)
    print(f"  [SAVED] Report -> {output_file.relative_to(BASE_DIR)}")

if __name__ == "__main__":
    print("\nData Profiling - All Source Datasets\n" + "=" * 45)
    for name, path in DATASETS.items():
        print(f"\n[{name}]")
        df = load_data(path)
        if df is not None:
            generate_report(name, df)
    print("\n[DONE] All profiling reports generated in reports/\n")