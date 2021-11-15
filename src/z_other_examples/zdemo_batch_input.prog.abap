*&---------------------------------------------------------------------*
*& Report ZDEMO_BATCH_INPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_batch_input.

DATA: it_bdcdata TYPE STANDARD TABLE OF bdcdata,
      wa_bdcdata TYPE                   bdcdata.

START-OF-SELECTION.

  PERFORM bdc_dynpro USING 'SAPLMGMM'    '0060'.
  PERFORM bdc_field  USING 'RMMG1-MATNR' '567ASHG'.
  PERFORM bdc_field  USING 'RMMG1-MBRSH' 'P'.
  PERFORM bdc_field  USING 'RMMG1-MTART' 'ROH'.
  PERFORM bdc_dynpro USING 'SAPLMGMM'    '0070'.

FORM bdc_dynpro USING program dynpro.

  CLEAR wa_bdcdata.

  wa_bdcdata-program  = program.
  wa_bdcdata-dynpro   = dynpro.
  wa_bdcdata-dynbegin = 'X'.

  APPEND wa_bdcdata TO it_bdcdata.

ENDFORM.

FORM bdc_field USING fnam fval.

  CLEAR  wa_bdcdata.

  wa_bdcdata-fnam = fnam.
  wa_bdcdata-fval = fval.

  APPEND wa_bdcdata TO it_bdcdata.

ENDFORM.
