-- Generate 26 semi trucks (DAF, MAN)
INSERT INTO public.vehicle (vehicle_type, number_plate, fuel_capacity, fuel_type_id)
SELECT 
    1 as vehicle_type, -- semi
    'WA' || 
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    lpad(floor(random() * 9 + 1)::text, 2, '0') as number_plate,
    1200 as fuel_capacity, -- typical large truck fuel capacity in liters
    1 as fuel_type_id -- diesel
FROM generate_series(1, 26)
ON CONFLICT (number_plate) DO NOTHING;

-- Generate 4 cars (Honda Civic type vehicles)
INSERT INTO public.vehicle (vehicle_type, number_plate, fuel_capacity, fuel_type_id)
SELECT 
    2 as vehicle_type, -- car
    'WY' || 
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    chr(floor(random() * 26 + 65)::int) || 
    lpad(floor(random() * 9 + 1)::text, 2, '0') as number_plate,
    45 as fuel_capacity, -- typical Civic fuel capacity in liters
    5 as fuel_type_id -- gasoline
FROM generate_series(1, 4)
ON CONFLICT (number_plate) DO NOTHING;

-- Verify the results
SELECT 
    v.number_plate,
    vt.name as vehicle_type,
    ft.name as fuel_type,
    v.fuel_capacity
FROM vehicle v
JOIN vehicle_type vt ON v.vehicle_type = vt.id
JOIN fuel_type ft ON v.fuel_type_id = ft.id
ORDER BY v.vehicle_type, v.number_plate;
