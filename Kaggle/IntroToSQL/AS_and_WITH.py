from google.cloud import bigquery

client = bigquery.Client()

dataset_ref = client.dataset("chicago_taxi_trips", project="bigquery-public-data")

dataset = client.get_dataset(dataset_ref)

tables = list(client.list_tables(dataset))

for table in tables:
    print(table.table_id)

table_ref = dataset_ref.table('taxi_trips')

table = client.get_table(table_ref)

client.list_rows(table, max_results=5).to_dataframe()

rides_per_year_query = """

SELECT EXTRACT(YEAR FROM trip_start_timestamp) AS year, COUNT (1) AS num_trips
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY year
ORDER BY year
"""

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
rides_per_year_query_job = client.query(rides_per_year_query, job_config = safe_config)

rides_per_year_result = rides_per_year_query_job.to_dataframe()

print(rides_per_year_result)

rides_per_month_query = """
                       SELECT EXTRACT(MONTH FROM trip_start_timestamp) AS month, 
                              COUNT(1) AS num_trips
                       FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
                       WHERE EXTRACT(YEAR FROM trip_start_timestamp) = 2016
                       GROUP BY month
                       ORDER BY month
                       """

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
rides_per_month_query_job = client.query(rides_per_month_query,job_config = safe_config)

rides_per_month_result = rides_per_month_query_job.to_dataframe()

print(rides_per_month_result)

speeds_query = """
               WITH RelevantRides AS
               (
                   SELECT EXTRACT(HOUR FROM trip_start_timestamp) AS hour_of_day, 
                   trip_miles,
                   trip_seconds
                   FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
                   WHERE `trip_start_timestamp` > '2016-01-01' 
                   AND `trip_start_timestamp` < '2016-04-01' 
                   AND `trip_seconds` > 0
                   AND `trip_miles` > 0
               )
               SELECT hour_of_day,
                   COUNT(1) AS num_trips,
                   3600 * SUM(trip_miles) / SUM(trip_seconds) AS avg_mph
               FROM RelevantRides
               GROUP BY hour_of_day
               ORDER BY hour_of_day
               """

safe_config = bigquery.QueryJobConfig(maximum_bytes_billed=10**10)
speeds_query_job = client.query(speeds_query, job_config = safe_config) 

speeds_result = speeds_query_job.to_dataframe()

print(speeds_result)