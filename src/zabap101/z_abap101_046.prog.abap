*&---------------------------------------------------------------------*
*& Report Z_ABAP101_046
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_046.

DATA: v_day   TYPE string,
      v_month TYPE string,
      v_year  TYPE string.

START-OF-SELECTION.

* Handle month
  CASE sy-datum+4(2).
    WHEN '01'.
      v_month = 'January'.
    WHEN '02'.
      v_month = 'February'.
    WHEN '03'.
      v_month = 'March'.
    WHEN '04'.
      v_month = 'April'.
    WHEN '05'.
      v_month = 'May'.
    WHEN '06'.
      v_month = 'June'.
    WHEN '07'.
      v_month = 'July'.
    WHEN '08'.
      v_month = 'August'.
    WHEN '09'.
      v_month = 'September'.
    WHEN '10'.
      v_month = 'October'.
    WHEN '11'.
      v_month = 'November'.
    WHEN '12'.
      v_month = 'December'.
  ENDCASE.

* Handle day
  IF sy-datum+6(2) = '01'.
    v_day = 'first'.
  ELSEIF sy-datum+6(2) = '02'.
    v_day = 'second'.
  ELSEIF sy-datum+6(2) = '03'.
    v_day = 'third'.
  ELSE. "04-31
    IF sy-datum+6(2) BETWEEN 04 AND 19. "04-19
      CASE sy-datum+6(2).
        WHEN '04'.
          v_day = 'four'.
        WHEN '05'.
          v_day = 'fif'.
        WHEN '06'.
          v_day = 'six'.
        WHEN '07'.
          v_day = 'seven'.
        WHEN '08'.
          v_day = 'eigh'.
        WHEN '09'.
          v_day = 'nin'.
        WHEN '10'.
          v_day = 'ten'.
        WHEN '11'.
          v_day = 'eleven'.
        WHEN '12'.
          v_day = 'twelf'.
        WHEN '13'.
          v_day = 'thirteen'.
        WHEN '14'.
          v_day = 'fourteen'.
        WHEN '15'.
          v_day = 'fitteen'.
        WHEN '16'.
          v_day = 'sixteen'.
        WHEN '17'.
          v_day = 'seventeen'.
        WHEN '18'.
          v_day = 'eighteen'.
        WHEN '19'.
          v_day = 'nineteen'.
      ENDCASE.
      CONCATENATE v_day 'th' INTO v_day.
    ELSE.
      CASE sy-datum+6(2). "20-31
        WHEN '20'.
          v_day = 'twentieth'.
        WHEN '21'.
          v_day = 'twenty-first'.
        WHEN '22'.
          v_day = 'twenty-second'.
        WHEN '23'.
          v_day = 'twenty-third'.
        WHEN '24'.
          v_day = 'twenty-fourth'.
        WHEN '25'.
          v_day = 'twenty-fifth'.
        WHEN '26'.
          v_day = 'twenty-sixth'.
        WHEN '27'.
          v_day = 'twenty-seventh'.
        WHEN '28'.
          v_day = 'twenty-eighth'.
        WHEN '29'.
          v_day = 'twenty-ninth'.
        WHEN '30'.
          v_day = 'thirtieth'.
        WHEN '31'.
          v_day = 'thirty-first'.
      ENDCASE.
    ENDIF.
  ENDIF.

* Handle year
  v_year = sy-datum(4).

* Print result
  WRITE: v_month, 'the', v_day, ',', v_year.
  NEW-LINE.
