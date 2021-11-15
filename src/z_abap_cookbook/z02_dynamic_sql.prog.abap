*&---------------------------------------------------------------------*
*& Report YTEST_DYNAMIC_SQL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_dynamic_sql.

SELECTION-SCREEN BEGIN OF BLOCK where_clause WITH FRAME TITLE TEXT-w01.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: where1 AS CHECKBOX.
SELECTION-SCREEN COMMENT 8(15) TEXT-w02 FOR FIELD field1.
PARAMETERS: field1(10).
SELECTION-SCREEN COMMENT 39(13) TEXT-w03 FOR FIELD value1.
PARAMETERS: value1(10).
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: where2 AS CHECKBOX.
SELECTION-SCREEN COMMENT 8(15) TEXT-w04 FOR FIELD field2.
PARAMETERS: field2(10).
SELECTION-SCREEN COMMENT 39(13) TEXT-w05 FOR FIELD value2.
PARAMETERS: value2(10).
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: where3 AS CHECKBOX.
SELECTION-SCREEN COMMENT 8(15) TEXT-w06.
PARAMETERS: fwithval(39).
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK where_clause.

SELECTION-SCREEN BEGIN OF BLOCK orderby_clause WITH FRAME TITLE TEXT-w07.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: orderby1 RADIOBUTTON GROUP rad1.
SELECTION-SCREEN COMMENT 8(26) TEXT-w08.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: orderby2 RADIOBUTTON GROUP rad1.
SELECTION-SCREEN COMMENT 8(26) TEXT-w09.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: orderby3 RADIOBUTTON GROUP rad1.
SELECTION-SCREEN COMMENT 8(26) TEXT-w10.
PARAMETERS: ordby_f(10).
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK orderby_clause.

DATA: order_by   TYPE string,
      where_cond TYPE string.

TYPES ty_spfli TYPE spfli.

DATA: wa_spfli TYPE                   ty_spfli,
      it_spfli TYPE STANDARD TABLE OF ty_spfli.

START-OF-SELECTION.

  IF where1 EQ 'X'.
    CONCATENATE field1 'EQ value1' INTO where_cond SEPARATED BY space.
  ENDIF.

  IF where2 EQ 'X'.
    CONCATENATE where_cond 'AND' field2 'EQ value2' INTO where_cond SEPARATED BY space.
  ENDIF.

  IF where3 EQ 'X'.
    CONCATENATE  where_cond 'AND ' fwithval INTO where_cond SEPARATED BY space.
  ENDIF.

  IF orderby2 EQ 'X'.
    order_by = 'CARRID CONNID'.
  ELSEIF orderby3 EQ 'X'.
    order_by = ordby_f.
  ENDIF.

  CHECK where1 EQ 'X'.

  TRY.
      SELECT * FROM spfli INTO TABLE it_spfli
        WHERE (where_cond)
        ORDER BY (order_by).

      LOOP AT it_spfli INTO wa_spfli.
        WRITE :/  wa_spfli-carrid,
                  wa_spfli-connid,
                  wa_spfli-countryfr,
                  wa_spfli-cityfrom,
                  wa_spfli-airpfrom,
                  wa_spfli-countryto,
                  wa_spfli-cityto,
                  wa_spfli-airpto,
                  wa_spfli-fltime,
                  wa_spfli-deptime,
                  wa_spfli-arrtime,
                  wa_spfli-distance,
                  wa_spfli-distid,
                  wa_spfli-fltype,
                  wa_spfli-period.
      ENDLOOP.

    CATCH cx_sy_dynamic_osql_error.
      WRITE: /'Problem in SQL code'.
  ENDTRY.
