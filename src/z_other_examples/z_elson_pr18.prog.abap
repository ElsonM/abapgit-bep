*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr18 NO STANDARD PAGE HEADING.

TABLES spfli.
DATA: wa_spfli TYPE spfli.

"Declare cursor
DATA: cr_spfli TYPE cursor.

PARAMETERS p_from TYPE spfli-countryfr.

"Open Cursor
OPEN CURSOR cr_spfli FOR SELECT *
FROM spfli WHERE countryfr = p_from.

IF sy-subrc = 0.
  WRITE: /  'Airline',
         10 'Flight Number',
         30 'Country From',
         45 'City From',
         66 'Departure airport',
         86 'Country To',
        100 'City To',
        121 'Destination airport',
        142 'Departure time',
        160 'Arrival time',
        175 'Distance'.
  ULINE.
  SKIP.
ENDIF.

DO.
  "Fetch Next Cursor
  FETCH NEXT CURSOR cr_spfli
  INTO wa_spfli.

  IF sy-subrc = 0.
    CHECK wa_spfli-countryfr = p_from.
    WRITE:   /3 wa_spfli-carrid,
             10 wa_spfli-connid,
             30 wa_spfli-countryfr,
             45 wa_spfli-cityfrom,
             66 wa_spfli-airpfrom,
             86 wa_spfli-countryto,
            100 wa_spfli-cityto,
            121 wa_spfli-airpto,
            142 wa_spfli-deptime,
            160 wa_spfli-arrtime,
            175 wa_spfli-distance.
  ELSE.
    EXIT.
  ENDIF.
ENDDO.

"Close Cursor
CLOSE CURSOR cr_spfli.
