import pandas as pd
from sqlalchemy import text
from pathlib import Path
from scripts.database import engine

# Define the data directory at the root of your project
DATA_DIR = Path(__file__).resolve().parent.parent / "data"

def export_gold_to_csv():
    # Ensure the data directory exists
    DATA_DIR.mkdir(exist_ok=True)
    
    tables = [
        "dim_customers",
        "dim_product",
        "fact_sales",
        "reporting_mart"
    ]
    
    print("\nStarting CSV Extraction...")
    with engine.connect() as conn:
        for table in tables:
            print(f"Exporting gold.{table} to CSV...")
            query = text(f"SELECT * FROM gold.{table}")
            df = pd.read_sql(query, conn)
            df.to_csv(DATA_DIR / f"{table}.csv", index=False)
            
    print("CSV Extraction Complete.")

if __name__ == "__main__":
    export_gold_to_csv()