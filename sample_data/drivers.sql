-- First, let's create arrays of common Polish first and last names
WITH first_names AS (
  SELECT unnest(ARRAY[
    'Adam', 'Piotr', 'Krzysztof', 'Andrzej', 'Tomasz', 'Jan', 'Paweł', 
    'Michał', 'Marcin', 'Marek', 'Grzegorz', 'Józef', 'Łukasz', 'Zbigniew',
    'Anna', 'Maria', 'Katarzyna', 'Małgorzata', 'Agnieszka', 'Barbara', 
    'Ewa', 'Krystyna', 'Magdalena', 'Elżbieta', 'Joanna', 'Aleksandra', 'Zofia'
  ]) AS first_name
),
last_names AS (
  SELECT unnest(ARRAY[
    'Nowak', 'Kowalski', 'Wiśniewski', 'Wójcik', 'Kowalczyk', 'Kamiński',
    'Lewandowski', 'Zieliński', 'Szymański', 'Woźniak', 'Dąbrowski', 
    'Kozłowski', 'Jankowski', 'Mazur', 'Kwiatkowski', 'Krawczyk', 'Piotrowski',
    'Grabowski', 'Nowakowski', 'Pawłowski', 'Michalski', 'Adamczyk'
  ]) AS last_name
)

-- Insert random combinations of Polish names into the driver table
INSERT INTO public.driver (first_name, last_name, is_active)
SELECT 
  f.first_name,
  CASE 
    -- Add feminine endings to last names for female first names
    WHEN f.first_name IN ('Anna', 'Maria', 'Katarzyna', 'Małgorzata', 'Agnieszka', 
                         'Barbara', 'Ewa', 'Krystyna', 'Magdalena', 'Elżbieta', 
                         'Joanna', 'Aleksandra', 'Zofia') 
    THEN 
      CASE 
        WHEN l.last_name LIKE '%ski' THEN REPLACE(l.last_name, 'ski', 'ska')
        WHEN l.last_name LIKE '%cki' THEN REPLACE(l.last_name, 'cki', 'cka')
        WHEN l.last_name LIKE '%dzki' THEN REPLACE(l.last_name, 'dzki', 'dzka')
        ELSE l.last_name
      END
    ELSE l.last_name
  END as last_name,
  random() < 0.8 as is_active  -- Make about 80% of drivers active
FROM 
  (SELECT first_name FROM first_names ORDER BY random() LIMIT 30) f
  CROSS JOIN
  (SELECT last_name FROM last_names ORDER BY random() LIMIT 30) l
ORDER BY random()
LIMIT 25;  -- This will create 25 drivers

-- Verify the data
SELECT id, first_name, last_name, is_active 
FROM public.driver 
ORDER BY id;
