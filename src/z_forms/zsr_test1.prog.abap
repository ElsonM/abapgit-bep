*&---------------------------------------------------------------------*
*& Report ZSR_TEST1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsr_test1.

INCLUDE zsr_test1_top.

*-----Event Initialization---------------------------------------------*
INITIALIZATION.
  PARAMETERS: p_ebeln TYPE ekko-ebeln.

*-----Event Start of Selection-----------------------------------------*
START-OF-SELECTION.
  PERFORM get_purchase_order.
  PERFORM get_po_item.
  PERFORM display_script.

*&---------------------------------------------------------------------*
*&      Form  get_purchase_order
*&---------------------------------------------------------------------*
*       Get data from Database table
*----------------------------------------------------------------------*
FORM get_purchase_order.

  IF p_ebeln IS NOT INITIAL.

    "Select single PO details
    SELECT SINGLE ebeln bukrs ernam lifnr
      FROM ekko INTO wa_ekko
      WHERE ebeln = p_ebeln.

    IF sy-subrc = 0.

      "Select single Vendor Master details
      SELECT SINGLE lifnr land1 name1 ort01
        FROM lfa1 INTO wa_lfa1
        WHERE lifnr = wa_ekko-lifnr.

      IF sy-subrc = 0.

        "Select single Vendor Company details
        SELECT SINGLE lifnr bukrs erdat ernam akont
          FROM lfb1 INTO wa_lfb1
          WHERE lifnr = wa_lfa1-lifnr
            AND bukrs = wa_ekko-bukrs.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.                    " get_purchase_order

*&---------------------------------------------------------------------*
*&      Form  get_po_item
*&---------------------------------------------------------------------*
*       Get data from item table to internal table
*----------------------------------------------------------------------*
FORM get_po_item.

  IF wa_ekko IS NOT INITIAL.
    SELECT ebeln ebelp menge meins
      FROM ekpo INTO TABLE it_ekpo
      WHERE ebeln = wa_ekko-ebeln.
  ENDIF.

ENDFORM.                    "get_po_item

*&---------------------------------------------------------------------*
*&      Form  display_script
*&---------------------------------------------------------------------*
*       Calling the SAP script function modules
*----------------------------------------------------------------------*
FORM display_script.

  "Opening the Form
  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      form                        = 'ZSCRIPT_TEST'
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      OPTIONS                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not opened successfully' TYPE 'I'.
  ENDIF.

  "Starting the Form
  CALL FUNCTION 'START_FORM'
    EXPORTING
      form        = 'ZSCRIPT_TEST'
      program     = 'ZSR_TEST'
    EXCEPTIONS
      form        = 1
      format      = 2
      unended     = 3
      unopened    = 4
      unused      = 5
      spool_error = 6
      codepage    = 7
      OTHERS      = 8.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not started successfully' TYPE 'I'.
  ENDIF.

  "Writing the Form element one
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = 'E1'
      window                   = 'HEADER'
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not written for E1' TYPE 'I'.
  ENDIF.

  "Writing the Heading of PO Item
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = 'HEAD'
      window                   = 'HEADING'
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.

  IF it_ekpo IS NOT INITIAL.
    LOOP AT it_ekpo INTO wa_ekpo.

      "Writing the line Items one by one
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element                  = 'ITEM'
          window                   = 'MAIN'
        EXCEPTIONS
          element                  = 1
          function                 = 2
          type                     = 3
          unopened                 = 4
          unstarted                = 5
          window                   = 6
          bad_pageformat_for_print = 7
          spool_error              = 8
          codepage                 = 9
          OTHERS                   = 10.

    ENDLOOP.
  ENDIF.

  "Writing the Form element two
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = 'COMP'
      window                   = 'COMPANY'
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not written for COMP' TYPE 'I'.
  ENDIF.

  "Writing the Form element three
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = 'VEND'
      window                   = 'VENDOR'
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not written for VEND' TYPE 'I'.
  ENDIF.

  "Ending the Form
  CALL FUNCTION 'END_FORM'.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not ended' TYPE 'I'.
  ENDIF.

  "Closing the Form
  CALL FUNCTION 'CLOSE_FORM'.

  IF sy-subrc <> 0.
    MESSAGE 'Form is not closed' TYPE 'I'.
  ENDIF.

ENDFORM.                    " display_script
