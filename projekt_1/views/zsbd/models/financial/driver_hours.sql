WITH trip_times AS (
  SELECT
    driver_id,
    id,
    EXTRACT(epoch FROM (end_time - start_time)) / 3600 AS trip_hours
  FROM {{ source("eltrans", "trip") }}
),

aggregate_hours AS (
  SELECT
    driver_id,
    SUM(trip_hours) AS hours_driven
  FROM trip_times
  GROUP BY driver_id
),

named_hours AS (
  SELECT
    d.first_name,
    d.last_name,
    ah.hours_driven,
    ah.driver_id
  FROM aggregate_hours AS ah
  INNER JOIN {{ source("eltrans", "driver") }} AS d
    ON ah.driver_id = d.id
)

SELECT * FROM named_hours
