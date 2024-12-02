WITH route_templates AS (
    SELECT * FROM (VALUES 
        -- Pattern 1: Warsaw -> Berlin -> Paris -> Warsaw (Driver 1)
        ('Warsaw', 'Berlin', 1, 
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 LIMIT 1),
         (SELECT number_plate FROM trailer LIMIT 1)),
        ('Berlin', 'Paris', 1,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 LIMIT 1),
         (SELECT number_plate FROM trailer LIMIT 1)),
        ('Paris', 'Warsaw', 1,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 LIMIT 1),
         (SELECT number_plate FROM trailer LIMIT 1)),
        
        -- Pattern 2: Warsaw -> Prague -> Vienna -> Budapest (Driver 2)
        ('Warsaw', 'Prague', 2,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 1 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 1 LIMIT 1)),
        ('Prague', 'Vienna', 2,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 1 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 1 LIMIT 1)),
        ('Vienna', 'Budapest', 2,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 1 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 1 LIMIT 1)),

        -- Pattern 3: Warsaw -> Stockholm -> Copenhagen (Driver 3)
        ('Warsaw', 'Stockholm', 3,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 2 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 2 LIMIT 1)),
        ('Stockholm', 'Copenhagen', 3,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 2 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 2 LIMIT 1)),

        -- Pattern 4: Warsaw -> Munich -> Zurich (Driver 4)
        ('Warsaw', 'Munich', 4,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 3 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 3 LIMIT 1)),
        ('Munich', 'Zurich', 4,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 3 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 3 LIMIT 1)),

        -- Pattern 5: Warsaw -> Bratislava -> Budapest -> Bucharest (Driver 5)
        ('Warsaw', 'Bratislava', 5,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 4 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 4 LIMIT 1)),
        ('Bratislava', 'Budapest', 5,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 4 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 4 LIMIT 1)),
        ('Budapest', 'Bucharest', 5,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 4 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 4 LIMIT 1)),

        -- Pattern 6: Warsaw -> Riga -> Tallinn (Driver 6)
        ('Warsaw', 'Riga', 6,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 5 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 5 LIMIT 1)),
        ('Riga', 'Tallinn', 6,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 5 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 5 LIMIT 1)),

        -- Pattern 7: Warsaw -> Brussels -> Amsterdam (Driver 7)
        ('Warsaw', 'Brussels', 7,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 6 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 6 LIMIT 1)),
        ('Brussels', 'Amsterdam', 7,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 6 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 6 LIMIT 1)),

        -- Pattern 8: Warsaw -> Kiev -> Minsk -> Warsaw (Driver 8)
        ('Warsaw', 'Kiev', 8,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 7 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 7 LIMIT 1)),
        ('Kiev', 'Minsk', 8,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 7 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 7 LIMIT 1)),
        ('Minsk', 'Warsaw', 8,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 7 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 7 LIMIT 1)),

        -- Pattern 9: Warsaw -> Prague -> Munich (Driver 9)
        ('Warsaw', 'Prague', 9,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 8 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 8 LIMIT 1)),
        ('Prague', 'Munich', 9,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 8 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 8 LIMIT 1)),

        -- Pattern 10: Warsaw -> Vienna -> Zagreb (Driver 10)
        ('Warsaw', 'Vienna', 10,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 9 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 9 LIMIT 1)),
        ('Vienna', 'Zagreb', 10,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 9 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 9 LIMIT 1)),

        -- Pattern 11: Warsaw -> Berlin -> Hamburg (Driver 11)
        ('Warsaw', 'Berlin', 11,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 10 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 10 LIMIT 1)),
        ('Berlin', 'Hamburg', 11,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 10 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 10 LIMIT 1)),

        -- Pattern 12: Warsaw -> Vilnius -> Riga (Driver 12)
        ('Warsaw', 'Vilnius', 12,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 11 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 11 LIMIT 1)),
        ('Vilnius', 'Riga', 12,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 11 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 11 LIMIT 1)),

        -- Pattern 13: Warsaw -> Bratislava -> Vienna (Driver 13)
        ('Warsaw', 'Bratislava', 13,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 12 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 12 LIMIT 1)),
        ('Bratislava', 'Vienna', 13,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 12 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 12 LIMIT 1)),

        -- Pattern 14: Warsaw -> Gdansk -> Berlin (Driver 14)
        ('Warsaw', 'Gdansk', 14,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 13 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 13 LIMIT 1)),
        ('Gdansk', 'Berlin', 14,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 13 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 13 LIMIT 1)),

        -- Pattern 15: Warsaw -> Lodz -> Wroclaw -> Prague (Driver 15)
        ('Warsaw', 'Lodz', 15,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 14 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 14 LIMIT 1)),
        ('Lodz', 'Wroclaw', 15,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 14 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 14 LIMIT 1)),
        ('Wroclaw', 'Prague', 15,
         (SELECT number_plate FROM vehicle WHERE vehicle_type = 1 OFFSET 14 LIMIT 1),
         (SELECT number_plate FROM trailer OFFSET 14 LIMIT 1))

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
