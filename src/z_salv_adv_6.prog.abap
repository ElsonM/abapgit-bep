*&---------------------------------------------------------------------*
*& Report Z_SALV_ADV_6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_adv_6.

TYPES: ty_it_events TYPE STANDARD TABLE OF cntl_simple_event WITH DEFAULT KEY.

CLASS lcl_events DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_function_selected FOR EVENT function_selected OF cl_gui_toolbar
        IMPORTING
            fcode
            sender.
ENDCLASS.

CLASS lcl_events IMPLEMENTATION.
* Toolbar: Button oder Menüpunkt geklickt
  METHOD on_function_selected.

* Funktionscode auswerten
    CASE fcode.
      WHEN 'BTN_CLOSE'.
        LEAVE PROGRAM.
      WHEN 'M1'.
      WHEN 'M2'.
    ENDCASE.

* fcode ausgeben
    MESSAGE fcode TYPE 'S'.

  ENDMETHOD.
ENDCLASS.

INITIALIZATION.

* Splitter erzeugen
  DATA(o_splitter) = NEW cl_gui_splitter_container(
    parent                  = cl_gui_container=>default_screen
    no_autodef_progid_dynnr = abap_true
    rows                    = 2
    columns                 = 1 ).

* Absoluter Modus für Zeilenhöhe
  o_splitter->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).

* Höhe absolut 24 Pixel für Splitter oben
  o_splitter->set_row_height( id = 1 height = 24 ).

* Splitter für oberen Container fest und verborgen
  o_splitter->set_row_sash( id    = 1
                            type  = cl_gui_splitter_container=>type_movable
                            value = cl_gui_splitter_container=>false ).

  o_splitter->set_row_sash( id    = 1
                            type  = cl_gui_splitter_container=>type_sashvisible
                            value = cl_gui_splitter_container=>false ).

  DATA(o_container_top) = o_splitter->get_container( row = 1 column = 1 ).
  DATA(o_container_bottom) = o_splitter->get_container( row = 2 column = 1 ).

* Toolbar hoizontal
  DATA(o_tool) = NEW cl_gui_toolbar( parent       = o_container_top
                                     display_mode = cl_gui_toolbar=>m_mode_horizontal ).

* Eventtypten müssen gesondert registriert werden
  DATA(it_events) = VALUE ty_it_events( ( eventid    = cl_gui_toolbar=>m_id_function_selected
                                          appl_event = abap_true ) ).

  o_tool->set_registered_events( events = it_events ).

* Toolbar-Buttons und Menüs hinzufügen
* Buttontypen sind in Typgruppe CNTB definiert
  o_tool->add_button( fcode       = 'BTN_MENU'
                      icon        = icon_activate
                      butn_type   = cntb_btype_menu
                      text        = 'Menü'
                      quickinfo   = 'Menü anzeigen'
                      is_checked  = abap_false
                      is_disabled = abap_false ).

* statisches Kontextmenü für Button "BTN_MENU" erstellen
  DATA(o_menu) = NEW cl_ctmenu( ).
  o_menu->add_function( fcode   = 'M1'
                        checked = abap_false
                        text    = 'Punkt1' ).

  o_menu->add_function( fcode   = 'M2'
                        checked = abap_false
                        text    = 'Punkt2' ).

* statisches Kontextmenü mit Button verknüpfen, Zuordnung erfolgt über den Namen
* daher muss "function" gleich "fcode" des Menü-Buttons sein, sonst Exception
  DATA(it_ctxmenu) = VALUE ttb_btnmnu( ( function = 'BTN_MENU'
                                         ctmenu   = o_menu ) ).

* siehe auch Methode "set_static_ctxmenu"
  o_tool->assign_static_ctxmenu_table( it_ctxmenu ).

* Separator
  o_tool->add_button( fcode       = ''
                      icon        = ''
                      butn_type   = cntb_btype_sep
                      text        = ''
                      quickinfo   = ''
                      is_checked  = abap_false
                      is_disabled = abap_false ).

* Schließen-Button
  o_tool->add_button( fcode       = 'BTN_CLOSE'
                      icon        = icon_close
                      butn_type   = cntb_btype_button
                      text        = 'Schließen'
                      quickinfo   = 'Schließen'
                      is_checked  = abap_false
                      is_disabled = abap_false ).

* Eventhandler registrieren
  SET HANDLER lcl_events=>on_function_selected FOR o_tool.

* im unteren Splitter Beispieldaten anzeigen
  DATA: it_sflight TYPE STANDARD TABLE OF sflight.

  SELECT * FROM sflight INTO TABLE @it_sflight.

  DATA: o_salv TYPE REF TO cl_salv_table.

  cl_salv_table=>factory( EXPORTING
                            r_container  = o_container_bottom
                          IMPORTING
                            r_salv_table = o_salv
                          CHANGING
                            t_table      = it_sflight ).

  o_salv->get_functions( )->set_all( ).
  o_salv->display( ).

* leere Standard-Toolbar ausblenden
  cl_abap_list_layout=>suppress_toolbar( ).

* Ausgabe von cl_gui_container=>default_screen erzwingen
  WRITE: space.
