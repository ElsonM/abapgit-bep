*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_20.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         mbrsh TYPE mara-mbrsh,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
       END OF ty_mara.
DATA: it_mara TYPE TABLE OF ty_mara,
      wa_mara TYPE          ty_mara.
DATA: lr_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  SELECT matnr mtart mbrsh matkl meins FROM mara INTO TABLE it_mara UP TO 50 ROWS.

* TRY.
  CALL METHOD cl_salv_table=>factory "Get SALV factory instance
*    EXPORTING
*      LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
*      R_CONTAINER    =
*      CONTAINER_NAME =
    IMPORTING
      r_salv_table = lr_alv
    CHANGING
      t_table      = it_mara.
* CATCH CX_SALV_MSG .
* ENDTRY.

  lr_alv->display( ). "Display grid
