*&---------------------------------------------------------------------*
*& Report Z24_EXPICIT_ENCH_POINT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z24_explicit_ench_point NO STANDARD PAGE HEADING.

TABLES scarr.

DATA: wa_scarr TYPE          scarr,
      it_scarr TYPE TABLE OF scarr.

SELECT-OPTIONS s_carrid FOR scarr-carrid.

START-OF-SELECTION.

  SELECT * FROM scarr INTO TABLE it_scarr
    WHERE carrid IN s_carrid.

ENHANCEMENT-POINT ZENCH_P SPOTS ZENCH .

  IF sy-subrc = 0.

    SORT it_scarr.
    LOOP AT it_scarr INTO wa_scarr.
      WRITE: /3 wa_scarr-carrid,
             15 wa_scarr-carrname,
             40 wa_scarr-currcode,
             55 wa_scarr-url.
    ENDLOOP.

  ENDIF.
