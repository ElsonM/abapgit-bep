*&---------------------------------------------------------------------*
*& Report ZDEMO_FM_CALL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_fm_call.

DATA v_maktx TYPE maktx.
PARAMETERS: p_matnr TYPE matnr,
            p_spras TYPE spras.

CALL FUNCTION 'ZCB_FM'
  EXPORTING
    im_matnr       = p_matnr
    im_spras       = p_spras
  IMPORTING
    ex_maktx       = v_maktx
  EXCEPTIONS
    invalid_values = 1
    OTHERS         = 2.

IF sy-subrc <> 0.
* Implement suitable error handling here
  CASE sy-subrc.
    WHEN 1.
      MESSAGE 'No records found' TYPE 'E'.
    WHEN 2.
      "Do nothing
  ENDCASE.
ELSE.
  WRITE v_maktx.
ENDIF.
