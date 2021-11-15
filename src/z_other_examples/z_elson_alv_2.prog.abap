*&---------------------------------------------------------------------*
*& Report Z_ELSON_ALV_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_alv_2.

INCLUDE z_elson_alv_2_top.  "Global Data
INCLUDE z_elson_alv_2_o01.  "PBO Modules
INCLUDE z_elson_alv_2_i01.  "PAI Modules
INCLUDE z_elson_alv_2_f01.  "FORM Routines

START-OF-SELECTION.

* Now I want to build a field catalog
* First get your data structure into a field symbol

  CREATE DATA dref TYPE s_elements.
  ASSIGN dref->* TO <fs>.

  lr_rtti_struc ?= cl_abap_structdescr=>describe_by_data( <fs> ).

* Now get the structure details into a table.
* Table zogt contains the structure details
* from which we can build the field catalog.

  zogt  = lr_rtti_struc->components.

  LOOP AT zogt INTO zog.

    CLEAR wa_it_fldcat.

    wa_it_fldcat-fieldname = zog-name .
    wa_it_fldcat-datatype  = zog-type_kind.
    wa_it_fldcat-inttype   = zog-type_kind.
    wa_it_fldcat-intlen    = zog-length.
    wa_it_fldcat-decimals  = zog-decimals.
    wa_it_fldcat-coltext   = zog-name.
    wa_it_fldcat-lowercase = 'X'.

    IF wa_it_fldcat-fieldname = 'VBELN'.
      wa_it_fldcat-hotspot = 'X'.
    ENDIF.

    APPEND wa_it_fldcat TO it_fldcat.

  ENDLOOP.

* You can perform any modifications / additions to your field catalog
* here such as your own column names etc.

* Now using the field catalog created above we can
* build a dynamic table
* and populate it

* First build the dynamic table.
* The table will contain entries for
* our structure defined at the start of the program

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = it_fldcat
    IMPORTING
      ep_table        = dy_table.

  ASSIGN dy_table->* TO <dyn_table>.
  CREATE DATA dy_line LIKE LINE OF <dyn_table>.
  ASSIGN dy_line->* TO <dyn_wa>.

* Now fill our table with data
  SELECT vbeln posnr matnr kunnr werks vkorg vkbur
    UP TO 200 ROWS
    FROM vapma
    INTO CORRESPONDING FIELDS OF TABLE <dyn_table>.

* Call the screen to display the grid
  CALL SCREEN 100.
