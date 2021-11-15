*&---------------------------------------------------------------------*
*&  Include           Z12_TABLE_CONTROL_UPLOAD_F01
*&---------------------------------------------------------------------*

FORM back_9000.

  CLEAR ok_code_9000.
  LEAVE PROGRAM.

ENDFORM.

FORM upload_data.

  TYPES: BEGIN OF ty_clip,
           data TYPE char18,
         END OF ty_clip.

  DATA: it_clip TYPE TABLE OF ty_clip,
        wa_clip TYPE          ty_clip.

  CALL METHOD cl_gui_frontend_services=>clipboard_import
    IMPORTING
      data                 = it_clip
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.

  IF sy-subrc = 0.

    LOOP AT it_clip INTO wa_clip.

      wa_lfa1-lifnr = wa_clip-data.
      APPEND wa_lfa1 TO it_lfa1.
      CLEAR: wa_lfa1, wa_clip.

    ENDLOOP.

  ENDIF.

  CLEAR ok_code_9000.

ENDFORM.
