CREATE OR REPLACE VIEW v_pomiary_detale AS
SELECT 
    p.pomiar_id,
    s.miasto,
    s.kraj,
    p.temperatura,
    p.wilgotnosc,
    p.opis_pogody,
    p.data_pomiaru
FROM pomiary p
JOIN stacje s ON p.stacja_id = s.stacja_id
WITH READ ONLY;
