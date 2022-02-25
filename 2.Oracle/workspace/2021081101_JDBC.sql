/* MEMBER2 */
CREATE TABLE MEMBER (
	MEM_NO NUMBER NOT NULL, /* 회원번호 */
	MEM_ID VARCHAR2(30) /* 회원아이디 */
);

DROP TABLE MEMBER;

CREATE UNIQUE INDEX PK_MEMBER
	ON MEMBER (
		MEM_NO ASC
	);

ALTER TABLE MEMBER
	ADD
		CONSTRAINT PK_MEMBER
		PRIMARY KEY (
			MEM_NO
		);

/* 숙박시설 */
CREATE TABLE LODGE (
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	LOD_CODE NUMBER NOT NULL, /* 숙박시설구분코드 */
	LOD_NM VARCHAR2(100), /* 숙박시설명 */
	LOD_ADD_CITY VARCHAR2(50), /* 시 */
	LOD_ADD_PROV VARCHAR2(50), /* 구 */
	LOD_ADD_DETAIL VARCHAR2(200), /* 상세주소 */
	LOD_DETAIL VARCHAR2(200) /* 세부사항 */
);

CREATE UNIQUE INDEX PK_LODGE
	ON LODGE (
		LOD_NO ASC,
		LOD_CODE ASC
	);

ALTER TABLE LODGE
	ADD
		CONSTRAINT PK_LODGE
		PRIMARY KEY (
			LOD_NO,
			LOD_CODE
		);

/* 소유 */
CREATE TABLE TABLE (
	MEM_NO NUMBER NOT NULL, /* 회원번호 */
	LOD_NO NUMBER NOT NULL /* 숙박시설번호 */
);

CREATE UNIQUE INDEX PK_TABLE
	ON TABLE (
		MEM_NO ASC,
		LOD_NO ASC
	);

ALTER TABLE TABLE
	ADD
		CONSTRAINT PK_TABLE
		PRIMARY KEY (
			MEM_NO,
			LOD_NO
		);

/* 숙박시설구분 */
CREATE TABLE LODGE_CODE (
	LOD_CODE NUMBER NOT NULL, /* 숙박시설구분코드 */
	LOD_NM VARCHAR2(30) /* 숙박시설구분명 */
);

CREATE UNIQUE INDEX PK_LODGE_CODE
	ON LODGE_CODE (
		LOD_CODE ASC
	);

ALTER TABLE LODGE_CODE
	ADD
		CONSTRAINT PK_LODGE_CODE
		PRIMARY KEY (
			LOD_CODE
		);

/* 객실 */
CREATE TABLE ROOM (
	RO_NO VARCHAR2(30) NOT NULL, /* 방번호 */
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	RO_MIN_CAP NUMBER DEFAULT 1, /* 최소수용인원 */
	RO_MAX_CAP NUMBER DEFAULT 32, /* 최대수용인원 */
	RO_PRICE NUMBER NOT NULL, /* 가격(1박기준) */
	RO_AVAL NUMBER DEFAULT 1 NOT NULL, /* 사용가능여부 */
	RO_GRADE VARCHAR2(30) NOT NULL, /* 방등급 */
	RO_CIN TIMESTAMP, /* 체크인시간 */
	RO_OUT TIMESTAMP, /* 체크아웃시간 */
	RO_DETAIL VARCHAR2(500) /* 객실상세정보 */
);

CREATE UNIQUE INDEX PK_ROOM
	ON ROOM (
		RO_NO ASC,
		LOD_NO ASC
	);

ALTER TABLE ROOM
	ADD
		CONSTRAINT PK_ROOM
		PRIMARY KEY (
			RO_NO,
			LOD_NO
		);

/* 예약 */
CREATE TABLE RESERVATION (
	RESV_NO NUMBER NOT NULL, /* 예약번호 */
	MEM_NO NUMBER NOT NULL, /* 회원번호 */
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	RO_NO NUMBER NOT NULL, /* 방번호(호수) */
	RESV_SDATE DATE NOT NULL, /* 예약시작날짜 */
	RESV_EDATE DATE NOT NULL, /* 예약종료날짜 */
	RESV_CODE NUMBER, /* 예약상태구분코드 */
	RESV_CAP NUMBER NOT NULL, /* 인원수 */
	RESV_SUM NUMBER /* 산출가격 */
);

CREATE UNIQUE INDEX PK_RESERVATION
	ON RESERVATION (
		RESV_NO ASC
	);

ALTER TABLE RESERVATION
	ADD
		CONSTRAINT PK_RESERVATION
		PRIMARY KEY (
			RESV_NO
		);

/* 예약이력 */
CREATE TABLE RESERVATION_HISTORY (
	RESH_NO NUMBER NOT NULL, /* 예약이력번호 */
	RESH_UPDATE DATE NOT NULL, /* 예약이력갱신날짜 */
	RESV_NO NUMBER NOT NULL, /* 예약번호 */
	MEM_NO NUMBER NOT NULL, /* 회원번호 */
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	RO_NO NUMBER NOT NULL, /* 방번호(호수) */
	RESV_SDATE DATE NOT NULL, /* 예약시작날짜 */
	RESV_EDATE DATE NOT NULL, /* 예약종료날짜 */
	RESV_CODE NUMBER NOT NULL, /* 예약상태구분코드 */
	RESV_CAP NUMBER NOT NULL, /* 인원수 */
	RESV_SUM NUMBER /* 산출가격 */
);

CREATE UNIQUE INDEX PK_RESERVATION_HISTORY
	ON RESERVATION_HISTORY (
		RESH_NO ASC,
		RESH_UPDATE ASC
	);

ALTER TABLE RESERVATION_HISTORY
	ADD
		CONSTRAINT PK_RESERVATION_HISTORY
		PRIMARY KEY (
			RESH_NO,
			RESH_UPDATE
		);

/* 숙박시설게시글 */
CREATE TABLE LODGE_BOARD (
	BOD_NO NUMBER NOT NULL, /* 게시글번호 */
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	BOD_TITLE VARCHAR2(200) NOT NULL, /* 제목 */
	BOD_CONTENT VARCHAR2(2000) NOT NULL, /* 내용 */
	BOD_REG_DATE DATE DEFAULT SYSDATE, /* 작성일 */
	MEM_NO NUMBER NOT NULL, /* 회원번호 */
	BOD_RATING NUMBER, /* 평점 */
	BOD_CODE NUMBER DEFAULT 1 NOT NULL /* 게시글구분코드 */
);

CREATE UNIQUE INDEX PK_LODGE_BOARD
	ON LODGE_BOARD (
		BOD_NO ASC,
		LOD_NO ASC
	);

ALTER TABLE LODGE_BOARD
	ADD
		CONSTRAINT PK_LODGE_BOARD
		PRIMARY KEY (
			BOD_NO,
			LOD_NO
		);

/* 장바구니 */
CREATE TABLE TABLE2 (
);

/* 숙박시설게시글 */
CREATE TABLE LODGE_BOARD2 (
	BOD_NO NUMBER NOT NULL, /* 게시글번호 */
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	BOD_TITLE VARCHAR2(200) NOT NULL, /* 제목 */
	BOD_CONTENT VARCHAR2(2000) NOT NULL, /* 내용 */
	BOD_REG_DATE DATE DEFAULT SYSDATE, /* 작성일 */
	MEM_NO NUMBER NOT NULL, /* 회원번호 */
	BOD_RATING NUMBER, /* 평점 */
	BOD_CODE NUMBER DEFAULT 1 NOT NULL /* 게시글구분코드 */
);

CREATE UNIQUE INDEX PK_LODGE_BOARD2
	ON LODGE_BOARD2 (
		BOD_NO ASC,
		LOD_NO ASC
	);

ALTER TABLE LODGE_BOARD2
	ADD
		CONSTRAINT PK_LODGE_BOARD2
		PRIMARY KEY (
			BOD_NO,
			LOD_NO
		);

/*  객실가격이력 */
CREATE TABLE ROOM_HISTORY (
	RO_NO NUMBER NOT NULL, /* 방번호(호수) */
	LOD_NO NUMBER NOT NULL, /* 숙박시설번호 */
	RO_SDATE DATE NOT NULL, /* 시작날짜 */
	RO_EDATE DATE DEFAULT 9999-12-31, /* 종료날짜 */
	RO_PRICE NUMBER NOT NULL /* 가격(1박기준) */
);

CREATE UNIQUE INDEX PK_ROOM_HISTORY
	ON ROOM_HISTORY (
		RO_SDATE ASC
	);

ALTER TABLE ROOM_HISTORY
	ADD
		CONSTRAINT PK_ROOM_HISTORY
		PRIMARY KEY (
			RO_SDATE
		);

/* 장바구니 */
CREATE TABLE CART (
	CART_NO NUMBER NOT NULL, /* 장바구니 번호 */
	RO_PRICE NUMBER, /* 가격 */
	RESV_SDATE DATE, /* 예약시작날짜 */
	RESV_EDATE DATE, /* 예약종료날짜 */
	RESV_SUM NUMBER, /* 산출가격 */
	RESV_CAP NUMBER /* 인원수 */
);

CREATE UNIQUE INDEX PK_CART
	ON CART (
		CART_NO ASC
	);

ALTER TABLE CART
	ADD
		CONSTRAINT PK_CART
		PRIMARY KEY (
			CART_NO
		);

ALTER TABLE TBL_WORK
	ADD
		CONSTRAINT FK_TBL_EMP_TO_TBL_WORK
		FOREIGN KEY (
			emp_id
		)
		REFERENCES TBL_EMP (
			emp_id
		);

ALTER TABLE TBL_WORK
	ADD
		CONSTRAINT FK_TBL_SITE_TO_TBL_WORK
		FOREIGN KEY (
			SITE_ID
		)
		REFERENCES TBL_SITE (
			SITE_ID
		);

ALTER TABLE TBL_MATERIAL
	ADD
		CONSTRAINT FK_TBL_SITE_TO_TBL_MATERIAL
		FOREIGN KEY (
			SITE_ID
		)
		REFERENCES TBL_SITE (
			SITE_ID
		);