WITH consecutive_measurements AS (
  SELECT
    vehicle_id,
    timestamp,
    fuel_level,
    LEAD(fuel_level)
      OVER (PARTITION BY vehicle_id ORDER BY timestamp)
      AS next_fuel_level,
    LEAD(timestamp)
      OVER (PARTITION BY vehicle_id ORDER BY timestamp)
      AS next_timestamp
  FROM {{ source('eltrans', 'measurement') }}
),

measured_refuelings AS (
  SELECT
    vehicle_id,
    timestamp AS refuel_timestamp,
    fuel_level AS pre_refuel_level,
    next_fuel_level AS post_refuel_level,
    (next_fuel_level - fuel_level) AS fuel_added
  FROM consecutive_measurements
  WHERE
    next_fuel_level > fuel_level
    -- 30% increase threshold
    AND ((next_fuel_level - fuel_level) / fuel_level) > 0.30
    -- Time window threshold
    AND (next_timestamp - timestamp) < INTERVAL '30 minutes'
),

vehicle_refuelings AS (
  SELECT
    mr.refuel_timestamp AS timestamp,
    mr.fuel_added,
    v.number_plate AS vehicle_reg
  FROM measured_refuelings AS mr
  INNER JOIN {{ source("eltrans", "vehicle") }} AS v ON mr.vehicle_id = v.id
)

SELECT
  vehicle_reg,
  fuel_added,
  timestamp
FROM vehicle_refuelings
