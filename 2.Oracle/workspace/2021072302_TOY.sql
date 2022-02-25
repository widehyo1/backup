사용예)거래처 '마르죠'와 동일한 지역(광역시도)에 소재하고 있는 거래처 정보를 조회하시오
      ALIAS는 거래처코드, 거래처명, 주소, 담당자이다.

SELECT B.BUYER_ID AS "거래처코드",
       B.BUYER_NAME AS "거래처명",
       B.BUYER_ADD1 || ' ' || B.BUYER_ADD2 AS "주소",
       B.BUYER_CHARGER AS "담당자"
  FROM BUYER A, BUYER B
 WHERE A.BUYER_NAME = '마르죠'
       AND B.BUYER_ADD1 <> A.BUYER_ADD1;

SELECT B.BUYER_ID AS "거래처코드",
       B.BUYER_NAME AS "거래처명",
       B.BUYER_ADD1 || ' ' || B.BUYER_ADD2 AS "주소",
       B.BUYER_CHARGER AS "담당자"
  FROM BUYER A
 INNER JOIN BUYER B ON(A.BUYER_NAME = '마르죠'
       AND B.BUYER_ADD1 <> A.BUYER_ADD1);
      
사용예)사원번호 108번 사원과 같은 부서에 속한 사원의 사원번호, 사원명, 부서명, 직무코드를 조회하시오      

SELECT B.EMPLOYEE_ID AS "사원번호",
       B.EMP_NAME AS "사원명",
       C.DEPARTMENT_NAME AS "부서명",
       B.JOB_ID AS "직무코드"
  FROM HR.EMPLOYEES A
 INNER JOIN HR.EMPLOYEES B ON(A.EMPLOYEE_ID = 108
       AND A.DEPARTMENT_ID = B.DEPARTMENT_ID)
 INNER JOIN HR.DEPARTMENTS C ON(B.DEPARTMENT_ID = C.DEPARTMENT_ID);
 
SELECT B.EMPLOYEE_ID AS "사원번호",
       B.EMP_NAME AS "사원명",
       C.DEPARTMENT_NAME AS "부서명",
       B.JOB_ID AS "직무코드"
  FROM HR.EMPLOYEES A, HR.EMPLOYEES B, HR.DEPARTMENTS C
 WHERE A.EMPLOYEE_ID =108
       AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
       AND B.DEPARTMENT_ID = C.DEPARTMENT_ID;

사용예)2005년 1월 모든 상품별 매입현황을 조회하시오.
      출력할 컬럼은 상품코드, 상품명, 매입수량, 매입금액이다.

SELECT A.PROD_ID AS "상품코드",
       A.PROD_NAME AS "상품명",
       NVL(SUM(B.BUY_QTY),0) AS "매입수량",
       NVL(SUM(B.BUY_QTY * A.PROD_PRICE),0) AS "매입금액"
  FROM PROD A
  LEFT OUTER JOIN BUYPROD B ON(A.PROD_ID = B.BUY_PROD
       AND B.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
 GROUP BY A.PROD_ID, A.PROD_NAME
 ORDER BY 1;

SELECT A.PROD_ID AS "상품코드",
       A.PROD_NAME AS "상품명",
       NVL(SUM(B.BUY_QTY),0) AS "매입수량",
       NVL(SUM(B.BUY_QTY * A.PROD_PRICE),0) AS "매입금액"
  FROM PROD A
  LEFT OUTER JOIN BUYPROD B ON(A.PROD_ID = B.BUY_PROD
       AND B.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
 GROUP BY A.PROD_ID, A.PROD_NAME
 ORDER BY 1;

SELECT B.PROD_ID AS "상품코드",
       B.PROD_NAME AS "상품명",
       NVL(SUM(A.BQTY),0) AS "매입수량",
       NVL(SUM(A.BQTY * B.PROD_PRICE),0) AS "매입금액"
  FROM (SELECT BUY_QTY AS BQTY,
               BUY_PROD AS BID
          FROM BUYPROD
         WHERE BUY_DATE  BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')) A, PROD B
 WHERE A.BID(+) = B.PROD_ID
 GROUP BY B.PROD_ID, B.PROD_NAME;

사용예)모든 부서별 사원수를 조회하시오.      
SELECT NVL(LPAD(TO_CHAR(B.DEPARTMENT_ID),3),'CEO') AS "부서번호",
       B.DEPARTMENT_NAME AS "부서명",
       COUNT(A.EMPLOYEE_ID) AS "사원수"
  FROM HR.EMPLOYEES A
  FULL OUTER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID)
 GROUP BY NVL(LPAD(TO_CHAR(B.DEPARTMENT_ID),3),'CEO'), B.DEPARTMENT_NAME;

사용예)2005년 4월 모든 상품에 대한 판매현황을 조회하시오
      출력할 내용은 상품코드, 상품명, 판매수량, 판매금액이다.

SELECT B.PROD_ID AS "상품코드",
       B.PROD_NAME AS "상품명",
       NVL(SUM(A.CQTY),0) AS "판매수량",
       NVL(SUM(A.CQTY * B.PROD_PRICE),0) AS "판매금액"
FROM    (SELECT CART_PROD AS CID,
               CART_QTY AS CQTY
          FROM CART
         WHERE SUBSTR(CART_NO,1,6) = '200504') A, PROD B
WHERE A.CID (+)= B.PROD_ID
GROUP BY B.PROD_ID, B.PROD_NAME
ORDER BY 1;


SELECT B.PROD_ID AS "상품코드",
       B.PROD_NAME AS "상품명",
       NVL(SUM(A.CART_QTY),0) AS "판매수량",
       NVL(SUM(A.CART_QTY * B.PROD_PRICE),0) AS "판매금액"
  FROM CART A
 RIGHT OUTER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
       AND SUBSTR(A.CART_NO,1,6) = '200504')
 GROUP BY B.PROD_ID, B.PROD_NAME
 ORDER BY 1;
      
사용예)2005년 4월 모든 상품에 대한 매입합계와 매출합계를 조회하시오

SELECT B.PROD_ID AS "상품코드",
       B.PROD_NAME AS "상품명",
       NVL(SUM(A.CART_QTY * B.PROD_PRICE),0) AS "판매금액",
       NVL(SUM(A.CART_QTY * B.PROD_PRICE),0) AS "매출합계"
  FROM CART A
 RIGHT OUTER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
       AND SUBSTR(A.CART_NO,1,6) = '200504')
  LEFT OUTER JOIN BUYPROD C ON(B.PROD_ID = C.BUY_PROD
       AND C.BUY_DATE BETWEEN TO_DATE('20050401') AND LAST_DAY(TO_DATE('20050401')))
 GROUP BY B.PROD_ID, B.PROD_NAME
 ORDER BY 1;
