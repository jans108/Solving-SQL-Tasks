from google.cloud import bigquery

client = bigquery.Client()

dataset_ref = client.dataset("stackoverflow", project="bigquery-public-data")

dataset = client.get_dataset(dataset_ref)

tables = list(client.list_tables(dataset))
list_of_tables =  [table.table_id for table in tables]

print(list_of_tables)

answers_table_ref = dataset_ref.table("posts_answers")

answers_table = client.get_table(answers_table_ref)

client.list_rows(answers_table, max_results=5).to_dataframe()

questions_table_ref = dataset_ref.table("posts_questions")

questions_table = client.get_table(questions_table_ref)

client.list_rows(questions_table, max_results=5).to_dataframe()

questions_query = """
                  SELECT id, title, owner_user_id 
                  FROM `bigquery-public-data.stackoverflow.posts_questions`
                  WHERE tags LIKE '%bigquery%'
                  """

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
questions_query_job = client.query(questions_query, job_config = safe_config) 

questions_results = questions_query_job.to_dataframe() 

print(questions_results.head())

answers_query = """
SELECT a.id, a.body, a.owner_user_id
FROM `bigquery-public-data.stackoverflow.posts_answers` as a
INNER JOIN `bigquery-public-data.stackoverflow.posts_questions` as q
    ON q.id = a.parent_id
WHERE q.tags LIKE '%bigquery%'
"""

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=27*10**10)
answers_query_job = client.query(answers_query, job_config = safe_config) 

answers_results = answers_query_job.to_dataframe()

print(answers_results.head())

bigquery_experts_query = """
SELECT a.owner_user_id AS user_id, COUNT(1) AS number_of_answers
FROM `bigquery-public-data.stackoverflow.posts_answers` as a
INNER JOIN `bigquery-public-data.stackoverflow.posts_questions` as q
    ON q.id = a.parent_id
WHERE q.tags LIKE '%bigquery%'
GROUP BY user_id
"""

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
bigquery_experts_query_job = client.query(bigquery_experts_query, job_config=safe_config) 

bigquery_experts_results = bigquery_experts_query_job.to_dataframe() 

print(bigquery_experts_results.head())
