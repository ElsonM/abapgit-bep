*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_19
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_19.

DATA: it_mara TYPE TABLE OF mara,
      wa_mara TYPE          mara.

DATA: lr_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT * FROM mara INTO TABLE it_mara UP TO 50 ROWS.
  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = lr_alv
    CHANGING
      t_table      = it_mara.
  lr_alv->display( ).
