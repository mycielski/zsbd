-- Insert basic fuel types
INSERT INTO public.fuel_type (name)
VALUES 
    ('diesel'),
    ('electric'),
    ('hydrogen'),
    ('hybrid'),
    ('gasoline');

-- Verify the data
SELECT *
FROM public.fuel_type 
ORDER BY id;
