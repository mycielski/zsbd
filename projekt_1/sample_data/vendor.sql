-- Insert vendors (fuel companies) with appropriate tax IDs for each country
INSERT INTO public.vendor (name, country, tax_id)
VALUES
    -- Shell in Poland and Ireland
    ('Shell', 'Poland', 'PL5270204212'),        -- Polish VAT format
    ('Shell', 'Ireland', 'IE8473625K'),         -- Irish VAT format
    
    -- BP in Poland and Germany
    ('BP', 'Poland', 'PL5272525727'),           -- Polish VAT format
    ('BP', 'Germany', 'DE123456789'),           -- German VAT format
    
    -- Other major vendors
    ('Circle K', 'Poland', 'PL7010411362'),     -- Polish VAT format
    ('Total', 'France', 'FR32542051180');       -- French VAT format

-- Verify the results
SELECT name, country, tax_id 
FROM vendor 
ORDER BY name, country;

