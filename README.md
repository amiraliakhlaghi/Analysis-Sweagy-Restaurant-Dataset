# Swiggy Data Analysis with SQL

This project analyzes Swiggy restaurant data using **SQL** and **DB Browser for SQLite**.  
The raw dataset is stored in `swiggy.csv`, and all cleaning and analytical queries are in `query.sql`.

## Project Structure

```text
.
├── swiggy.csv     # Raw Swiggy restaurant dataset
├── query.sql      # Data cleaning and analysis queries
└── README.md      # Project documentation
```

## Prerequisites

- [DB Browser for SQLite](https://sqlitebrowser.org/)
- SQLite 3
- The `swiggy.csv` dataset

## How to Import the Data in DB Browser

1. Open DB Browser for SQLite.
2. Go to `File` → `New Database` and create a database file, for example `swiggy.db`.
3. Go to `File` → `Import` → `Table from CSV file...`.
4. Select `swiggy.csv`.
5. Configure the import:
   - `Table name`: `swiggy`
   - Enable `First row contains column names`
   - `Encoding`: `UTF-8`
   - `Field separator`: `,`
   - `Quote character`: `"`

To verify the import:

```sql
SELECT COUNT(*) FROM swiggy;
```

## Expected Outputs

After running the queries, you should obtain results such as:

- Distribution of restaurants across cities
- Most frequent cuisine types
- Largest restaurant chains by branch count
- Cities with the highest average restaurant ratings
- Average cost for two by city
- High-rated restaurants with a large number of ratings
- Cities with the best value-for-money profile
