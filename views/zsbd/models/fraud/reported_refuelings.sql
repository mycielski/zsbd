WITH vendor_refuelings AS (
  SELECT
    fuel_amount,
    card_id,
    timestamp
  FROM {{ source("eltrans", "sale") }}
),

card_refuelings AS (
  SELECT
    vr.fuel_amount,
    vr.timestamp,
    c.owner_id AS driver_id
  FROM
    vendor_refuelings AS vr
  INNER JOIN card AS c ON vr.card_id = c.id
),

trip_refuelings AS (
  SELECT
    cr.fuel_amount fuel_added,
    cr.timestamp,
    t.vehicle vehicle_reg,
    cr.driver_id
  FROM
    card_refuelings
      AS cr
    JOIN {{ source("eltrans", "trip") }}
    AS t ON cr.driver_id = t.driver_id
  AND cr.timestamp >= t.start_time AND cr.timestamp <= t.end_time
)

select fuel_added, timestamp, vehicle_reg, driver_id from trip_refuelings
