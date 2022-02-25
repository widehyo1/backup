CREATE OR REPLACE VIEW V_LODGE_LIST AS
SELECT A.LOD_NO, A.LOD_NM, B.RATING, C.PAVG
  FROM LODGE A, 
       (SELECT LOD_NO, NVL(AVG(BOD_RATING),0) AS RATING
          FROM LODGE_BOARD
         WHERE BOD_CODE = 1
         GROUP BY LOD_NO) B,
       (SELECT LOD_NO, NVL(AVG(RO_N_PRICE),0) AS PAVG
          FROM ROOM
         GROUP BY LOD_NO) C
 WHERE A.LOD_NO = B.LOD_NO
       AND B.LOD_NO = C.LOD_NO
  WITH READ ONLY;
  
DROP VIEW V_LODGE_LIST;

SELECT * FROM V_LODGE_LIST;

CREATE OR REPLACE VIEW V_CONSTRAINT AS
SELECT A.CITY_CODE AS CITY, A.PROV_CODE AS PROV, E.RO_MIN_CAP AS MINCAP, E.RO_MAX_CAP AS MAXCAP,
       B.RO_N_PRICE AS NPRICE, B.RO_A_PRICE AS APRICE, C.RESV_SDATE AS SDATE, C.RESV_EDATE AS EDATE, D.RATING AS RATING
  FROM LODGE A, ROOM B, RESERVATION C, V_LODGE_LIST D, ROOM_CODE E
 WHERE A.LOD_NO = B.LOD_NO
       AND B.RO_NO = C.RO_NO
       AND B.LOD_NO = C.LOD_NO
       AND A.LOD_NO = D.LOD_NO
       AND B.RO_CODE = E.RO_CODE
WITH READ ONLY;

SELECT * FROM V_CONSTRAINT;
   
CREATE OR REPLACE TRIGGER TG_RESV_RESH_INSERT
    AFTER INSERT ON RESERVATION
    FOR EACH ROW
DECLARE
    V_CNT   NUMBER  := 0;
    V_ODATE DATE;
BEGIN
    SELECT NVL(COUNT(*) + 1,1) INTO V_CNT
      FROM RESERVATION_HISTORY;
    
    SELECT ORD_DATE INTO V_ODATE
      FROM TBL_ORDER
     WHERE :NEW.ORD_NO = ORD_NO;
    
    INSERT INTO RESERVATION_HISTORY(RESH_NO, RESH_UPDATE, RESV_NO, ORD_NO, LOD_NO, RO_NO, RESV_SDATE, RESV_EDATE, RESV_CODE, RESV_CAP, RESV_SUM, ORD_DATE)
    VALUES(V_CNT, V_ODATE, :NEW.RESV_NO, :NEW.ORD_NO, :NEW.LOD_NO, :NEW.RO_NO, :NEW.RESV_SDATE, :NEW.RESV_EDATE, :NEW.RESV_CODE, :NEW.RESV_CAP, :NEW.RESV_SUM, V_ODATE);
    
END;

INSERT INTO TBL_ORDER VALUES(3,1,660000,TO_DATE('20210817'));
INSERT INTO RESERVATION VALUES(4,3,2,201,TO_DATE('20210820'),TO_DATE('20210830'),1,2,660000);
UPDATE RESERVATION
   SET RESV_SDATE = TO_DATE('20210826'),
       RESV_SUM = 300000;


INSERT INTO TBL_ORDER VALUES(4,1,660000,TO_DATE('20210818'));
INSERT INTO RESERVATION VALUES(5,3,2,201,TO_DATE('20210820'),TO_DATE('20210830'),1,2,660000);

delete tbl_order;
delete reservation;
delete reservation_history;

SELECT NVL(COUNT(*) + 1,1)
      FROM RESERVATION_HISTORY;

CREATE OR REPLACE TRIGGER TG_RESV_RESH_UPDATE
    AFTER UPDATE OF RESV_SDATE, RESV_EDATE, RESV_CODE, RESV_CAP, RESV_SUM ON RESERVATION
    FOR EACH ROW
DECLARE
    V_CNT       NUMBER  := 0;
    V_UPDATE    DATE;
    V_ODATE DATE;
BEGIN
    SELECT NVL(COUNT(*) + 1,1) INTO V_CNT
      FROM RESERVATION_HISTORY;
    
    SELECT SYSDATE INTO V_UPDATE FROM DUAL;
    
    SELECT ORD_DATE INTO V_ODATE
      FROM TBL_ORDER
     WHERE :NEW.ORD_NO = ORD_NO;
    
    INSERT INTO RESERVATION_HISTORY(RESH_NO, RESH_UPDATE, RESV_NO, ORD_NO, LOD_NO, RO_NO, RESV_SDATE, RESV_EDATE, RESV_CODE, RESV_CAP, RESV_SUM, ORD_DATE)
    VALUES(V_CNT, V_UPDATE, :NEW.RESV_NO, :NEW.ORD_NO, :NEW.LOD_NO, :NEW.RO_NO, :NEW.RESV_SDATE, :NEW.RESV_EDATE, :NEW.RESV_CODE, :NEW.RESV_CAP, :NEW.RESV_SUM, V_ODATE);

END;

