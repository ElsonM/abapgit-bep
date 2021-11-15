*&---------------------------------------------------------------------*
*& Module Pool       ZTEST_CURR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM ztest_curr.

CLASS lcl_app DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS display.
    METHODS on_onf4
                  FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING e_fieldname es_row_no e_fieldvalue er_event_data.
    DATA: grid   TYPE REF TO cl_gui_alv_grid,
          spflis TYPE TABLE OF spfli.
ENDCLASS.

CLASS lcl_app IMPLEMENTATION.

  METHOD constructor.
    SELECT * FROM spfli INTO TABLE spflis.
    grid = NEW cl_gui_alv_grid(
        i_parent = cl_gui_container=>screen0 ).
    SET HANDLER on_onf4 FOR grid.
    grid->register_f4_for_fields(
        it_f4 = VALUE #( ( fieldname = 'CONNID' register = 'X' chngeafter = 'X' ) ) ).
  ENDMETHOD.

  METHOD display.
    DATA(fcat) = VALUE lvc_t_fcat(
        ( fieldname = 'CARRID' ref_table = 'SPFLI' )
        ( fieldname = 'CONNID' ref_table = 'SPFLI' f4availabl = 'X' ) ).
    grid->set_table_for_first_display(
*        EXPORTING is_layout = VALUE #( edit = 'X' )
        CHANGING it_outtab = spflis
                 it_fieldcatalog = fcat
        EXCEPTIONS OTHERS = 4 ).
  ENDMETHOD.

  METHOD on_onf4.
    DATA return TYPE TABLE OF ddshretval.

    er_event_data->m_event_handled = 'X'.

    IF e_fieldname = 'CONNID'.
      SELECT DISTINCT connid FROM spfli INTO TABLE @DATA(connids).
      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
        EXPORTING
          retfield        = 'CONNID'
          value_org       = 'S'
        TABLES
          value_tab       = connids
          return_tab      = return
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2
          OTHERS          = 3.
*      IF sy-subrc = 0 AND return IS NOT INITIAL.
*        FIELD-SYMBOLS <modis> TYPE lvc_t_modi.
*        ASSIGN er_event_data->m_data->* TO <modis>.
*        <modis> = VALUE #( BASE <modis> ( row_id    = es_row_no-row_id
*                                          fieldname = e_fieldname
*                                          value     = return[ 1 ]-fieldval ) ).
*      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

PARAMETERS dummy.

AT SELECTION-SCREEN OUTPUT.
  DATA(alv) = NEW lcl_app( ).
  alv->display( ).
