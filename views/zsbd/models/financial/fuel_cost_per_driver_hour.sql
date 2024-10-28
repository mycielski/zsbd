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

money_per_hour AS (
  SELECT
    ms.driver_id,
    ms.total_spending / hd.hours_driven AS spending_rate
  FROM money_spent AS ms
  INNER JOIN hours_driven AS hd ON ms.driver_id = ms.driver_id
),

named_spending_rates AS (
  SELECT
    mph.driver_id,
    d.first_name,
    d.last_name,
    mph.spending_rate
  FROM money_per_hour AS mph
  INNER JOIN {{ source("eltrans", "driver") }} AS d ON mph.driver_id = d.id
)

SELECT * FROM named_spending_rates
