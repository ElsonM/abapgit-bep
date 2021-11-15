*&---------------------------------------------------------------------*
*& Report Z_ABAP101_058
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_058.

TYPES: BEGIN OF ty_work_area,
         integer    TYPE i,
         float      TYPE f,
         pack       TYPE p LENGTH 8 DECIMALS 3,
         decfloat34 TYPE decfloat34,
       END OF ty_work_area.

*&---------------------------------------------------------------------*
*& Form sum_numeric_components
*&---------------------------------------------------------------------*
*  Receives a work area with numeric components and sum them.
*----------------------------------------------------------------------*
* --> US_WA Work area with numeric components
*----------------------------------------------------------------------*
FORM sum_numeric_components
    USING us_wa TYPE ty_work_area.

  DATA lv_sum_result TYPE decfloat34.
  lv_sum_result = us_wa-integer + us_wa-float + us_wa-pack + us_wa-decfloat34.
  WRITE lv_sum_result.
  NEW-LINE.

ENDFORM. " sum_numeric_components

START-OF-SELECTION.

  DATA work_area         TYPE ty_work_area.
  DATA work_area_doubled TYPE ty_work_area.

  work_area-integer    = 2.
  work_area-float      = '2.5'.
  work_area-pack       = '2.12345'.
  work_area-decfloat34 = 1000000000000000000000000000000.
  PERFORM sum_numeric_components USING work_area.

  work_area_doubled-integer    = work_area-integer * 2.
  work_area_doubled-float      = work_area-float * 2.
  work_area_doubled-pack       = work_area-pack * 2.
  work_area_doubled-decfloat34 = work_area-decfloat34 * 2.
  PERFORM sum_numeric_components USING work_area_doubled.
