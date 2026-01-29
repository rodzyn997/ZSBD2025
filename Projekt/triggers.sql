CREATE OR REPLACE TRIGGER trg_archiwizuj_pomiary
BEFORE DELETE ON pomiary
FOR EACH ROW
BEGIN
    INSERT INTO archiwum_pomiarow (
        oryginalne_id, stacja_id, data_pomiaru, powod_usuniecia
    )
    VALUES (
        :OLD.pomiar_id, :OLD.stacja_id, :OLD.data_pomiaru, 'Usunięcie ręczne'
    );
END;



CREATE OR REPLACE TRIGGER trg_loguj_pomiary
AFTER INSERT OR UPDATE OR DELETE ON pomiary 
FOR EACH ROW
DECLARE
    v_operacja VARCHAR2(20); 
    v_id NUMBER; 
BEGIN
    IF INSERTING THEN
        v_operacja := 'INSERT';
        v_id := :NEW.pomiar_id; 
    ELSIF UPDATING THEN
        v_operacja := 'UPDATE';
        v_id := :NEW.pomiar_id; 
    ELSIF DELETING THEN         
        v_operacja := 'DELETE';
        v_id := :OLD.pomiar_id; 
    END IF;

    INSERT INTO logi_systemowe (uzytkownik, operacja, tabela_nazwa, szczegoly)
    VALUES (USER, v_operacja, 'POMIARY', 'ID: ' || v_id);
END;
