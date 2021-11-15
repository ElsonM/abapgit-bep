*&---------------------------------------------------------------------*
*& Report Z_ABAP101_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_002.

*DATA number_of_employees TYPE i.

DATA ref_tab TYPE REF TO data. "Generic definition

FIELD-SYMBOLS: <fs_table>    TYPE ANY TABLE,
               <fs_workarea> TYPE any,
               <fs_field>    TYPE any.

PARAMETERS p_tab TYPE char20 OBLIGATORY.

CREATE DATA ref_tab TYPE STANDARD TABLE OF (p_tab).
ASSIGN ref_tab->* TO <fs_table>.

SELECT *
  INTO TABLE <fs_table>
  UP TO 10 ROWS
  FROM (p_tab).

LOOP AT <fs_table> ASSIGNING <fs_workarea>.
  DO 10 TIMES.
    ASSIGN COMPONENT sy-index OF STRUCTURE <fs_workarea> TO <fs_field>.
    IF sy-subrc = 0.
      WRITE <fs_field>.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  NEW-LINE.
ENDLOOP.
