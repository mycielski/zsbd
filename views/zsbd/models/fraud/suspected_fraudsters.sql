WITH matched_refuelings AS (
  SELECT
    r.vehicle_reg,
    r.driver_id,
    r.timestamp AS reported_timestamp,
    m.timestamp AS measured_timestamp,
    r.fuel_added AS reported_fuel,
    m.fuel_added AS measured_fuel,
    ABS(r.fuel_added - m.fuel_added) AS fuel_difference,
    ABS(EXTRACT(epoch FROM (r.timestamp - m.timestamp)) / 60)
      AS minutes_difference
  FROM {{ ref('reported_refuelings') }} AS r
  LEFT JOIN {{ ref('measured_refuelings') }} AS m
    ON
      r.vehicle_reg = m.vehicle_reg
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
    ) AS match_rank
  FROM matched_refuelings
  WHERE measured_timestamp IS NOT NULL
),

frauds AS (
  SELECT
    vehicle_reg,
    driver_id,
    measured_timestamp AS timestamp,
    reported_fuel AS fuel_bought,
    measured_fuel AS fuel_added_to_tank,
    fuel_difference AS fuel_volume_discrepancy
  FROM best_matches
  WHERE
    match_rank = 1
    AND fuel_difference >= 50
),

names AS (
  SELECT
    d.first_name,
    d.last_name,
    f.vehicle_reg,
    f.timestamp,
    ROUND(CAST(f.fuel_volume_discrepancy AS numeric), 2) AS fuel_stolen
  FROM frauds AS f
    JOIN {{ source("eltrans", "driver") }} AS d ON f.driver_id = d.id
)

SELECT * FROM names
