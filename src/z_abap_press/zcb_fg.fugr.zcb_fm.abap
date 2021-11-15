FUNCTION ZCB_FM.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MATNR) TYPE  MATNR
*"     REFERENCE(IM_SPRAS) TYPE  SPRAS
*"  EXPORTING
*"     REFERENCE(EX_MAKTX) TYPE  MAKTX
*"  EXCEPTIONS
*"      INVALID_VALUES
*"----------------------------------------------------------------------

  SELECT SINGLE maktx FROM makt INTO ex_maktx
    WHERE matnr EQ im_matnr
      AND spras EQ im_spras.
  IF sy-subrc IS NOT INITIAL.
    RAISE invalid_values.
  ENDIF.

ENDFUNCTION.
