---------------------------------- Payment Card Table ---------------------
CREATE SEQUENCE ror.payment_card_id_seq;

ALTER SEQUENCE ror.payment_card_id_seq OWNER TO rordev;
	
CREATE TABLE ror.payment_card
(
    id integer NOT NULL DEFAULT nextval('payment_card_id_seq'::regclass),	
	service character varying(30),
	paymentGroupReference  character varying(20),
	paymentReference  character varying(30),
	ccdReference character varying(30),
	caseReference character varying(36),
	paymentCreatedDateTime character varying(30),
	paymentStatusUpdatedDateTime character varying(30),
	paymentStatus character varying(15),
	paymentChannel character varying(20),
	paymentMethod character varying(20),
	paymentAmount integer,
	siteId  character varying(20),
	feeCode character varying(20),
	version character varying(3),
	calculatedAmount integer,
	memoLine character varying(100),
	nac character varying(20),
	feeVolume character varying(10),
    CONSTRAINT payment_card_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.payment_card OWNER to rordev;

---------------------------------- Divorce Table ---------------------
CREATE SEQUENCE ror.divorce_id_seq;

ALTER SEQUENCE ror.divorce_id_seq OWNER TO rordev;

CREATE TABLE ror.divorce_data
(
    id integer NOT NULL DEFAULT nextval('divorce_id_seq'::regclass),	
	matricDate character varying(30),	
	matric  character varying(100),
	request integer,
    CONSTRAINT divorce_data_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.divorce_data OWNER to rordev;

---------------------------------- Probate Table ---------------------
CREATE SEQUENCE ror.probate_id_seq;

ALTER SEQUENCE ror.probate_id_seq OWNER TO rordev;

CREATE TABLE ror.probate_data
(
    id integer NOT NULL DEFAULT nextval('probate_id_seq'::regclass),	
	matricDate character varying(30),	
	matric  character varying(100),
	request integer,
    CONSTRAINT probate_data_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.probate_data OWNER to rordev;

---------------------------------- SCSS Table ---------------------
CREATE SEQUENCE ror.scss_id_seq;

ALTER SEQUENCE ror.scss_id_seq OWNER TO rordev;

CREATE TABLE ror.scss_data
(
    id integer NOT NULL DEFAULT nextval('scss_id_seq'::regclass),
	typeId character varying(20),	
	caseReference character varying(30),	
	sms  character varying(20),
	email  character varying(50),
	region  character varying(50),
	benefitType  character varying(50),
	benefitCode  character varying(50),
	hearingType  character varying(50),
	venuName  character varying(50),
    CONSTRAINT scss_data_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.scss_data OWNER to rordev;

---------------------------------- Credit Account Payment ---------------------
CREATE SEQUENCE ror.payment_credit_account_id_seq;

ALTER SEQUENCE ror.payment_credit_account_id_seq OWNER TO rordev;

CREATE TABLE ror.payment_credit_account
(
    id integer NOT NULL DEFAULT nextval('payment_credit_account_id_seq'::regclass),	
	service character varying(30),
	paymentGroupReference  character varying(20),
	paymentReference  character varying(30),
	ccdReference character varying(30),
	caseReference character varying(36),
	organisationName character varying(160),
	customerInternalReference character varying(20),
	pbaNumber character varying(20),	
	paymentCreatedDateTime character varying(30),
	paymentStatusUpdatedDateTime character varying(30),	
	paymentStatus character varying(15),
	paymentChannel character varying(20),
	paymentMethod character varying(20),
	paymentAmount integer,
	siteId  character varying(20),
	feeCode character varying(20),
	version character varying(3),
	calculatedAmount integer,
	memoLine character varying(100),
	nac character varying(20),
	feeVolume character varying(10),   
    CONSTRAINT payment_credit_account_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.payment_credit_account OWNER to rordev;


---------------------------------Incident Beta-----------------------
CREATE SEQUENCE ror.incident_beta_id_seq;

ALTER SEQUENCE ror.incident_beta_id_seq OWNER TO rordev;


CREATE TABLE ror.incident_beta
(
    id integer NOT NULL DEFAULT nextval('incident_beta_id_seq'::regclass),	
	priority character varying(100),
	incidentState character varying(100),
	state character varying(100),
	shortDescription character varying(500),
	category character varying(500),
	subCategory character varying(500),
	description character varying(20000),
	assignmentGroup character varying(300),
	thirdPartysupportReference character varying(300),
	madeSla boolean,
	serviceOffering character varying(10),
	servicePortfolio character varying(10),
	service character varying(100),
	contactType character varying(100),
	createdDateTime character varying(30),
	updatedDateTime character varying(30),
	resolveTime character varying(30),
	resolved character varying(30),	
    CONSTRAINT incident_beta_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.incident_beta OWNER to rordev;

-------------------------------CMC Cases-----------------------------
CREATE SEQUENCE ror.cmc_cases_id_seq;
ALTER SEQUENCE ror.cmc_cases_id_seq OWNER TO rordev;

CREATE TABLE ror.cmc_cases
(
    id integer NOT NULL DEFAULT nextval('cmc_cases_id_seq'::regclass),	
	submissionDate character varying(30),
	claimTotal integer,
	claimfee integer,
	status character varying(50),
    CONSTRAINT cmc_cases_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.cmc_cases OWNER to rordev;
-------------------------------CMC Defence-----------------------------
CREATE SEQUENCE ror.cmc_defence_id_seq;
ALTER SEQUENCE ror.cmc_defence_id_seq OWNER TO rordev;

CREATE TABLE ror.cmc_defence
(
    id integer NOT NULL DEFAULT nextval('cmc_defence_id_seq'::regclass),	
	submissionDate character varying(30),
	mediationPaid character varying(10),	
	status character varying(50),
    CONSTRAINT cmc_defence_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.cmc_defence OWNER to rordev;
-------------------------------CMC Judgement---------------------------
CREATE SEQUENCE ror.cmc_judgement_id_seq;
ALTER SEQUENCE ror.cmc_judgement_id_seq OWNER TO rordev;

CREATE TABLE ror.cmc_judgement
(
    id integer NOT NULL DEFAULT nextval('cmc_judgement_id_seq'::regclass),	
	requestedDate character varying(30),
	payDetail character varying(20),	
	populationConfirmation character varying(50),
	errorsEncountered character varying(300),
    CONSTRAINT cmc_judgement_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.cmc_judgement OWNER to rordev;

-------------------------------Beta Cases---------------------------
CREATE SEQUENCE ror.beta_cases_id_seq;
ALTER SEQUENCE ror.beta_cases_id_seq OWNER TO rordev;

CREATE TABLE ror.beta_cases
(
    id integer NOT NULL DEFAULT nextval('beta_cases_id_seq'::regclass),	
	priority character varying(100),	
	state character varying(100),
	shortDescription character varying(500),
	description character varying(20000),
	category character varying(500),	
	assignmentGroup character varying(300),
	numbers character varying(100),	
	service character varying(100),
	serviceOffering character varying(10),
	created character varying(30),
	updated character varying(30),	
    CONSTRAINT incident_beta_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ror.beta_cases OWNER to rordev;