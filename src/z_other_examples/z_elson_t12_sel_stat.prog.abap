*&---------------------------------------------------------------------*
*& Report Z_ELSON_T12_SEL_STAT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t12_sel_stat.

*PARAMETERS p_carrid TYPE sflight-carrid.
*PARAMETERS p_connid TYPE sflight-connid.
*PARAMETERS p_fldate TYPE sflight-fldate.

*DATA ls_sflight TYPE sflight.
*
*SELECT SINGLE *
*  FROM sflight
*  INTO ls_sflight
*  WHERE carrid EQ p_carrid AND
*        connid EQ p_connid AND
*        fldate EQ p_fldate.
*
*IF sy-subrc EQ 0.
*  WRITE: ls_sflight-carrid,
*         ls_sflight-connid,
*         ls_sflight-fldate,
*         ls_sflight-price,
*         ls_sflight-currency,
*         ls_sflight-planetype,
*         ls_sflight-seatsmax,
*         ls_sflight-seatsocc,
*         ls_sflight-paymentsum.
*ELSE.
*  MESSAGE 'No records were found' TYPE 'I'.
*ENDIF.

*DATA: lv_carrid TYPE sflight-carrid,
*      lv_connid TYPE sflight-connid,
*      lv_fldate TYPE sflight-fldate,
*      lv_price  TYPE sflight-price.
*
*SELECT SINGLE carrid connid fldate price
*  FROM sflight
*  INTO (lv_carrid, lv_connid, lv_fldate, lv_price)
*  WHERE carrid EQ p_carrid AND
*        connid EQ p_connid AND
*        fldate EQ p_fldate.
*
*IF sy-subrc EQ 0.
*  WRITE: lv_carrid,
*         lv_connid,
*         lv_fldate,
*         lv_price.
*ELSE.
*  MESSAGE 'No records were found' TYPE 'I'.
*ENDIF.

*DATA ls_airlines TYPE scarr.
*
*NEW-LINE.
*WRITE: 'US $ Accepting Airlines:'.
*
*SELECT *
*  FROM scarr
*  INTO ls_airlines.
*IF ls_airlines-currcode EQ 'USD'.
*  WRITE: /, ls_airlines-carrname.
*ENDIF.
*ENDSELECT.

DATA lt_airlines TYPE TABLE OF scarr.
DATA ls_airlines TYPE          scarr.

SELECT *
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE lt_airlines
  WHERE currcode EQ 'USD'.

SELECT *
  FROM scarr
  APPENDING CORRESPONDING FIELDS OF TABLE lt_airlines
  WHERE currcode EQ 'EUR'.

LOOP AT lt_airlines INTO ls_airlines.
  WRITE: /, ls_airlines-carrname.
ENDLOOP.
