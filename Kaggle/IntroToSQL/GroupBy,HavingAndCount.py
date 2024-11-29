prolific_commenters_query = """
SELECT `by` AS author, COUNT(1) AS NumPosts
FROM `bigquery-public-data.hacker_news.full`
GROUP BY author
HAVING COUNT(1) > 10000
""" 

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
query_job = client.query(prolific_commenters_query, job_config=safe_config)

prolific_commenters = query_job.to_dataframe()

print(prolific_commenters.head())

deleted_posts_query = """
SELECT COUNT(1) AS num_deleted_posts
FROM `bigquery-public-data.hacker_news.full`
WHERE deleted = true
"""

query_job=client.query(deleted_posts_query)

deleted_posts=query_job.to_dataframe()

print(deleted_posts)