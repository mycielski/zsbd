WITH matched_refuelings AS (
  SELECT
    r.vehicle_reg,
    r.driver_id,
    r.timestamp as reported_timestamp,
    m.timestamp as measured_timestamp,
    r.fuel_added as reported_fuel,
    m.fuel_added as measured_fuel,
    ABS(r.fuel_added - m.fuel_added) as fuel_difference,
    ABS(EXTRACT(EPOCH FROM (r.timestamp - m.timestamp))/60) as minutes_difference
  FROM {{ ref('reported_refuelings') }} r
  LEFT JOIN {{ ref('measured_refuelings') }} m
    ON r.vehicle_reg = m.vehicle_reg
    AND m.timestamp BETWEEN r.timestamp - INTERVAL '30 minutes' 
                        AND r.timestamp + INTERVAL '30 minutes'
),

best_matches AS (
  SELECT 
    vehicle_reg,
    driver_id,
    reported_timestamp,
    measured_timestamp,
    reported_fuel,
    measured_fuel,
    fuel_difference,
    minutes_difference,
    ROW_NUMBER() OVER (
      PARTITION BY vehicle_reg, reported_timestamp 
      ORDER BY minutes_difference, fuel_difference
    ) as match_rank
  FROM matched_refuelings
  WHERE measured_timestamp IS NOT NULL 
),

frauds AS (
SELECT 
  vehicle_reg, 
  driver_id,
  measured_timestamp timestamp,
  reported_fuel fuel_bought,
  measured_fuel fuel_added_to_tank, 
  fuel_difference fuel_volume_discrepancy
FROM best_matches
WHERE match_rank = 1
  AND fuel_difference >= 50
),

names AS (
	select d.first_name, d.last_name, f.vehicle_reg, f.timestamp, round(cast(f.fuel_volume_discrepancy as numeric), 2) fuel_stolen
	from frauds f join {{source("eltrans", "driver")}} d on d.id=f.driver_id
)

select * from names
