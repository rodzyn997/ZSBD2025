CREATE OR REPLACE FUNCTION sprawdz_skok_temp(
    p_nowa_temp IN NUMBER, 
    p_stacja_id IN NUMBER
) RETURN BOOLEAN IS
    v_ostatnia_temp NUMBER;
BEGIN
    BEGIN
        SELECT temperatura INTO v_ostatnia_temp 
        FROM (
            SELECT temperatura FROM pomiary 
            WHERE stacja_id = p_stacja_id 
            ORDER BY data_pomiaru DESC
        ) WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN TRUE; 
    END;

    IF v_ostatnia_temp IS NOT NULL AND ABS(p_nowa_temp - v_ostatnia_temp) > 20 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
