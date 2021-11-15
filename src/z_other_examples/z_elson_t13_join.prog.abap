*&---------------------------------------------------------------------*
*& Report Z_ELSON_T13_JOIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t13_join.

*TYPES: BEGIN OF ty_spfli_scarr,
*         carrid   TYPE spfli-carrid,
*         connid   TYPE spfli-connid,
*         cityfrom TYPE spfli-cityfrom,
*         carrname TYPE scarr-carrname,
*       END OF ty_spfli_scarr.
*
*DATA: lt_join TYPE TABLE OF ty_spfli_scarr,
*      wa_join LIKE LINE OF lt_join.

DATA: lt_scarr TYPE TABLE OF scarr,
      wa_scarr LIKE LINE OF lt_scarr,
      lt_spfli TYPE TABLE OF spfli,
      wa_spfli LIKE LINE OF lt_spfli.

SELECT *
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE lt_scarr.

IF lt_scarr IS NOT INITIAL.

  SELECT *
    FROM spfli
    INTO CORRESPONDING FIELDS OF TABLE lt_spfli
    FOR ALL ENTRIES IN lt_scarr
    WHERE carrid EQ lt_scarr-carrid.

ENDIF.

LOOP AT lt_spfli INTO wa_spfli.
  READ TABLE lt_scarr INTO wa_scarr WITH KEY carrid = wa_spfli-carrid.
  IF sy-subrc EQ 0.
    NEW-LINE.
    WRITE: wa_spfli-carrid,
           wa_spfli-connid,
           wa_spfli-cityfrom,
           wa_scarr-carrname.
  ENDIF.
ENDLOOP.


*SELECT *
*  FROM zvw_spfli_scarr
*  INTO CORRESPONDING FIELDS OF TABLE lt_join.
*
*SORT lt_join ASCENDING BY carrid connid.
*DELETE ADJACENT DUPLICATES FROM lt_join COMPARING ALL FIELDS.



*SELECT *
*  FROM spfli AS sp
*  JOIN scarr AS sc
*  ON sp~carrid EQ sc~carrid
*  INTO CORRESPONDING FIELDS OF TABLE lt_join.

*LOOP AT lt_join INTO wa_join.
*  NEW-LINE.
*  WRITE: wa_join-carrid,
*         wa_join-connid,
*         wa_join-cityfrom,
*         wa_join-carrname.
*ENDLOOP.
