*&---------------------------------------------------------------------*
*& Report z_alv_materials
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_alv_materials.

DATA: lo_alv       TYPE REF TO cl_salv_table,
      gt_materials TYPE STANDARD TABLE OF bapi_epm_product_header,
      ls_maxrows   TYPE bapi_epm_max_rows.

ls_maxrows-bapimaxrow = 20.

CALL FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
  EXPORTING
    max_rows   = ls_maxrows
  TABLES
    headerdata = gt_materials.

TRY.
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = gt_materials.
  CATCH cx_salv_msg.
ENDTRY.

CALL METHOD lo_alv->display.
