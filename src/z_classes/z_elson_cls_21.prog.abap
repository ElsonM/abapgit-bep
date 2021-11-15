*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_21.
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         mbrsh TYPE mara-mbrsh,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
       END OF ty_mara.

DATA: it_mara TYPE TABLE OF ty_mara,
      wa_mara TYPE          mara.

DATA: lr_alv     TYPE REF TO cl_salv_table.
DATA: lr_columns TYPE REF TO cl_salv_columns_table. "Columns instance
DATA: lr_col     TYPE REF TO cl_salv_column_table.  "Column  instance

START-OF-SELECTION.
  SELECT matnr mtart mbrsh matkl meins
    FROM mara
    INTO TABLE it_mara UP TO 50 ROWS.

  CALL METHOD cl_salv_table=>factory "Get SALV factory instance
    IMPORTING
      r_salv_table = lr_alv
    CHANGING
      t_table      = it_mara.

* Get ALV columns
  CALL METHOD lr_alv->get_columns  "Get all columns
    RECEIVING
      value = lr_columns.

  IF lr_columns IS NOT INITIAL.
    TRY.
        lr_col ?= lr_columns->get_column( 'MATNR' ). "Get MATNR columns to insert hotspot
      CATCH cx_salv_not_found.
    ENDTRY.

* Set the Hotspot for MATNR Column
    TRY.
        CALL METHOD lr_col->set_cell_type "Set cell type hotspot
          EXPORTING
            value = if_salv_c_cell_type=>hotspot.
      CATCH cx_salv_data_error.
    ENDTRY.
  ENDIF.

  lr_alv->display( ). "Display grid
