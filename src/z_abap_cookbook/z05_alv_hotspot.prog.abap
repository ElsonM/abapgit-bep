*&---------------------------------------------------------------------*
*& Report Z05_ALV_HOTSPOT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_alv_hotspot.

TYPES: BEGIN OF ty_pa0008,
         pernr TYPE persno,
         subty TYPE subty,
         begda TYPE begda,
         endda TYPE endda,
         aedtm TYPE aedat,
         uname TYPE aenam,
         bet01 TYPE pad_amt7s,
         waers TYPE waers,
       END OF ty_pa0008.

DATA: wa_pa0008 TYPE                   ty_pa0008,
      it_pa0008 TYPE STANDARD TABLE OF ty_pa0008.

DATA: myalv       TYPE REF TO cl_salv_table,
      myfunctions TYPE REF TO cl_salv_functions_list,
      mycolumns   TYPE REF TO cl_salv_columns_table,
      mycolumn    TYPE REF TO cl_salv_column_table,
      mylayout    TYPE REF TO cl_salv_layout,
      myevents    TYPE REF TO cl_salv_events_table.

DATA mykey TYPE salv_s_layout_key.

CLASS myhotspot DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_click_hotspot FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column.
ENDCLASS.

CLASS myhotspot IMPLEMENTATION.
  METHOD on_click_hotspot.
    CLEAR wa_pa0008.
    READ TABLE it_pa0008 INDEX row INTO wa_pa0008.
    DATA p0008 TYPE p0008.
    SELECT SINGLE * FROM pa0008 INTO CORRESPONDING FIELDS OF p0008
      WHERE pernr EQ wa_pa0008-pernr
      AND   begda EQ wa_pa0008-begda
      AND   endda EQ wa_pa0008-endda.

    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        infty         = '0008'
        number        = p0008-pernr
        validityend   = p0008-endda
        validitybegin = p0008-begda
        record        = p0008
        operation     = 'DIS'
        dialog_mode   = '2'
      EXCEPTIONS
        OTHERS        = 0.
  ENDMETHOD.
ENDCLASS.

CLASS newbutton DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_button_press FOR EVENT added_function OF cl_salv_events_table
      IMPORTING e_salv_function.
ENDCLASS.

CLASS newbutton IMPLEMENTATION.
  METHOD on_button_press.
    DATA lines TYPE i.
    DATA text  TYPE string.
    IF e_salv_function EQ 'SUMM'.
      DESCRIBE TABLE it_pa0008 LINES lines.
      text = lines.
      CONCATENATE text 'lines are displayed' INTO text
        SEPARATED BY space.
      MESSAGE i208(00) WITH text.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  SELECT * FROM pa0008 INTO CORRESPONDING FIELDS OF TABLE it_pa0008 UP TO 15 ROWS.
  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = myalv
        CHANGING
          t_table      = it_pa0008.
    CATCH cx_salv_msg.
  ENDTRY.

  mycolumns = myalv->get_columns( ).
  mycolumns->set_optimize( ).
  myfunctions = myalv->get_functions( ).
  myfunctions->set_all( ).

  TRY.
      mycolumn ?=  mycolumns->get_column( 'PERNR' ).
      mycolumn->set_key( ).
      mycolumn->set_cell_type( if_salv_c_cell_type=>hotspot ).

      mycolumn ?=  mycolumns->get_column( 'BET01' ).
      mycolumn->set_zero( ' ' ).

      mycolumn ?=  mycolumns->get_column( 'SUBTY' ).
      mycolumn->set_technical( 'X' ).

      mycolumn ?=  mycolumns->get_column( 'AEDTM' ).
      mycolumn->set_visible( if_salv_c_bool_sap=>false ).

    CATCH cx_salv_not_found.
  ENDTRY.

  mylayout = myalv->get_layout( ).
  mykey-report = sy-repid.
  mylayout->set_key( mykey ).
  mylayout->set_save_restriction( if_salv_c_layout=>restrict_user_dependant ).
  mylayout->set_default( 'X' ).

  myevents = myalv->get_event( ).
  SET HANDLER myhotspot=>on_click_hotspot FOR myevents.
  SET HANDLER newbutton=>on_button_press  FOR myevents.

  CALL METHOD myalv->set_screen_status
    EXPORTING
      pfstatus = 'SALV_TABLE_CUSTOM_02'
      report   = sy-repid.

  CALL METHOD myalv->display.
