*&---------------------------------------------------------------------*
*& Report Z_ELSON_DY1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_dy1.

*DATA alv     TYPE REF TO cl_salv_table.
*DATA message TYPE REF TO cx_salv_msg.

DATA: ref_tab TYPE REF TO data. "Generic definition

FIELD-SYMBOLS: <fs_table>    TYPE ANY TABLE,  "Use custom table ZEMPLOYEES2
               <fs_workarea> TYPE any,
               <fs_field>    TYPE any.

PARAMETERS: p_tab TYPE char20.

CREATE DATA ref_tab TYPE STANDARD TABLE OF (p_tab).
ASSIGN ref_tab->* TO <fs_table>.

SELECT *
  INTO TABLE <fs_table>
  UP TO 10 ROWS
  FROM (p_tab).

*TRY.
*    cl_salv_table=>factory(
*    IMPORTING
*      r_salv_table = DATA(alv)
*    CHANGING
*      t_table      = <fs_table> ).
*  CATCH cx_salv_msg INTO DATA(message).
*    " error handling
*ENDTRY.
*
*alv->get_columns( )->set_optimize( ).
*alv->display( ).


LOOP AT <fs_table> ASSIGNING <fs_workarea>.

  DO.
    ASSIGN COMPONENT sy-index OF STRUCTURE <fs_workarea> TO  <fs_field>.
    IF sy-subrc = 0.
      WRITE: <fs_field>.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  NEW-LINE.

ENDLOOP.
