*&---------------------------------------------------------------------*
*& Report Z_ABAP101_062
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_062.

TYPES: BEGIN OF ty_line,
         id            TYPE c LENGTH 10,
         name          TYPE string,
         value         TYPE i,
         creation_date TYPE d,
       END OF ty_line.

TYPES: ty_table TYPE STANDARD TABLE OF ty_line.

*&---------------------------------------------------------------------*
*& Form count_initial_fields_of_line
*&---------------------------------------------------------------------*
*  Counts and prints how many fields are blank by line
*----------------------------------------------------------------------*
* --> US_TABLE internal table
*----------------------------------------------------------------------*

FORM count_initial_fields_of_line
    USING us_table TYPE ty_table.

  DATA lwa_line               TYPE ty_line.
  DATA lv_initial_field_total TYPE i.
  DATA lv_initial_field       TYPE i.

  LOOP AT us_table INTO lwa_line.
    CLEAR lv_initial_field.

    IF lwa_line-id IS INITIAL.
      lv_initial_field = lv_initial_field + 1.
    ENDIF.

    IF lwa_line-name IS INITIAL.
      lv_initial_field = lv_initial_field + 1.
    ENDIF.

    IF lwa_line-value IS INITIAL.
      lv_initial_field = lv_initial_field + 1.
    ENDIF.

    IF lwa_line-creation_date IS INITIAL.
      lv_initial_field = lv_initial_field + 1.
    ENDIF.

    WRITE: 'Line  ', sy-tabix, '=>', lv_initial_field, 'blank fields'.
    NEW-LINE.

    lv_initial_field_total = lv_initial_field_total + lv_initial_field.
  ENDLOOP.

  WRITE: 'Total:', lv_initial_field_total.
  WRITE: sy-uline.

ENDFORM. "count_initial_fields_of_line

START-OF-SELECTION.

  DATA itab TYPE ty_table.
  DATA wa TYPE ty_line.

  wa-id = '1'.
  wa-name = 'John'.
  wa-value = 50.
  wa-creation_date = '20140727'.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_line USING itab.

  wa-id = '2'.
  wa-name = 'Mary'.
  wa-value = 20.
* wa-creation_date = ?.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_line USING itab.

  wa-id = '3'.
  wa-name = 'Max'.
* wa-value = ?.
* wa-creation_date = ?.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_line USING itab.

  wa-id = '4'.
* wa-name = ?.
* wa-value = ?.
* wa-creation_date = ?.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_line USING itab.
