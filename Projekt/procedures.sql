CREATE OR REPLACE PROCEDURE dodaj_pomiar(
    p_stacja_id IN NUMBER,
    p_temp IN NUMBER,
    p_wilgotnosc IN NUMBER,
    p_cisnienie IN NUMBER DEFAULT 1013,
    p_opis IN VARCHAR2 DEFAULT 'Nieznany'
) IS
    x_skok_temp EXCEPTION;
    v_czy_ok BOOLEAN;
BEGIN
    v_czy_ok := sprawdz_skok_temp(p_temp, p_stacja_id);

    IF NOT v_czy_ok THEN
        RAISE x_skok_temp;
    END IF;

    INSERT INTO pomiary (stacja_id, temperatura, wilgotnosc, cisnienie, opis_pogody)
    VALUES (p_stacja_id, p_temp, p_wilgotnosc, p_cisnienie, p_opis);

EXCEPTION
    WHEN x_skok_temp THEN
        RAISE_APPLICATION_ERROR(-20001, 'Błąd: Podejrzany skok temperatury!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Błąd bazy: ' || SQLERRM);
END;



CREATE OR REPLACE PROCEDURE generuj_raport_miesieczny(
    p_miesiac IN NUMBER, 
    p_rok IN NUMBER
) IS
BEGIN
    DELETE FROM raporty_miesieczne WHERE miesiac = p_miesiac AND rok = p_rok;

    INSERT INTO raporty_miesieczne (stacja_id, miesiac, rok, srednia_temp, max_temp, min_temp)
    SELECT 
        stacja_id,
        EXTRACT(MONTH FROM data_pomiaru),
        EXTRACT(YEAR FROM data_pomiaru),
        ROUND(AVG(temperatura), 2),
        MAX(temperatura),
        MIN(temperatura)
    FROM pomiary
    WHERE EXTRACT(MONTH FROM data_pomiaru) = p_miesiac 
      AND EXTRACT(YEAR FROM data_pomiaru) = p_rok
    GROUP BY stacja_id, EXTRACT(MONTH FROM data_pomiaru), EXTRACT(YEAR FROM data_pomiaru);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Raport wygenerowany.');
END;
