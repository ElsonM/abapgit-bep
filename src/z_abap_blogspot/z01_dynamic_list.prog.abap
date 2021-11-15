*&---------------------------------------------------------------------*
*& Report Z01_DYNAMIC_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_dynamic_list. "Report contains one primary list
                         "and three secondary lists

*------Declaring local structure for Internal tables & Work Areas------*
TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_scarr,

       BEGIN OF ty_spfli,
         carrid   TYPE spfli-carrid,
         connid   TYPE spfli-connid,
         airpfrom TYPE spfli-airpfrom,
         airpto   TYPE spfli-airpto,
       END OF ty_spfli,

       BEGIN OF ty_sflight,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         fldate   TYPE sflight-fldate,
         seatsmax TYPE sflight-seatsmax,
         seatsocc TYPE sflight-seatsocc,
       END OF ty_sflight,

       BEGIN OF ty_sbook,
         carrid   TYPE sbook-carrid,
         connid   TYPE sbook-connid,
         fldate   TYPE sbook-fldate,
         bookid   TYPE sbook-bookid,
         customid TYPE sbook-customid,
       END OF ty_sbook.

*-----Declaring Work Areas & Internal tables---------------------------*
DATA: wa_scarr   TYPE ty_scarr,
      wa_spfli   TYPE ty_spfli,
      wa_sflight TYPE ty_sflight,
      wa_sbook   TYPE ty_sbook,

      it_scarr   TYPE TABLE OF ty_scarr,
      it_spfli   TYPE TABLE OF ty_spfli,
      it_sflight TYPE TABLE OF ty_sflight,
      it_sbook   TYPE TABLE OF ty_sbook,

      v_field    TYPE char20,
      v_value    TYPE char20.

*--Event Initialization------------------------------------------------*
INITIALIZATION.
  SELECT-OPTIONS s_carrid FOR wa_scarr-carrid.

*--Event Start of Selection--------------------------------------------*
START-OF-SELECTION.
  PERFORM data_scarr.

*--Event At Line Selection for Interactive operations------------------*
AT LINE-SELECTION.

*--Get Cursor Teacnique - Field & Value will be populated--------------*
  GET CURSOR FIELD v_field VALUE v_value.

  CASE v_field.
    WHEN 'WA_SCARR-CARRID'.
      PERFORM data_spfli.

    WHEN 'WA_SPFLI-CONNID'.
      PERFORM data_sflight.

    WHEN 'WA_SFLIGHT-FLDATE'.
      PERFORM data_sbook.
  ENDCASE.

*--Event Top of Page for Basic/ Primary Listing------------------------*
TOP-OF-PAGE.
  PERFORM top_basic_scarr.

*--Event Top of Page During Line Selection for Interactive Operations--*
TOP-OF-PAGE DURING LINE-SELECTION.

*--SY-LSIND is system variable-----------------------------------------*
  CASE sy-lsind. "It will increase its value while drilling the lists
                 "one by one by double clicking
    WHEN '1'.
      PERFORM top_spfli.
    WHEN '2'.
      PERFORM top_sflight.
    WHEN '3'.
      PERFORM top_sbook.
  ENDCASE.

*&---------------------------------------------------------------------*
*& Form data_scarr
*&---------------------------------------------------------------------*
*  Get data from Airline table
*----------------------------------------------------------------------*
FORM data_scarr.

  IF s_carrid[] IS NOT INITIAL.
    SELECT carrid carrname currcode
      FROM scarr INTO TABLE it_scarr
      WHERE carrid IN s_carrid.

    IF sy-subrc = 0.
      SORT it_scarr.
      LOOP AT it_scarr INTO wa_scarr.
        WRITE:/  wa_scarr-carrid,
              15 wa_scarr-carrname,
              38 wa_scarr-currcode.

        AT LAST.
          SKIP.
          WRITE: / '==========End of Airline Table==========='.
        ENDAT.
      ENDLOOP.
    ELSE.
      MESSAGE 'Airline doesn''t exist' TYPE 'I'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

ENDFORM.                    " data_scarr

*&---------------------------------------------------------------------*
*& Form  data_spfli
*&---------------------------------------------------------------------*
*  Get data from Flight Schedule table
*----------------------------------------------------------------------*
FORM data_spfli.

  IF v_value IS NOT INITIAL.
    SELECT carrid connid airpfrom airpto
      FROM spfli INTO TABLE it_spfli
      WHERE carrid = v_value.

    IF sy-subrc = 0.
      SORT it_spfli.

      LOOP AT it_spfli INTO wa_spfli.
        WRITE:/ wa_spfli-carrid,
             15 wa_spfli-connid,
             30 wa_spfli-airpfrom,
             45 wa_spfli-airpto.

        AT LAST.
          SKIP.
          WRITE: / '===========End of Flight Schedule============'.
        ENDAT.
      ENDLOOP.

    ELSE.
      MESSAGE 'No Flight Schedule' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " data_spfli

*&---------------------------------------------------------------------*
*& Form  data_sflight
*&---------------------------------------------------------------------*
*  Get data from Flight table
*----------------------------------------------------------------------*
FORM data_sflight.

  IF v_value IS NOT INITIAL.
    SELECT carrid connid fldate seatsmax seatsocc
      FROM sflight INTO TABLE it_sflight
      WHERE connid = v_value.

    IF sy-subrc = 0.
      SORT it_sflight.
      LOOP AT it_sflight INTO wa_sflight.
        WRITE: / wa_sflight-carrid,
              15 wa_sflight-connid,
              30 wa_sflight-fldate,
              45 wa_sflight-seatsmax,
              60 wa_sflight-seatsocc.

        AT LAST.
          SKIP.
          WRITE: / '=============End of Flight============='.
        ENDAT.
      ENDLOOP.

    ELSE.
      MESSAGE 'No Flight is there' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " data_sflight

*&---------------------------------------------------------------------*
*&      Form  data_sbook
*&---------------------------------------------------------------------*
*       Get data from Flight Booking table
*----------------------------------------------------------------------*
FORM data_sbook.

  DATA: v_date TYPE char10.

  IF v_value IS NOT INITIAL.

*--The FLDATE field has different input output format------------------*
    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
      EXPORTING
        date_external            = v_value
*       ACCEPT_INITIAL_DATE      =
      IMPORTING
        date_internal            = v_date
      EXCEPTIONS
        date_external_is_invalid = 1
        OTHERS                   = 2.

    IF v_date IS NOT INITIAL.
      SELECT carrid connid fldate bookid customid
        FROM sbook INTO TABLE it_sbook
        WHERE fldate = v_date.

      IF sy-subrc = 0.
        SORT it_sbook.

        LOOP AT it_sbook INTO wa_sbook.
          WRITE:/ wa_sbook-carrid,
               15 wa_sbook-connid,
               30 wa_sbook-fldate,
               45 wa_sbook-bookid,
               60 wa_sbook-customid.

          AT LAST.
            SKIP.
            WRITE: / '==================End of Flight Booking==================='.
          ENDAT.
        ENDLOOP.

      ELSE.
        MESSAGE 'No Single Flight Booking Available' TYPE 'I'.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " data_sbook

*&---------------------------------------------------------------------*
*&      Form  top_basic_scarr
*&---------------------------------------------------------------------*
*       Top of Page for Basic / Primary list
*----------------------------------------------------------------------*
FORM top_basic_scarr.

  WRITE: / 'Airline Details List' COLOR 1.
  WRITE: / 'Airline Code',
        15 'Airline Name',
        38 'Currency'.
  ULINE.
  SKIP.

ENDFORM.                    " top_basic_scarr

*&---------------------------------------------------------------------*
*&      Form  top_spfli
*&---------------------------------------------------------------------*
*       Top of Page for first secondary List
*----------------------------------------------------------------------*
FORM top_spfli.

  WRITE: / 'Flight Schedule List' COLOR 2.
  WRITE: / 'Airline Code',
        15 'Flight Number',
        30 'Departure',
        45 'Destination'.
  ULINE.
  SKIP.

ENDFORM.                    " top_spfli

*&---------------------------------------------------------------------*
*&      Form  top_sflight
*&---------------------------------------------------------------------*
*       Top of Page for second secondary List
*----------------------------------------------------------------------*
FORM top_sflight.

  WRITE: / 'Flight Details List' COLOR 3.
  WRITE: / 'Airline Code',
        15 'Flight Number',
        30 'Flight Date',
        45 'Available',
        60 'Occupied'.
  ULINE.
  SKIP.

ENDFORM.                    " top_sflight

*&---------------------------------------------------------------------*
*&      Form  top_sbook
*&---------------------------------------------------------------------*
*       Top of Page for third secondary List
*----------------------------------------------------------------------*
FORM top_sbook.

  WRITE: / 'Single Flight Booking List' COLOR 4.
  WRITE: / 'Airline Code',
        15 'Flight Number',
        30 'Flight Date',
        45 'Booking Number',
        60 'Customer Number'.
  ULINE.
  SKIP.

ENDFORM.                    " top_sbook
