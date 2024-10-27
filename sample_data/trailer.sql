-- Generate 25 regular trailers (no fuel capacity)
INSERT INTO public.trailer (number_plate, fuel_capacity, fuel_type_id)
SELECT 
    'WA' || 
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    lpad(floor(random() * 9 + 1)::text, 2, '0') as number_plate,
    NULL as fuel_capacity,
    NULL as fuel_type_id
FROM generate_series(1, 25)
ON CONFLICT (number_plate) DO NOTHING;

-- Generate 5 refrigerated trailers with diesel tanks
INSERT INTO public.trailer (number_plate, fuel_capacity, fuel_type_id)
SELECT 
    'WA' || 
    'R' || -- R to indicate Refrigerated
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    lpad(floor(random() * 9 + 1)::text, 2, '0') as number_plate,
    300 as fuel_capacity, -- 300L diesel tank for cooling unit
    1 as fuel_type_id    -- diesel
FROM generate_series(1, 5)
ON CONFLICT (number_plate) DO NOTHING;

-- Verify the results
SELECT 
    t.number_plate,
    t.fuel_capacity,
    ft.name as fuel_type,
    CASE 
        WHEN t.fuel_capacity IS NOT NULL THEN 'Refrigerated'
        ELSE 'Standard'
    END as trailer_type
FROM trailer t
LEFT JOIN fuel_type ft ON t.fuel_type_id = ft.id
ORDER BY trailer_type DESC, t.number_plate;

