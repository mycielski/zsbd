WITH hours_driven AS (
  SELECT
    driver_id,
    hours_driven
  FROM {{ ref("driver_hours") }}
),

money_spent AS (
  SELECT
    driver_id,
    total_spending
  FROM {{ ref("money_spent") }}
),

time_and_spending AS (
  SELECT
    ms.driver_id,
    ms.total_spending,
    hd.hours_driven
  FROM money_spent AS ms
  RIGHT JOIN hours_driven AS hd
    ON ms.driver_id = hd.driver_id
),

money_per_hour AS (
  SELECT
    driver_id,
    total_spending / hours_driven AS spending_rate
  FROM time_and_spending
),

named_spending_rates AS (
  SELECT
    mph.driver_id,
    d.first_name,
    d.last_name,
    round(mph.spending_rate, 2) AS fuel_spending_per_hour
  FROM money_per_hour AS mph
  INNER JOIN {{ source("eltrans", "driver") }} AS d ON mph.driver_id = d.id
)

SELECT * FROM named_spending_rates ORDER BY fuel_spending_per_hour ASC
