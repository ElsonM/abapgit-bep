*&---------------------------------------------------------------------*
*& Report Z20_SEND_EMAIL_HTML
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z20_send_email_html.

TYPES: BEGIN OF ty_inp,
         vend_code TYPE lfa1-lifnr,
         vend_name TYPE string,
         mat_code  TYPE string,
         mat_desc  TYPE string,
         qty       TYPE string,
         color     TYPE string,
       END OF ty_inp.

DATA: wa_inp TYPE          ty_inp,
      it_inp TYPE TABLE OF ty_inp.

DATA: wa_out TYPE          solisti1,
      it_out TYPE TABLE OF solisti1.

TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
         name2 TYPE lfa1-name2,
         adrnr TYPE lfa1-adrnr,
       END OF ty_lfa1.

DATA: wa_lfa1 TYPE          ty_lfa1,
      it_lfa1 TYPE TABLE OF ty_lfa1.

TYPES: BEGIN OF ty_adr6,
         addrnumber TYPE adr6-addrnumber,
         smtp_addr  TYPE adr6-smtp_addr,
       END OF ty_adr6.

DATA: wa_adr6 TYPE ty_adr6,
      it_adr6 TYPE TABLE OF ty_adr6.

DATA: file_name TYPE char100 VALUE 'D:\SUM\abap\Vend_req.TXT',
      text      TYPE string,
      wa_rec    TYPE somlreci1,
      it_rec    TYPE TABLE OF somlreci1,
      subject   TYPE sodocchgi1.

START-OF-SELECTION.
  PERFORM read_dataset.
  PERFORM get_vendor_details.
  PERFORM mail_output.

*&---------------------------------------------------------------------*
*&      Form  READ_DATASET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM read_dataset.
  OPEN DATASET file_name FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  DO.
    READ DATASET file_name INTO text.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    IF sy-index <> 1.
      SPLIT text AT '|' INTO wa_inp-vend_code
                             wa_inp-vend_name
                             wa_inp-mat_code
                             wa_inp-mat_desc
                             wa_inp-qty
                             wa_inp-color.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_inp-vend_code
        IMPORTING
          output = wa_inp-vend_code.

      APPEND wa_inp TO it_inp.
      CLEAR: wa_inp, text.
    ENDIF.
  ENDDO.
  CLOSE DATASET file_name.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_VENDOR_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_vendor_details.
  IF it_inp IS NOT INITIAL.
    SELECT lifnr name1 name2 adrnr
      FROM lfa1 INTO TABLE it_lfa1
      FOR ALL ENTRIES IN it_inp
      WHERE lifnr = it_inp-vend_code.

    IF sy-subrc = 0.
      SORT it_lfa1 BY lifnr.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MAIL_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM mail_output.
  IF it_inp IS NOT INITIAL.
    LOOP AT it_inp INTO wa_inp.

      ON CHANGE OF wa_inp-vend_code.
        wa_out-line = '<html><body><p><strong><u>'.
        APPEND wa_out TO it_out.
        CLEAR: wa_out.

        READ TABLE it_lfa1 INTO wa_lfa1
          WITH KEY lifnr = wa_inp-vend_code
          BINARY SEARCH.

        IF sy-subrc = 0.
          CONCATENATE 'Following materials are pending from Vendor:' wa_lfa1-name1 wa_lfa1-name2
            INTO wa_out-line SEPARATED BY space.
          APPEND wa_out TO it_out.
          CLEAR: wa_out.

          wa_out-line = '</u></strong></p>'.
          APPEND wa_out TO it_out.
          CLEAR: wa_out.
        ENDIF.
      ENDON.

      wa_out-line = '<table border="1" cellspacing="0" cellpadding="0"><tbody>'.
      APPEND wa_out TO it_out.
      CLEAR: wa_out.

      ON CHANGE OF wa_inp-vend_code.
        wa_out-line = '<tr><td><p><strong>Material</strong></p></td>'.
        APPEND wa_out TO it_out.
        CLEAR: wa_out.

        wa_out-line = '<td><p><strong>Description</strong></p></td>'.
        APPEND wa_out TO it_out.
        CLEAR: wa_out.

        wa_out-line = '<td width="100"><p><strong>Qty</strong></p></td></tr>'.
        APPEND wa_out TO it_out.
        CLEAR: wa_out.
      ENDON.


      SHIFT wa_inp-mat_code LEFT DELETING LEADING '0'.
      CONCATENATE '<tr><td><p align="right">' wa_inp-mat_code '</p></td>'
        INTO wa_out-line.
      APPEND wa_out TO it_out.
      CLEAR: wa_out.

      CONCATENATE '<td>' wa_inp-mat_desc '</td>'
        INTO wa_out-line.
      APPEND wa_out TO it_out.
      CLEAR: wa_out.

      CONCATENATE '<td width="100"><p align="right">' wa_inp-qty '</p></td></tr></tbody></table>'
        INTO wa_out-line.
      APPEND wa_out TO it_out.
      CLEAR: wa_out.

      AT END OF vend_code.
        APPEND INITIAL LINE TO it_out.
        wa_out-line = '<br>This is auto generated mail so don''t reply.</body></html>'.
        APPEND wa_out TO it_out.
        CLEAR: wa_out.

        subject-obj_descr = 'Pending Material'.
        wa_rec-receiver = 'elson.meco@gmail.com'.
        wa_rec-rec_type = 'U'.
        wa_rec-express  = 'X'.
        APPEND wa_rec TO it_rec.
        CLEAR: wa_rec.

        CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
          EXPORTING
            document_data              = subject
            document_type              = 'HTM'
            put_in_outbox              = 'X'
            commit_work                = 'X'
          TABLES
            object_content             = it_out
            receivers                  = it_rec
          EXCEPTIONS
            too_many_receivers         = 1
            document_not_sent          = 2
            document_type_not_exist    = 3
            operation_no_authorization = 4
            parameter_error            = 5
            x_error                    = 6
            enqueue_error              = 7
            OTHERS                     = 8.


        REFRESH: it_out, it_rec.
        CLEAR: wa_lfa1, wa_inp.
      ENDAT.
    ENDLOOP.
  ENDIF.
ENDFORM.
