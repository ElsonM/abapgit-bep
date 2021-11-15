*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex12.

TYPES: BEGIN OF ty_bseg,
         bukrs TYPE bukrs,
         belnr TYPE belnr_d,
         gjahr TYPE gjahr,
         buzei TYPE buzei,
         wrbtr TYPE wrbtr,
       END OF ty_bseg.

DATA: it_bseg TYPE STANDARD TABLE OF ty_bseg INITIAL SIZE 1.

DATA: lo_alv        TYPE REF TO cl_salv_table,
      lo_selections TYPE REF TO cl_salv_selections.

REFRESH it_bseg.

SELECT bukrs belnr gjahr buzei wrbtr
  FROM bseg
  INTO TABLE it_bseg
  UP TO 10 ROWS.

IF sy-subrc IS INITIAL.
  SORT it_bseg BY bukrs belnr gjahr buzei.
ENDIF.

TRY.
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = it_bseg.
  CATCH cx_salv_msg .
ENDTRY.

*-- Enabling Selection Mode logic starts

lo_selections = lo_alv->get_selections( ).

CALL METHOD lo_selections->set_selection_mode
  EXPORTING
    value = if_salv_c_selection_mode=>multiple.

*-- Enabling Selection Mode logic end

lo_alv->display( ).
