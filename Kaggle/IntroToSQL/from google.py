from google.cloud import bigquery

client = bigquery.Client()

dataset_ref = client.dataset("chicago_crime", project="bigquery-public-data")

# API request - fetch the dataset
dataset = client.get_dataset(dataset_ref)

tables = list(client.list_tables(dataset))

for table in tables: 
    print(table.table_id)

print(len(tables))

table_ref = dataset_ref.table("crime")

table = client.get_table(table_ref)

print(table.schema)

num_timestamp_fields = 2 

print(num_timestamp_fields)

client.list_rows(table, max_results=5).to_dataframe()

fields_for_plotting = [41, -87]

print(fields_for_plotting)