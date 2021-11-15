*&---------------------------------------------------------------------*
*& Report Z04_BLOCK_DISPLAY
*&---------------------------------------------------------------------*
REPORT z04_block_display.

DATA: it_sflight      TYPE STANDARD TABLE OF sflight,
      it_spfli        TYPE STANDARD TABLE OF spfli,

      it_fcat_sflight TYPE slis_t_fieldcat_alv,
      it_fcat_spfli   TYPE slis_t_fieldcat_alv,

      it_events       TYPE slis_t_event.

PARAMETERS p_carrid TYPE s_carr_id.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM field_catalog.
  PERFORM show_output.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.

  SELECT * FROM sflight INTO TABLE it_sflight WHERE carrid EQ p_carrid.
  SELECT * FROM spfli   INTO TABLE it_spfli   WHERE carrid EQ p_carrid.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM field_catalog.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SPFLI'
    CHANGING
      ct_fieldcat            = it_fcat_spfli
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SFLIGHT'
    CHANGING
      ct_fieldcat            = it_fcat_sflight
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SHOW_OUTPUT
*&---------------------------------------------------------------------*
FORM show_output.

  DATA layout TYPE slis_layout_alv.
  layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
    EXPORTING
      i_callback_program = 'Z04_BLOCK_DISPLAY'.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
    EXPORTING
      is_layout                  = layout
      it_fieldcat                = it_fcat_spfli
      i_tabname                  = 'IT_SPFLI'
      it_events                  = it_events
    TABLES
      t_outtab                   = it_spfli
    EXCEPTIONS
      program_error              = 1
      maximum_of_appends_reached = 2
      OTHERS                     = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
    EXPORTING
      is_layout                  = layout
      it_fieldcat                = it_fcat_sflight
      i_tabname                  = 'IT_SFLIGHT'
      it_events                  = it_events
    TABLES
      t_outtab                   = it_sflight
    EXCEPTIONS
      program_error              = 1
      maximum_of_appends_reached = 2
      OTHERS                     = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
