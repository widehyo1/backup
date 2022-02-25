2021-0716-01)
  4. 변환함수
   - 특정 시점에서 다른 타입으로 일시적 형변환
   - TO_CHAR, TO_DATE, TO_NUMBER, TO_TIMESTAMP, CAST
   
   1)CAST(expr AS 타입)
    - 'expr'로 정의된 자료를 '타입' 형태로 일시적 형 변환
    
사용예)
    SELECT  CAST(SUBSTR(MEM_REGNO1,1,2) AS NUMBER) + 1900   AS  출생년도,
            EXTRACT(YEAR FROM SYSDATE) - (CAST(SUBSTR(MEM_REGNO1,1,2) AS NUMBER) + 1900)    AS  나이
    FROM    MEMBER
    WHERE   NOT MEM_REGNO1 LIKE '0%';
--    WHERE   NOT SUBSTR(MEM_REGNO1,1,1) = '0';
--    WHERE   NOT SUBSTR(MEM_REGNO2,1,1) IN('3','4'); 

데이터의 타입을 바꿀 수는 있지만 원하는 형식을 지정할 수 없기 때문에 다른 변환함수에 비해서 활용도가 떨어진다.

   2)TO_CHAR(expr[, fmt])
    - 주어진 자료 expr을 형식지정 문자열 fmt에 맞추어 문자열로 변형하여 반환
    - expr은 숫자, 날짜, 문자열(CHAR, CLOB=>VARCHAR2로) 타입의 자료
    - 영구적 형변환

fmt에 형식을 지정할 때는 반드시 ''안에 작성할 것, 이 안에 문자열을 포함한 형식을 지정할 때는 ''안에 "" 사용
CHAR와 CLOB를 VARCHAR2로 바꾸는 것은 허용하나 VARCHAR2를 VARCHAR2로 바꾸는 것은 오류 발생
원본의 타입을 변경한다(?)

    - 날짜형식지정문자열
    ----------------------------------------------------------------------------------------------------------------------
    형식지정문자열(타입)                의미                             사용예
    ----------------------------------------------------------------------------------------------------------------------
    CC(DATE)                         세기                             SELECT  TO_CHAR(SYSDATE,'CC')   FROM    DUAL;
    AD, BC(DATE)                     세기                             SELECT  TO_CHAR(SYSDATE,'CC BC YYYY"년"')   FROM    DUAL;
    YYYY,YYY,YY,Y(DATE)              년도                             SELECT  TO_CHAR(SYSDATE,'CC BC YY"년"')   FROM    DUAL;
    Q(DATE)                          분기                             SELECT  TO_CHAR(SYSDATE,'CC BC YYYY"년" Q"분기"')   FROM    DUAL;
    MONTH, MON(DATE)                 월                               SELECT  TO_CHAR(SYSDATE,'YYYY MON MONTH')   FROM    DUAL;
    MM, RM(DATE)                     월
    W, WW, WWW(DATE)                 주차                             SELECT  TO_CHAR(SYSDATE,'YYYY MM DD DDD J')   FROM    DUAL;
    DD, DDD, J(DATE)                 일                               SELECT  TO_CHAR(SYSDATE,'CC BC YYYY"년" Q"분기"')   FROM    DUAL;
    DAY, DY, D(DATE)                 요일                             SELECT  TO_CHAR(SYSDATE,'DAY DY D')   FROM    DUAL;
    AM, PM, A.M., P.M.(TIMESTAMP?)   오전/오후
    MI(TIMESTAMP?)                   분
    SS, SSSSS(TIMESTAMP?)            초
    "문자열"(CHAR, VARCHAR2)          직접 정의한 사용자정의 문자열

AM/FM 및 AD/BC는 오전오후/기원전기원후 형식으로 출력하라는 이야기지 AM을 쓰면 오전이 출력되고 AD를 쓰면 기원후가 출력되는 것이 아니다.
        해당시간을 판단하여 해당하는 표현을 출력함
MONTH, MON은 해당월의 숫자와 식별자 "월"을 출력
MM, RM은 각각 월을 두자리 숫자 / 로마자 형식으로 출력
W하나는 한 주에서 요일의 위치 일요일 1 월요일 2 ... 토요일 7
WW는 해당 월 내에서 해당 날짜의 주차를 (3월 3주차)
WWW는 해당 년도 내에서 해당 날짜의 주차를(2021년 34주차) 출력
DD는 해당 월 내에서 일자를 반환
DDD는 해당 년도 내에서 몇 번째 날인지 반환(2021년 253일째)
J는 기원전 어쩌구부터
DAY, DY, D는 요일을 반환 (O요일, 0, 1~7)
SSSSS는 오늘 0시 0분 0초부터 지금까지 경과한 시간을 초로 반환

    - 숫자형식지정문자열
    ----------------------------------------------------------------------------------------------------------------------
    형식지정문자열(타입)               의미                                사용예
    ----------------------------------------------------------------------------------------------------------------------
    9(NUMBER)                       숫자와 대응되어 유효숫자는 유효숫자를    SELECT TO_CHAR(2345, '99999') FROM DUAL;
                                    출력하고 무효의 0은 공백처리
    0(NUMBER)                       숫자와 대응되어 유효숫자는 유효숫자를    SELECT TO_CHAR(23.5567, '99') FROM DUAL;
                                    출력하고 무효의 0은 0을 출력
    $, L                            화폐기호 출력                         SELECT TO_CHAR(2345, 'L99,999') FROM DUAL;
    PR                              음수를 '<>'로 묶어 출력                SELECT TO_CHAR(-12345, '99,999PR')   FROM    DUAL;
    ,(COMMA)                        자리점
    .(DOT)                          소수점
    X                               16진수로 변환 출력                     SELECT TO_CHAR(1024, 'XXXX') FROM DUAL;
    ----------------------------------------------------------------------------------------------------------------------
    
9 : 유효숫자라면 출력하고 무효의 0은 공백처리 출력대상과 출력형식을 각 자리를 비교해서 유효숫자만 출력
0 : 0도 출력   /   쉽게 얘기하면 23을 0023처럼 쓰고 싶으면 TO_CHAR(23,'0000')쓰란 얘기다
이 9과 0을 소숫점과 함께 쓸 경우 소숫점아래 내가 0이나 9로 지정한 소수점자리까지 반올림하여 출력한다. '00.000'       <- 소수점 아래 4번째 자리에서 반올림

L은 LOCATE의 약자, 오라클 환경설정에서 설정한 화폐기호를 출력, 기본값은 아마 위치데이터 읽어서 사용할듯? 그게 이길지 환경설정이 이길지는 몰라 실험 "해줘"
SELECT TO_CHAR(2345, '99,999') + 10 FROM DUAL;          앞에서 계산한 문자열은 '2,345' 로 + 와 연산시 숫자로 바꿀 수 없어 계산불가 에러
SELECT TO_CHAR(2345, '99999') + 10 FROM DUAL;           앞에서 계산한 문자열은 '2345'로 +와 연산시 숫자2345로 변환되어 계산됨
이와 같은 원리로 L, $로 형식지정한 경우 변환된 것은 숫자로 변환할 수 없는 문자열, 연산할 수 없다.
PR은 음수를 <>로 묶어서 출력할 때
16진수로 변환하되 'XX...X' 자리 16진수로 출력, 출력대상이 해당자리 16진수로 표현할 수 있는 범위를 넘어서면 ##으로 출력

   3)TO_NUMBER(expr[,fmt])
    - 주어진 자료 'expr'의 값을 'fmt' 형식에 맞추어 숫자로 변환
    - 'expr'은 문자열 타입의 자료
    - 'fmt'는 모두 적용되지 않음(숫자로 형변환 가능한 형식만 적용가능)
    
사용예)
    SELECT  TO_NUMBER(12345, '9999900'),
--            TO_NUMBER(12345, '99,999'),                   에러발생! '12,345'라는 문자열을 숫자로 바꿀 수 없습니다(? 이거 맞나)
            TO_NUMBER(12345, '99999PR'),
--            TO_NUMBER(-12345, '99999PR')                  에러발생! '<12345>'라는 문자열을 숫자로 바꿀 수 없습니다(? 이거 맞나)
            TO_NUMBER(12345, '99999')
    FROM    DUAL;

    SELECT  TO_NUMBER('12345', '9999900'),
--            TO_NUMBER('12345', '99,999'),                   에러발생! '12,345'라는 문자열을 숫자로 바꿀 수 없습니다
            TO_NUMBER('12345', '99999PR'),
--            TO_NUMBER('-12345', '99999PR')                  에러발생! '<12345>'라는 문자열을 숫자로 바꿀 수 없습니다
            TO_NUMBER('12345', '99999')
    FROM    DUAL;

expr은 컬럼명이나 데이터가 들어감
어? TO_NUMBER의 expr에 그냥 숫자가 가능하네...  위 둘다 실행됨

   4)TO_DATE(expr[,fmt])
    - 주어진 자료 'expr'을 'fmt' 형식에 맞추어 날짜로 변환
    - 'expr'은 문자열 타입의 자료
    - 'fmt'은 모두 적용되지 않음(숫자(날짜?)로 형변환 가능한 형식만 적용 가능)
    - 원본자료가 날짜형식에 맞도록 제공되어야 함(년도 4자리, 월 2자리, 일 2자리)
    
사용예)
    SELECT  TO_DATE('20200320', 'YYYYMMDD'),
            TO_DATE('20200320', 'YYYY MM DD'),
--            TO_DATE('20200320', 'AM YYYYMMDD'),
--            TO_DATE('20200320', 'YYYY MONTH DD'),
            TO_DATE('20200331')
--            TO_DATE('20200332')
    FROM    DUAL;

쌍따옴표를 사용하는 2군데 1. 컬럼의 별칭 2. 사용자지정 형식      
   
자동형변환은 최소화 하는 것이 좋음(의도와 다른 결과 나옴)
연습할 때는 괜찮지만 실무에서는 반드시 문제가 생긴다고(망한다고) 생각하자.
개발자가 퇴근 못할 때: 배포할 때(테스트까지 다 한 이후 운용시킬 수 있는 시스템에 결합시킬 때) 오류 발생 多,
                    이직을 했더라도 개발 책임자라면 배포후 오류는 자신이 책임져야 함(나말고 없어서...)
함수 vs 프로시저 : 반환값의 유무차이
함수는 반환값이 있기 때문에 select, where, from절과 독립적인 곳에 모두 사용가능
프로시저는 독립적으로만 사용 가능
오라클의 최우선은 \\\\\<<<숫자>>>/////

관계형 데이터 모델링 프리미엄 가이드 - 김기창 지음, 위즈덤 마인드