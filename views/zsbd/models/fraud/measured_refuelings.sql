WITH measurements AS (
  SELECT
    fuel_level,
    vehicle_id,
    timestamp
  FROM {{ source("eltrans", "measurement") }}
),

fuel_leaps AS (
  SELECT
    l.vehicle_id,
    l.timestamp
  FROM measurements AS l
  INNER JOIN measurement AS r ON l.timestamp + INTERVAL '3 seconds' = r.timestamp
  WHERE l.fuel_level * 2 < r.fuel_level
),

refueling_timestamps AS (
  SELECT
    timestamp,
    vehicle_id
  FROM fuel_leaps
)

SELECT * FROM refueling_timestamps

