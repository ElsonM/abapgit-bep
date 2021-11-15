*&---------------------------------------------------------------------*
*& Report Z_ELSON_T11_FLIGHT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t11_flight_report.

DATA lt_flight_report  TYPE ztt_flight_report.
DATA ls_flight_report  TYPE zst_flight_report.

DATA lv_total_booking  TYPE zst_flight_report-paymentsum.
DATA lv_total_occupied TYPE zst_flight_report-seatsocc_b.
DATA lv_total_free     TYPE zst_flight_report-seatsocc_b.
DATA lv_max_seats      TYPE zst_flight_report-seatsmax_b.

* DATA wa_flight_report LIKE LINE OF lt_flight_report. "Other way to define the structure

PARAMETERS p_carrid TYPE zst_flight_report-carrid DEFAULT 'AA'.
PARAMETERS p_connid TYPE zst_flight_report-connid DEFAULT '17'.

AUTHORITY-CHECK OBJECT 'ZAOCARRID'
         ID 'ZCARRID' FIELD p_carrid
         ID 'ACTVT' FIELD '03'.

IF sy-subrc EQ 0.

  "Titles
  NEW-LINE.
  WRITE: TEXT-z01 COLOR COL_HEADING,
         TEXT-z02 COLOR COL_HEADING,
         TEXT-z03 COLOR COL_HEADING,
         TEXT-z04 COLOR COL_HEADING,
         TEXT-z05 COLOR COL_HEADING,
         TEXT-z06 COLOR COL_HEADING.
  ULINE.

  SELECT * FROM sflight INTO CORRESPONDING FIELDS OF ls_flight_report.
    IF ls_flight_report-carrid EQ p_carrid AND
       ls_flight_report-connid EQ p_connid.
      NEW-LINE.
      WRITE: ls_flight_report-carrid     UNDER TEXT-z01,
             ls_flight_report-connid     UNDER TEXT-z02,
             ls_flight_report-fldate     UNDER TEXT-z03,
             ls_flight_report-paymentsum UNDER TEXT-z04 LEFT-JUSTIFIED,
             ls_flight_report-seatsocc_b UNDER TEXT-z05 LEFT-JUSTIFIED,
             ls_flight_report-seatsmax_b UNDER TEXT-z06 LEFT-JUSTIFIED.

      ADD ls_flight_report-paymentsum TO lv_total_booking.
      ADD ls_flight_report-seatsocc_b TO lv_total_occupied.
      ADD ls_flight_report-seatsmax_b TO lv_max_seats.

*      MOVE-CORRESPONDING ls_flight_report TO wa_flight_report.
*      APPEND wa_flight_report TO lt_flight_report.
      APPEND ls_flight_report TO lt_flight_report.
    ENDIF.
  ENDSELECT.

  lv_total_free = lv_max_seats - lv_total_occupied.

  NEW-LINE.
  WRITE: /, 'Total Bookings Amount:',               34 lv_total_booking.
  WRITE: /, 'Total Maximum seats Business class:',  46 lv_max_seats.
  WRITE: /, 'Total Occupied seats Business class:', 46 lv_total_occupied.
  WRITE: /, 'Total Free seats Business class:',     46 lv_total_free.

  SKIP.

  LOOP AT lt_flight_report INTO ls_flight_report.
    NEW-LINE.
    WRITE: 'sy-tabix: ', sy-tabix.
  ENDLOOP.

ELSE.

  MESSAGE text-z07 TYPE 'I'.

ENDIF.




*DATA wa_flight TYPE sflight.
*
*SELECT * from sflight INTO wa_flight.
*
*  NEW-LINE.
*  WRITE:
*    wa_flight-carrid,
*    wa_flight-connid,
*    wa_flight-fldate,
*    wa_flight-seatsocc,
*    wa_flight-seatsmax.
*
*ENDSELECT.
