*&---------------------------------------------------------------------*
*& Report Z25_EXPLICIT_ENCH_SECTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z25_explicit_ench_section NO STANDARD PAGE HEADING.

TABLES sflight.

DATA: wa_sflight TYPE          sflight,
      it_sflight TYPE TABLE OF sflight.

INITIALIZATION.

  SELECT-OPTIONS s_carrid FOR sflight-carrid.

START-OF-SELECTION.

  SELECT * FROM sflight INTO TABLE it_sflight
    WHERE carrid IN s_carrid.

ENHANCEMENT-SECTION ZENCH_S SPOTS ZENCH_02 .

END-ENHANCEMENT-SECTION.

  IF it_sflight IS NOT INITIAL.

    SORT it_sflight.
    LOOP AT it_sflight INTO wa_sflight.
      WRITE: /3 wa_sflight-carrid,
             15 wa_sflight-connid,
             27 wa_sflight-fldate DD/MM/YYYY,
             45 wa_sflight-seatsmax,
             60 wa_sflight-seatsocc.
    ENDLOOP.

  ENDIF.
