*&---------------------------------------------------------------------*
*& Report Z_SAPYARD_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_sapyard_1.

DATA gv_carrid TYPE sflight-carrid.

DATA: gt_data TYPE STANDARD TABLE OF sflight.

SELECTION-SCREEN: BEGIN OF BLOCK block_1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_carrid FOR gv_carrid.
SELECTION-SCREEN: END OF BLOCK block_1.

CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

    DATA gr_grid TYPE REF TO cl_gui_alv_grid.

    METHODS:
      get_data,
      generate_output,
      toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.

ENDCLASS.

CLASS lcl_report IMPLEMENTATION.

  METHOD get_data.
    SELECT * FROM sflight
      INTO TABLE gt_data
      WHERE carrid IN s_carrid.

    IF sy-dbcnt IS INITIAL.
      MESSAGE s398(00) WITH 'No data selected'.
    ENDIF.

*   Export to memory
    EXPORT data = gt_data TO MEMORY ID sy-cprog.
  ENDMETHOD.

  METHOD generate_output.

    DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
          lt_lvcfcat  TYPE lvc_t_fcat.

*   Import output table from the memory and free afterwards
    IMPORT data = gt_data FROM MEMORY ID sy-cprog.
    FREE MEMORY ID sy-cprog.

*   Only if there is some data
    CHECK gt_data IS NOT INITIAL.

    DATA(repid) = sy-repid.
    DATA(variant) = VALUE disvariant(
      report   = sy-repid
      username = sy-uname ).
    DATA(layout) = VALUE lvc_s_layo( zebra = 'X' ).

    DATA(alv_container) = NEW cl_gui_docking_container(
      repid     = repid
      dynnr     = sy-dynnr
      side      = 4
      extension = 350 ).

    gr_grid = NEW cl_gui_alv_grid( i_parent = alv_container ).

*   Registering the edit event
    gr_grid->register_edit_event(
      i_event_id = cl_gui_alv_grid=>mc_evt_enter ).

    SET HANDLER: me->toolbar      FOR gr_grid,
                 me->user_command FOR gr_grid,
                 me->handle_data_changed FOR gr_grid.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_program_name         = sy-repid
        i_internal_tabname     = 'GT_DATA'
        i_inclname             = sy-repid
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
      EXPORTING
        it_fieldcat_alv = lt_fieldcat
      IMPORTING
        et_fieldcat_lvc = lt_lvcfcat
      TABLES
        it_data         = gt_data
      EXCEPTIONS
        it_data_missing = 1
        OTHERS          = 2.

    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    gr_grid->set_table_for_first_display(
      EXPORTING
        is_layout        = layout
        is_variant       = variant
        i_save           = 'U'
        i_structure_name = 'SFLIGHT'
      CHANGING
        it_outtab        = gt_data
        it_fieldcatalog  = lt_lvcfcat ).

  ENDMETHOD.

  METHOD toolbar.
    DATA: lv_toolbar TYPE stb_button.

*   Push Button "For Example: SAVE"
    MOVE 'FC_SAVE' TO lv_toolbar-function.
    lv_toolbar-icon = icon_system_save.
    MOVE 'Save'(100) TO lv_toolbar-text.
    MOVE 'Save'(100) TO lv_toolbar-quickinfo.
    MOVE space TO lv_toolbar-disabled.
    APPEND lv_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD user_command.
    IF e_ucomm = ' '.

    ENDIF.
  ENDMETHOD.

  METHOD  handle_data_changed.

    DATA le_value TYPE c.

*   Getting Current Cell
    CALL METHOD gr_grid->get_current_cell
      IMPORTING
        e_row     = DATA(le_row)
        e_value   = le_value
        e_col     = DATA(le_col)
        es_row_id = DATA(les_row_id)
        es_col_id = DATA(les_col_id)
        es_row_no = DATA(les_row_no).
*
*   Total number of tables
    DESCRIBE TABLE gt_data LINES sy-index.
*
*   Getting next row
    les_row_id-index  = les_row_id-index  + 1.
    les_row_no-row_id = les_row_no-row_id + 1.
*
*   Set the Next row
    IF les_row_id-index LE sy-index.
      CALL METHOD gr_grid->set_current_cell_via_id
        EXPORTING
          is_row_id    = les_row_id
          is_column_id = les_col_id
          is_row_no    = les_row_no.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

INITIALIZATION.

* Object for the report
  DATA(lo_report) = NEW lcl_report( ).

* Generate output
  lo_report->generate_output( ).

START-OF-SELECTION.

* Get data
  lo_report->get_data( ).
