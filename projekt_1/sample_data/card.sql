DO $$
DECLARE
    driver_record RECORD;
    vendor_record RECORD;
    card_number VARCHAR;
    cards_assigned INTEGER;
    attempts INTEGER;
BEGIN
    -- First ensure every driver has at least one card
    FOR driver_record IN (SELECT id FROM driver WHERE id <= 25 AND is_active = true) LOOP
        cards_assigned := 0;
        attempts := 0;
        
        WHILE cards_assigned = 0 AND attempts < 10 LOOP -- try up to 10 times to assign a card
            FOR vendor_record IN (SELECT * FROM vendor ORDER BY random()) LOOP
                BEGIN
                    -- Generate card number based on vendor
                    card_number := CASE 
                        WHEN vendor_record.name = 'Shell' THEN 
                            'SH' || LPAD(floor(random() * 999999999)::text, 9, '0')
                        WHEN vendor_record.name = 'BP' THEN 
                            'BP' || LPAD(floor(random() * 99999999)::text, 8, '0')
                        WHEN vendor_record.name = 'Circle K' THEN 
                            'CK' || LPAD(floor(random() * 9999999999)::text, 10, '0')
                        WHEN vendor_record.name = 'Total' THEN 
                            'TF' || LPAD(floor(random() * 999999999)::text, 9, '0')
                    END;

                    -- Try to insert the card
                    INSERT INTO card (number, owner_id, vendor_id)
                    VALUES (card_number, driver_record.id, vendor_record.id);
                    
                    cards_assigned := cards_assigned + 1;
                    EXIT WHEN cards_assigned > 0; -- Exit vendor loop once we succeed

                EXCEPTION WHEN unique_violation THEN
                    -- Just continue to next vendor if this one fails
                    CONTINUE;
                END;
            END LOOP;
            attempts := attempts + 1;
        END LOOP;
    END LOOP;

    -- Try to add some additional cards (with 30% chance)
    FOR driver_record IN (SELECT id FROM driver WHERE id <= 25 AND is_active = true) LOOP
        FOR vendor_record IN (SELECT * FROM vendor ORDER BY random()) LOOP
            IF random() < 0.3 THEN -- 30% chance for additional card
                BEGIN
                    card_number := CASE 
                        WHEN vendor_record.name = 'Shell' THEN 
                            'SH' || LPAD(floor(random() * 999999999)::text, 9, '0')
                        WHEN vendor_record.name = 'BP' THEN 
                            'BP' || LPAD(floor(random() * 99999999)::text, 8, '0')
                        WHEN vendor_record.name = 'Circle K' THEN 
                            'CK' || LPAD(floor(random() * 9999999999)::text, 10, '0')
                        WHEN vendor_record.name = 'Total' THEN 
                            'TF' || LPAD(floor(random() * 999999999)::text, 9, '0')
                    END;

                    INSERT INTO card (number, owner_id, vendor_id)
                    VALUES (card_number, driver_record.id, vendor_record.id);

                EXCEPTION WHEN unique_violation THEN
                    -- Ignore violations and continue
                    CONTINUE;
                END;
            END IF;
        END LOOP;
    END LOOP;
END $$;

-- Verify the results
SELECT 
    d.id as driver_id,
    d.first_name || ' ' || d.last_name as driver_name,
    array_agg(v.name || ' (' || v.country || ')') as cards_from_vendors,
    COUNT(*) as total_cards
FROM driver d
JOIN card c ON d.id = c.owner_id
JOIN vendor v ON c.vendor_id = v.id
WHERE d.id <= 25
GROUP BY d.id, d.first_name, d.last_name
ORDER BY d.id;
