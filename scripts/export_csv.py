import pandas as pd
from sqlalchemy import text
from pathlib import Path
from scripts.database import engine

DATA_DIR = Path(__file__).resolve().parent.parent / "data"

def export_gold_to_csv():
    DATA_DIR.mkdir(exist_ok=True)
    
    tables = [
        ("dim_customer", "dim_customers"),
        ("dim_product", "dim_product"),
        ("fact_sales", "fact_sales"),
        ("reporting_mart", "reporting_mart")
    ]
    
    print("\nStarting CSV Extraction...")
    with engine.connect() as conn:
        for db_table, csv_name in tables:
            print(f"Exporting gold.{db_table} to CSV...")
            query = text(f"SELECT * FROM gold.{db_table}")
            df = pd.read_sql(query, conn)
            df.to_csv(DATA_DIR / f"{csv_name}.csv", index=False)
            
    print("CSV Extraction Complete.")

if __name__ == "__main__":
    export_gold_to_csv()