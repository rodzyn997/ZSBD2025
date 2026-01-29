-- TESTY

INSERT INTO stacje (stacja_id, miasto, kraj) VALUES (1, 'Warszawa', 'Polska');

SELECT * FROM stacje;
----------------------------------

BEGIN
    dodaj_pomiar(1, 25.5, 50, 1010, 'Test z DBeaver');
END;

SELECT * FROM pomiary;

SELECT * FROM v_pomiary_detale;
----------------------------------

BEGIN
    dodaj_pomiar(1, 50.0, 50, 1013, 'cieplo');
END;

BEGIN
    dodaj_pomiar(1, 22.0, 55); 
END;

UPDATE pomiary 
SET opis_pogody = 'Test Update' 
WHERE pomiar_id = (SELECT MAX(pomiar_id) FROM pomiary);

DELETE FROM pomiary WHERE temperatura = 22;

SELECT * FROM archiwum_pomiarow;

SELECT * FROM logi_systemowe WHERE tabela_nazwa = 'POMIARY' ORDER BY log_id DESC;
----------------------------------

BEGIN
    generuj_raport_miesieczny(1,2026);
END;

SELECT * FROM raporty_miesieczne;
----------------------------------
