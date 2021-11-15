*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr20.

*-------Declaring the line type of database tables---------------------*
TABLES: mara, marc, mard.

*------Declaring the types of work areas & internal tables-------------*
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
       END OF ty_mara,

       BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
         xchar TYPE marc-xchar,
       END OF ty_marc,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         pstat TYPE mard-pstat,
       END OF ty_mard,

       BEGIN OF ty_out,
         matnr TYPE marc-matnr, "Material
         werks TYPE marc-werks, "Plant
         lgort TYPE mard-lgort, "Storage Location
         mtart TYPE mara-mtart, "Material Type
         xchar TYPE marc-xchar, "Batch number
         pstat TYPE mard-pstat, "Maintenance Status
       END OF ty_out.

*-----Declaring work areas & internal tables---------------------------*
DATA: wa_mara TYPE ty_mara,
      wa_marc TYPE ty_marc,
      wa_mard TYPE ty_mard,
      wa_out  TYPE ty_out,
      it_mara TYPE STANDARD TABLE OF ty_mara,
      it_marc TYPE STANDARD TABLE OF ty_marc,
      it_mard TYPE STANDARD TABLE OF ty_mard,
      it_out  TYPE STANDARD TABLE OF ty_out,

      v_prog  TYPE sy-repid, "Program name
      v_date  TYPE sy-datum, "Current date
      v_time  TYPE sy-uzeit. "Current time

*----------Declaring constants to avoid the hard codes-----------------*
CONSTANTS: c_material TYPE char12 VALUE 'MATERIAL NO',
           c_plant    TYPE char5  VALUE 'PLANT',
           c_storage  TYPE char8  VALUE 'STORAGE',
           c_type     TYPE char6  VALUE 'M TYPE',
           c_batch    TYPE char6  VALUE 'BATCH',
           c_maint    TYPE char18 VALUE 'MAINTENANCE STATUS',
           c_end      TYPE char40 VALUE 'End of Material Details'.

*------Event initialization--------------------------------------------*
INITIALIZATION.
  v_prog = sy-repid.
  v_date = sy-datum.
  v_time = sy-uzeit.

*-----------Declaring selection screen with select option for input----*
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_matnr FOR mara-matnr.
  SELECTION-SCREEN END OF BLOCK b1.

*-----Event start of selection-----------------------------------------*
START-OF-SELECTION.
  PERFORM get_mara.
  PERFORM get_marc.
  PERFORM get_mard.

*---Event end of selection---------------------------------------------*
END-OF-SELECTION.
  PERFORM get_output.
  PERFORM display.

*---Event top of page--------------------------------------------------*
TOP-OF-PAGE.
  PERFORM top_of_page.

*&---------------------------------------------------------------------*
*&      Form  GET_MARA
*&---------------------------------------------------------------------*
*       Select data from MARA table
*----------------------------------------------------------------------*
FORM get_mara .

  IF s_matnr IS NOT INITIAL.
    SELECT matnr mtart
      FROM mara INTO TABLE it_mara
      WHERE matnr IN s_matnr.

    IF sy-subrc = 0.
      SORT it_mara BY matnr.
    ELSE.
      MESSAGE 'Material doesn''t exist' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_MARA
*&---------------------------------------------------------------------*
*&      Form  GET_MARC
*&---------------------------------------------------------------------*
*       Select data from MARC table
*----------------------------------------------------------------------*
FORM get_marc .

  IF it_mara IS NOT INITIAL. "Prerequisite of FOR ALL ENTRIES IN
    SELECT matnr werks xchar
      FROM marc INTO TABLE it_marc
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr.

    IF sy-subrc = 0.
      SORT it_marc BY matnr.
    ELSE.
      MESSAGE 'Plant doesn''t exist' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_MARC
*&---------------------------------------------------------------------*
*&      Form  GET_MARD
*&---------------------------------------------------------------------*
*       Select data from MARD table
*----------------------------------------------------------------------*
FORM get_mard .

  IF it_marc IS NOT INITIAL. "Prerequisite of FOR ALL ENTRIES IN
    SELECT matnr werks lgort pstat
      FROM mard INTO TABLE it_mard
      FOR ALL ENTRIES IN it_marc
      WHERE matnr = it_marc-matnr
        AND werks = it_marc-werks.

    IF sy-subrc = 0.
      SORT it_mard BY matnr.
    ELSE.
      MESSAGE 'Storage Location doesn''t exist' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_MARD
*&---------------------------------------------------------------------*
*&      Form  GET_OUTPUT
*&---------------------------------------------------------------------*
*       Preparing the output table by using Loop
*----------------------------------------------------------------------*
FORM get_output .

  IF it_mara IS NOT INITIAL.
    LOOP AT it_mara INTO wa_mara.
      wa_out-matnr = wa_mara-matnr.
      wa_out-mtart = wa_mara-mtart.

      LOOP AT it_marc INTO wa_marc
        WHERE matnr = wa_mara-matnr.
        wa_out-werks = wa_marc-werks.
        wa_out-xchar = wa_marc-xchar.

        LOOP AT it_mard INTO wa_mard
          WHERE matnr = wa_marc-matnr
            AND werks = wa_marc-werks.
          wa_out-lgort = wa_mard-lgort.
          wa_out-pstat = wa_mard-pstat.

          APPEND wa_out TO it_out.
          CLEAR: wa_out, wa_mara, wa_marc, wa_mard.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " GET_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       Displaying the classical output by using WRITE statement
*----------------------------------------------------------------------*
FORM display .

  IF it_out IS NOT INITIAL.
    LOOP AT it_out INTO wa_out.

      AT FIRST. "Control break statement – display one time at first
        WRITE: /  c_material,
               21 c_plant,
               27 c_storage,
               37 c_type,
               45 c_batch,
               54 c_maint.
        ULINE.
        SKIP.
      ENDAT.

      WRITE: /  wa_out-matnr,
             21 wa_out-werks,
             27 wa_out-lgort,
             37 wa_out-mtart,
             45 wa_out-xchar,
             54 wa_out-pstat.

      IF wa_out-matnr IS INITIAL.
        AT END OF matnr. "Control break statement
          SKIP.
        ENDAT.
      ENDIF.

      AT LAST. "Control break statement – display one time at last
        ULINE.
        WRITE: / c_end.
      ENDAT.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " DISPLAY
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       Top of page of Classical output
*----------------------------------------------------------------------*
FORM top_of_page .

  WRITE: / v_prog,
         / v_date DD/MM/YYYY,
         / v_time.
  ULINE.

ENDFORM.                    " TOP_OF_PAGE
