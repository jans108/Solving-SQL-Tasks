from google.cloud import bigquery

client = bigquery.Client()

dataset_ref = client.dataset("openaq", project="bigquery-public-data")

dataset = client.get_dataset(dataset_ref)

table_ref = dataset_ref.table("global_air_quality")

table = client.get_table(table_ref)

client.list_rows(table, max_results=5).to_dataframe()

first_query = """
SELECT DISTINCT country
FROM `bigquery-public-data.openaq.global_air_quality`
WHERE unit = 'ppm'
"""


safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
first_query_job = client.query(first_query, job_config=safe_config)

first_results = first_query_job.to_dataframe()

print(first_results.head())

zero_pollution_query = """
SELECT * 
FROM `bigquery-public-data.openaq.global_air_quality`
WHERE value = 0
"""

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
query_job = client.query(zero_pollution_query, job_config=safe_config)

zero_pollution_results = query_job.to_dataframe()

print(zero_pollution_results.head())