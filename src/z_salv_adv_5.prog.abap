*&---------------------------------------------------------------------*
*& Report Z_SALV_ADV_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_adv_5.

*DATA: o_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
*  DATA: it_spfli TYPE STANDARD TABLE OF spfli WITH DEFAULT KEY.

*  SELECT * FROM spfli INTO CORRESPONDING FIELDS OF TABLE it_spfli.
  SELECT * FROM spfli INTO TABLE @DATA(it_spfli).

  WRITE: / 'GUI-Objekt in der Listanzeige'.

  ULINE.

* freier Custom-Container in der Listenansicht
  DATA(o_cnt) = NEW cl_gui_custom_container( container_name = ''
                                             repid          = 'SAPMSSY0'
                                             dynnr          = '0120' ).
* Position des Containers
  o_cnt->set_top( 50 ).
  o_cnt->set_left( 150 ).
  o_cnt->set_width( 1000 ).
  o_cnt->set_height( 200 ).


* SALV-Grid für Anzeige im Container
  TRY.
      cl_salv_table=>factory( EXPORTING
                                r_container  = o_cnt
                              IMPORTING
                                r_salv_table = DATA(o_alv)
                              CHANGING
                                t_table      = it_spfli ).

      o_alv->display( ).
    CATCH cx_root INTO DATA(e_txt).
      WRITE: / e_txt->get_text( ).
  ENDTRY.

  DO 100 TIMES.
    WRITE: / |{ sy-index } Lorem ipsum.|.
  ENDDO.
