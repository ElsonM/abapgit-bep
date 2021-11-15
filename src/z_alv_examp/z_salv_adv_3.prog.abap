*&---------------------------------------------------------------------*
*& Report Z_SALV_ADV_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_adv_3.

CLASS lcl_popup_msg_box DEFINITION.

  PUBLIC SECTION.
* Typ Textzeile
    TYPES: BEGIN OF ty_textline,
             idx  TYPE rspos,
             text TYPE bapi_msg,
           END OF ty_textline.

    TYPES: ty_it_messagetab TYPE STANDARD TABLE OF ty_textline WITH DEFAULT KEY.

* Typ Button-Event
    TYPES: ty_it_events TYPE STANDARD TABLE OF cntl_simple_event WITH DEFAULT KEY.

* Anzeige des Popups
    CLASS-METHODS show
      IMPORTING
        i_window_title   TYPE string
        i_window_top     TYPE i
        i_window_left    TYPE i
        i_window_width   TYPE i
        i_window_height  TYPE i
        i_show_functions TYPE boolean
        i_it_messages    TYPE ty_it_messagetab
      RETURNING
        VALUE(rv_ok)     TYPE boolean.

  PRIVATE SECTION.

* Button Funktionskonstanten
    CONSTANTS: co_btn_ok TYPE ui_func VALUE 'BTN_OK'.
    CONSTANTS: co_btn_cancel TYPE ui_func VALUE 'BTN_CANCEL'.

* Message-Tabelle
    CLASS-DATA: it_messages TYPE ty_it_messagetab.

* GUI-Objekte
    CLASS-DATA: o_cnt   TYPE REF TO cl_gui_dialogbox_container.
*    CLASS-DATA: o_salv  TYPE REF TO cl_salv_table.
*    CLASS-DATA: o_split TYPE REF TO cl_gui_splitter_container.
*    CLASS-DATA: o_tool  TYPE REF TO cl_gui_toolbar.
    CLASS-DATA: gv_retval TYPE boolean VALUE abap_false.

* on_close-Handler
    CLASS-METHODS:
      on_close FOR EVENT close OF cl_gui_dialogbox_container
        IMPORTING
          sender.

* on_function_selected Handler
    CLASS-METHODS:
      on_function_selected FOR EVENT function_selected OF cl_gui_toolbar
        IMPORTING
          fcode
          sender.

ENDCLASS.

CLASS lcl_popup_msg_box IMPLEMENTATION.

  METHOD show.

    it_messages = i_it_messages.

* Container für GUI-Elemente
    o_cnt = NEW #( parent                  = cl_gui_container=>default_screen
                   caption                 = |{ i_window_title }|
                   top                     = i_window_top
                   left                    = i_window_left
                   width                   = i_window_width
                   height                  = i_window_height
                   no_autodef_progid_dynnr = abap_true ).

* on_close-Handler setzen
    SET HANDLER on_close FOR o_cnt.

* Splitter für Grid und Toolbar
    DATA(o_split) = NEW cl_gui_splitter_container(
      parent                  = o_cnt
      no_autodef_progid_dynnr = abap_true
      rows                    = 2
      columns                 = 1 ).

* Unteren Splitterbereich setzen
    o_split->set_row_sash( id    = 2
                           type  = cl_gui_splitter_container=>type_movable
                           value = cl_gui_splitter_container=>false ).

    o_split->set_row_sash( id    = 2
                           type  = cl_gui_splitter_container=>type_sashvisible
                           value = cl_gui_splitter_container=>false ).

    o_split->set_row_height( id = 2 height = 8 ).

* Oberen und unteren Splittercontainer holen
    DATA(o_container_top)    = o_split->get_container( row = 1 column = 1 ).
    DATA(o_container_bottom) = o_split->get_container( row = 2 column = 1 ).

* Toolbar für Buttons erzeugen
    DATA(o_tool) = NEW cl_gui_toolbar( parent       = o_container_bottom
                                       display_mode = cl_gui_toolbar=>m_mode_horizontal
                                       align_right  = 1 ).

* Toolbarevents
    DATA(it_events) = VALUE ty_it_events(
      ( eventid    = cl_gui_toolbar=>m_id_function_selected
        appl_event = abap_true ) ).

    o_tool->set_registered_events( events = it_events ).

* Buttons + Separator einfügen
    o_tool->add_button( fcode       = co_btn_ok
                        icon        = icon_okay
                        butn_type   = cntb_btype_button
                        text        = 'Ok'
                        quickinfo   = 'Ok'
                        is_checked  = abap_false
                        is_disabled = abap_false ).

    o_tool->add_button( fcode       = ''
                        icon        = ''
                        butn_type   = cntb_btype_sep
                        text        = ''
                        quickinfo   = ''
                        is_checked  = abap_false
                        is_disabled = abap_false ).

    o_tool->add_button( fcode       = co_btn_cancel
                        icon        = icon_cancel
                        butn_type   = cntb_btype_button
                        text        = 'Abbruch'
                        quickinfo   = 'Abbruch'
                        is_checked  = abap_false
                        is_disabled = abap_false ).

* on_function_selected-Handler
    SET HANDLER on_function_selected FOR o_tool.

* SALV-Grid im oberen Splitter einfügen
    cl_salv_table=>factory( EXPORTING
                              r_container  = o_container_top
                            IMPORTING
                              r_salv_table = DATA(o_salv)
                            CHANGING
                              t_table      = it_messages ).

* Eigenschaften SALV-Grid
    o_salv->get_columns( )->set_optimize( abap_true ).
    o_salv->get_display_settings( )->set_striped_pattern( abap_true ).
    IF i_show_functions = abap_true.
      o_salv->get_functions( )->set_all( ).
    ENDIF.
    o_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
    o_salv->display( ).

* Dummy-Screen aufrufen und somit cl_gui_container=>default_screen erzeugen -> Trägerdynpro für cl_gui_dialogbox_container
    CALL SCREEN 100.

* nach Buttonclick noch die Ergebnisrückgabe
    rv_ok = gv_retval.
  ENDMETHOD.

  METHOD on_close.

* cl_gui_dialogbox_container bei Klick auf Schließen-Kreuz schließen
    IF sender IS NOT INITIAL.
      sender->free( ).
    ENDIF.

* Zum aufrufenden Dynpro zurück
    LEAVE TO SCREEN 0.

  ENDMETHOD.

* Button ermitteln -> Reaktion -> Setzen des Rückgabewertes beim Schließen des Popups
  METHOD on_function_selected.
    CASE fcode.
      WHEN co_btn_ok.
        gv_retval = abap_true.
      WHEN co_btn_cancel.
        gv_retval = abap_false.
    ENDCASE.

* Popup-Fenster schließen
    on_close( o_cnt ).
  ENDMETHOD.
ENDCLASS.

*Dummy-Screen für cl_gui_container=>default_screen deklarieren
SELECTION-SCREEN BEGIN OF SCREEN 100.
SELECTION-SCREEN END OF SCREEN 100.

START-OF-SELECTION.

* Nachrichtentabelle erzeugen
  DATA(it_msg) = VALUE lcl_popup_msg_box=>ty_it_messagetab(
   ( idx = 1 text = 'Nachricht 1' )
   ( idx = 2 text = 'Nachricht 2' ) ).

* Popup mit Nachrichten anzeigen
  IF abap_true = lcl_popup_msg_box=>show(
                   EXPORTING
                     i_window_title   = 'Meldungen'
                     i_window_top     = 100
                     i_window_left    = 100
                     i_window_width   = 240
                     i_window_height  = 240
                     i_show_functions = abap_false
                     i_it_messages    = it_msg ).
    WRITE: / 'OK.'.
  ELSE.
    WRITE: / 'Abbruch.'.
  ENDIF.
