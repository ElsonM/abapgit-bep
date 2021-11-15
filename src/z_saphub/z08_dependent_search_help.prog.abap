*&---------------------------------------------------------------------*
*& Report Z08_DEPENDENT_SEARCH_HELP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z08_dependent_search_help.

TYPES: BEGIN OF ty_matnr,
         werks TYPE marc-werks,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_matnr.

*--------------------------------------------------------------*
*Data Declaration
*--------------------------------------------------------------*
DATA: gwa_matnr TYPE          ty_matnr,
      gt_matnr  TYPE TABLE OF ty_matnr.

DATA: gt_return  TYPE TABLE OF ddshretval,
      gwa_return TYPE          ddshretval.

DATA: gwa_dynpfields TYPE          dynpread,
      gt_dynpfields  TYPE TABLE OF dynpread.

DATA: gv_werks       TYPE marc-werks.
*--------------------------------------------------------------*
*Selection-Screen
*--------------------------------------------------------------*
PARAMETERS: p_werks TYPE marc-werks OBLIGATORY.
PARAMETERS: p_matnr TYPE mara-matnr.

*--------------------------------------------------------------*
*Selection-Screen on Value-Request
*--------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_matnr.

  REFRESH gt_dynpfields.
  gwa_dynpfields-fieldname = 'P_WERKS'.
  APPEND gwa_dynpfields TO gt_dynpfields.

* Get plant value on the selection screen
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = gt_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.

  READ TABLE gt_dynpfields INTO gwa_dynpfields
    WITH KEY fieldname = 'P_WERKS'.

  IF sy-subrc = 0.
    gv_werks = gwa_dynpfields-fieldvalue.
  ENDIF.

* Get values from the database based on plant
  SELECT a~werks a~matnr b~maktx
    UP TO 10 ROWS
    INTO TABLE gt_matnr
    FROM marc AS a
    INNER JOIN makt AS b
    ON a~matnr = b~matnr
    WHERE a~werks = gv_werks
    AND b~spras = 'EN'.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'MATNR'
      value_org       = 'S'
    TABLES
      value_tab       = gt_matnr
      return_tab      = gt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE gt_return INTO gwa_return INDEX 1.

  IF sy-subrc = 0.
    p_matnr = gwa_return-fieldval.
  ENDIF.
