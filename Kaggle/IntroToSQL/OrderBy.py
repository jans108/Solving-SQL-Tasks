from google.cloud import bigquery

client = bigquery.Client()

dataset_ref = client.dataset("world_bank_intl_education", project="bigquery-public-data")

dataset = client.get_dataset(dataset_ref)

table_ref = dataset_ref.table("international_education")

table = client.get_table(table_ref)

client.list_rows(table, max_results=5).to_dataframe()

country_spend_pct_query = """
                          SELECT country_name,  AVG(value) AS avg_ed_spending_pct
                          FROM `bigquery-public-data.world_bank_intl_education.international_education`
                          WHERE indicator_code = 'SE.XPD.TOTL.GD.ZS' and year >= 2010 and year <= 2017
                          GROUP BY country_name
                          ORDER BY avg_ed_spending_pct DESC
                          """

code_count_query = """
SELECT indicator_code, indicator_name, COUNT(1) AS num_rows
FROM `bigquery-public-data.world_bank_intl_education.international_education`
WHERE year = 2016
GROUP BY indicator_code, indicator_name
HAVING COUNT(1) >= 175
ORDER BY num_rows DESC
"""

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
code_count_query_job = client.query(code_count_query, job_config=safe_config)

code_count_results = code_count_query_job.to_dataframe()

print(code_count_results.head())

q_2.check()