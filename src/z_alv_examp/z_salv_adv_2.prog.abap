*&---------------------------------------------------------------------*
*& Report Z_SALV_ADV_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_adv_2.

START-OF-SELECTION.
* Daten holen
  SELECT *
    INTO TABLE @DATA(it_spfli)
    FROM spfli
    WHERE carrid = 'LH'.

* ALV-Gitter-Objekt erzeugen
  DATA(o_alv) = NEW cl_gui_alv_grid( i_parent      = cl_gui_container=>default_screen " In default container einbetten
                                     i_appl_events = abap_true ).                     " Ereignisse als Applikationsevents registrieren

* Feldkatalog automatisch durch SALV-Objekte erstellen lassen
*  DATA: o_salv TYPE REF TO cl_salv_table.

  cl_salv_table=>factory( IMPORTING
                            r_salv_table = DATA(o_salv)
                          CHANGING
                            t_table      = it_spfli ).

  DATA(it_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = o_salv->get_columns( )
                                                                     r_aggregations = o_salv->get_aggregations( ) ).

* Layout des ALV setzen
  DATA(lv_layout) = VALUE lvc_s_layo( zebra      = abap_true             " ALV-Control: Alternierende Zeilenfarbe (Zebramuster)
                                      cwidth_opt = 'A'                   " ALV-Control: Spaltenbreite optimieren
                                      grid_title = 'Flugverbindungen' ). " ALV-Control: Text der Titelzeile

* ALV anzeigen
  o_alv->set_table_for_first_display( EXPORTING
                                        i_bypassing_buffer = abap_false  " Puffer ausschalten
                                        i_save             = 'A'         " Anzeigevariante sichern
                                        is_layout          = lv_layout   " Layout
                                      CHANGING
                                        it_fieldcatalog    = it_fcat     " Feldkatalog
                                        it_outtab          = it_spfli ). " Ausgabetabelle

* Focus auf ALV setzen
  cl_gui_alv_grid=>set_focus( control = o_alv ).

* leere SAP-Toolbar ausblenden
  cl_abap_list_layout=>suppress_toolbar( ).

* erzwingen von cl_gui_container=>default_screen
  WRITE: space.
