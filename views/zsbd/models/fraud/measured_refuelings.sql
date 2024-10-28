WITH consecutive_measurements AS (
  SELECT 
    vehicle_id,
    "timestamp",
    fuel_level,
    LEAD(fuel_level) OVER (PARTITION BY vehicle_id ORDER BY "timestamp") as next_fuel_level,
    LEAD("timestamp") OVER (PARTITION BY vehicle_id ORDER BY "timestamp") as next_timestamp
  FROM {{ source('eltrans', 'measurement') }}
)

SELECT 
  vehicle_id,
  "timestamp" as refuel_timestamp,
  fuel_level as pre_refuel_level,
  next_fuel_level as post_refuel_level,
  (next_fuel_level - fuel_level) as fuel_added,
  ROUND(((next_fuel_level - fuel_level) / NULLIF(fuel_level, 0) * 100)::numeric, 2) as percentage_increase,
  EXTRACT(EPOCH FROM (next_timestamp - "timestamp"))/60 as minutes_between_readings
FROM consecutive_measurements
WHERE 
  next_fuel_level > fuel_level
  AND fuel_level > 0  -- Avoid division by zero
  AND ((next_fuel_level - fuel_level) / fuel_level) > 0.30  -- 30% increase threshold
  AND (next_timestamp - "timestamp") < INTERVAL '30 minutes'  -- Time window threshold
ORDER BY vehicle_id, "timestamp"

