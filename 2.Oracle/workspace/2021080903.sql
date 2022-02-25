    ** ������̺��� ���������÷��� �߰��Ͻÿ�
       �÷���          Ÿ��       NULL����
       RETIRE_DATE    DATE      
       
ALTER TABLE EMPLOYEES ADD RETIRE_DATE DATE;
COMMIT;

��뿹)��������� �ʿ��� �Լ� ���� ����
      - ��Ű���� : PKG_EMP
      - FN_GET_NAME : �����ȣ�� �Է¹޾� �̸��� ��ȯ�ϴ� �Լ�
      - PROC_NEW_EMP : �űԻ������ �Է� ���ν���(�����ȣ, LAST_NAME, �̸���, �Ի���, JOB_ID)
      - PROC_RETIRE_EMP : ������ó�� ���ν���(�����ȣ �Է�)
      
(��Ű������)
CREATE OR REPLACE PACKAGE PKG_EMP IS
    
    --�̸���ȯ �Լ�
    FUNCTION FN_GET_NAME(
        P_EID  IN EMPLOYEES.EMPLOYEE_ID    %TYPE)
        RETURN VARCHAR2;
    
    --�űԻ������ �Է�
    PROCEDURE PROC_NEW_EMP(
        P_EID  IN EMPLOYEES.EMPLOYEE_ID    %TYPE,
        P_LNAME IN EMPLOYEES.LAST_NAME      %TYPE,
        P_EMAIL IN EMPLOYEES.EMAIL          %TYPE,
--        P_HIRE_DATE IN EMPLOYEES.HIRE_DATE%TYPE �Ի����� �����̶�� ����
        P_JOB_ID IN JOBS.JOB_ID        %TYPE);
    
    --������ó��
    PROCEDURE PROC_RETIRE_EMP(
        P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE);
END PKG_EMP;

CREATE OR REPLACE PACKAGE BODY PKG_EMP IS
    FUNCTION FN_GET_NAME(
        P_EID  IN EMPLOYEES.EMPLOYEE_ID    %TYPE)
        RETURN VARCHAR2
    IS
        V_ENAME EMPLOYEES.EMP_NAME         %TYPE;
    BEGIN
        SELECT EMP_NAME INTO V_ENAME
          FROM EMPLOYEES
         WHERE EMPLOYEE_ID = P_EID;
         
        DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || P_EID);
        DBMS_OUTPUT.PUT_LINE('����� : ' || V_ENAME);
        DBMS_OUTPUT.PUT_LINE('-------------------');
    RETURN V_ENAME;
    END FN_GET_NAME;
    
    PROCEDURE PROC_NEW_EMP(
        P_EID  IN EMPLOYEES.EMPLOYEE_ID     %TYPE,
        P_LNAME IN EMPLOYEES.LAST_NAME      %TYPE,
        P_EMAIL IN EMPLOYEES.EMAIL          %TYPE,
--        P_HIRE_DATE IN EMPLOYEES.HIRE_DATE%TYPE �Ի����� �����̶�� ����
        P_JOB_ID IN JOBS.JOB_ID        %TYPE)
    IS
    BEGIN
        INSERT INTO EMPLOYEES(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID, EMP_NAME)
        VALUES(P_EID, P_LNAME, P_EMAIL, SYSDATE - 1, P_JOB_ID, P_LNAME || '�浿');
        COMMIT;
    END PROC_NEW_EMP;
    
    PROCEDURE PROC_RETIRE_EMP(
        P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
    IS
    BEGIN
        UPDATE EMPLOYEES
           SET RETIRE_DATE = SYSDATE
         WHERE EMPLOYEE_ID = P_EID;
        COMMIT;
    END PROC_RETIRE_EMP;
    
END PKG_EMP;

(����)

SELECT EMPLOYEE_ID, PKG_EMP.FN_GET_NAME(EMPLOYEE_ID)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 60;
 
EXECUTE PKG_EMP.PROC_NEW_EMP(250, 'ȫ', 'gdhong@gmail.com', 'FI_ACCOUNT');
EXECUTE PKG_EMP.PROC_RETIRE_EMP(150);

TRIGGER������ COMMIT�� �� �� ����