-- First generate the routes with simpler approach
WITH route_templates AS (
    SELECT * FROM (VALUES 
        -- Pattern 1: Warsaw -> Berlin -> Paris -> Warsaw
        ('Warsaw', 'Berlin', 1, 
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 LIMIT 1),
         (SELECT number_plate FROM trailer LIMIT 1)),
        ('Berlin', 'Paris', 1,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 LIMIT 1),
         (SELECT number_plate FROM trailer LIMIT 1)),
        ('Paris', 'Warsaw', 1,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 LIMIT 1),
         (SELECT number_plate FROM trailer LIMIT 1)),
        
        -- Pattern 2: Warsaw -> Prague -> Vienna -> Budapest
        ('Warsaw', 'Prague', 2,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 1 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 1 LIMIT 1)),
        ('Prague', 'Vienna', 2,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 1 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 1 LIMIT 1)),
        ('Vienna', 'Budapest', 2,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 1 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 1 LIMIT 1))
    ) AS t(source, destination, driver_id, vehicle, trailer)
)

INSERT INTO trip (source, destination, start_time, end_time, vehicle, trailer, driver_id)
SELECT 
    source,
    destination,
    timestamp '2024-01-01 08:00:00' + 
        (row_number() OVER (PARTITION BY driver_id ORDER BY source) - 1) * interval '3 days' as start_time,
    timestamp '2024-01-01 08:00:00' + 
        (row_number() OVER (PARTITION BY driver_id ORDER BY source) - 1) * interval '3 days' +
        interval '8 hours' + -- base driving time
        (random() * interval '2 hours') as end_time, -- add some randomness
    vehicle,
    trailer,
    driver_id
FROM route_templates;

-- Verify with proper table alias
SELECT 
    t.source,
    t.destination,
    t.start_time,
    t.end_time,
    t.vehicle,
    t.trailer,
    d.first_name || ' ' || d.last_name as driver,
    t.end_time - t.start_time as trip_duration
FROM trip t
JOIN driver d ON t.driver_id = d.id
ORDER BY t.driver_id, t.start_time;
