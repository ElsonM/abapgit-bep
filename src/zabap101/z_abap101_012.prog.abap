*&---------------------------------------------------------------------*
*& Report Z_ABAP101_012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_012.

TYPES table_type_sflight TYPE TABLE OF sflight.

DATA sflight_work_area TYPE LINE OF table_type_sflight.
DATA table_sflight     TYPE         table_type_sflight.

START-OF-SELECTION.

  sflight_work_area-carrid = 'AA'.
  sflight_work_area-connid = '0017'.
  sflight_work_area-fldate = '20131225'.       "Christmas
  sflight_work_area-price  = '500.12'.
  APPEND sflight_work_area TO table_sflight.

  sflight_work_area-carrid = 'AA'.
  sflight_work_area-connid = '064'.
  sflight_work_area-fldate = '20131225'.
  sflight_work_area-price = '500.12'.
  APPEND sflight_work_area TO table_sflight.

  BREAK-POINT.

*  LOOP AT table_sflight INTO sflight_work_area.
*    WRITE: / sflight_work_area-carrid, sflight_work_area-connid,
*             sflight_work_area-fldate, sflight_work_area-price.
*    CLEAR: sflight_work_area.
*  ENDLOOP.
