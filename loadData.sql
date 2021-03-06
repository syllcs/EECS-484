INSERT INTO USERS (USER_ID, FIRST_NAME, LAST_NAME, YEAR_OF_BIRTH, MONTH_OF_BIRTH, DAY_OF_BIRTH, GENDER)
SELECT DISTINCT USER_ID, FIRST_NAME, LAST_NAME, YEAR_OF_BIRTH, MONTH_OF_BIRTH, DAY_OF_BIRTH, GENDER
FROM jsoren.PUBLIC_USER_INFORMATION;


INSERT INTO FRIENDS (USER1_ID, USER2_ID)
SELECT PAF.USER1_ID, PAF.USER2_ID
FROM jsoren.PUBLIC_ARE_FRIENDS PAF
WHERE PAF.USER2_ID > PAF.USER1_ID OR NOT EXISTS (
	SELECT * FROM jsoren.PUBLIC_ARE_FRIENDS PAF2
	WHERE PAF2.USER1_ID = PAF.USER2_ID
	AND PAF2.USER2_ID = PAF.USER1_ID);


-- WHERE NOT EXISTS (SELECT * FROM FRIENDS F
-- 					WHERE PAF.USER1_ID = F.USER1_ID
-- 					AND PAF.USER2_ID = F.USER2_ID
-- 					OR PAF.USER1_ID = F.USER2_ID
-- 					AND PAF.USER2_ID = F.USER1_ID);
-- WHERE (USER1_ID, USER2_ID) NOT IN (SELECT USER1_ID, USER2_ID FROM FRIENDS)
-- AND (USER2_ID, USER1_ID) NOT IN (SELECT USER1_ID, USER2_ID FROM FRIENDS);



-- (USER1_ID, USER2_ID) NOT EXISTS 
-- (SELECT USER1_ID, USER2_ID FROM FRIENDS);

INSERT INTO CITIES (CITY_NAME, STATE_NAME, COUNTRY_NAME)
SELECT CURRENT_CITY, CURRENT_STATE, CURRENT_COUNTRY
FROM jsoren.PUBLIC_USER_INFORMATION 
WHERE CURRENT_CITY IS NOT NULL UNION
SELECT HOMETOWN_CITY, HOMETOWN_STATE, HOMETOWN_COUNTRY
FROM jsoren.PUBLIC_USER_INFORMATION 
WHERE HOMETOWN_CITY IS NOT NULL UNION
SELECT EVENT_CITY, EVENT_STATE, EVENT_COUNTRY
FROM jsoren.PUBLIC_EVENT_INFORMATION
WHERE EVENT_CITY IS NOT NULL;


INSERT INTO USER_CURRENT_CITIES (USER_ID, CURRENT_CITY_ID)
SELECT DISTINCT PUI.USER_ID, CITIES.CITY_ID 
FROM jsoren.PUBLIC_USER_INFORMATION PUI JOIN CITIES ON 
PUI.CURRENT_CITY = CITIES.CITY_NAME AND 
PUI.CURRENT_STATE = CITIES.STATE_NAME AND 
PUI.CURRENT_COUNTRY = CITIES.COUNTRY_NAME;


INSERT INTO USER_HOMETOWN_CITIES (USER_ID, HOMETOWN_CITY_ID)
SELECT DISTINCT PUI.USER_ID, CITIES.CITY_ID 
FROM jsoren.PUBLIC_USER_INFORMATION PUI JOIN CITIES ON 
PUI.HOMETOWN_CITY = CITIES.CITY_NAME AND 
PUI.HOMETOWN_STATE = CITIES.STATE_NAME AND 
PUI.HOMETOWN_COUNTRY = CITIES.COUNTRY_NAME;


INSERT INTO PROGRAMS (INSTITUTION, CONCENTRATION, DEGREE)
SELECT DISTINCT INSTITUTION_NAME, PROGRAM_CONCENTRATION, PROGRAM_DEGREE
FROM jsoren.PUBLIC_USER_INFORMATION
WHERE INSTITUTION_NAME IS NOT NULL;


INSERT INTO EDUCATION (USER_ID, PROGRAM_ID, PROGRAM_YEAR)
SELECT DISTINCT USER_ID, PROGRAM_ID, PROGRAM_YEAR 
FROM jsoren.PUBLIC_USER_INFORMATION PUI JOIN PROGRAMS P ON
PUI.INSTITUTION_NAME = P.INSTITUTION AND
PUI.PROGRAM_CONCENTRATION = P.CONCENTRATION AND 
PUI.PROGRAM_DEGREE = P.DEGREE;


INSERT INTO USER_EVENTS (EVENT_ID, EVENT_CREATOR_ID, EVENT_NAME, EVENT_TAGLINE, EVENT_DESCRIPTION, EVENT_TYPE, EVENT_SUBTYPE, EVENT_HOST, EVENT_CITY_ID, EVENT_START_TIME, EVENT_END_TIME)
SELECT P.EVENT_ID, P.EVENT_CREATOR_ID, P.EVENT_NAME, P.EVENT_TAGLINE, P.EVENT_DESCRIPTION, P.EVENT_TYPE, P.EVENT_SUBTYPE, P.EVENT_HOST, C.CITY_ID, P.EVENT_START_TIME, P.EVENT_END_TIME
FROM jsoren.PUBLIC_EVENT_INFORMATION P JOIN CITIES C ON
P.EVENT_CITY = C.CITY_NAME AND
P.EVENT_STATE = C.STATE_NAME AND
P.EVENT_COUNTRY = C.COUNTRY_NAME;

SET CONSTRAINT ALBUMS_PHOTO DEFERRED;
INSERT INTO ALBUMS (ALBUM_ID, ALBUM_OWNER_ID, ALBUM_NAME, ALBUM_CREATED_TIME, ALBUM_MODIFIED_TIME, ALBUM_LINK, ALBUM_VISIBILITY, COVER_PHOTO_ID)
SELECT DISTINCT ALBUM_ID, OWNER_ID, ALBUM_NAME, ALBUM_CREATED_TIME, ALBUM_MODIFIED_TIME, ALBUM_LINK, ALBUM_VISIBILITY, COVER_PHOTO_ID
FROM jsoren.PUBLIC_PHOTO_INFORMATION;

INSERT INTO PHOTOS (ALBUM_ID, PHOTO_ID, PHOTO_CAPTION, PHOTO_CREATED_TIME, PHOTO_MODIFIED_TIME, PHOTO_LINK)
SELECT DISTINCT ALBUM_ID, PHOTO_ID, PHOTO_CAPTION, PHOTO_CREATED_TIME, PHOTO_MODIFIED_TIME, PHOTO_LINK
FROM jsoren.PUBLIC_PHOTO_INFORMATION;

INSERT INTO TAGS (TAG_PHOTO_ID, TAG_SUBJECT_ID, TAG_CREATED_TIME, TAG_X, TAG_Y)
SELECT DISTINCT PHOTO_ID, TAG_SUBJECT_ID, TAG_CREATED_TIME, TAG_X_COORDINATE, TAG_Y_COORDINATE
FROM jsoren.PUBLIC_TAG_INFORMATION;