*&---------------------------------------------------------------------*
*& Report Z_ELSON_UPLOAD_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_upload_1 LINE-SIZE 255.

* Data
DATA: it_dd03p TYPE TABLE OF dd03p,
      is_dd03p TYPE dd03p.

DATA: it_rdata TYPE TABLE OF text1024,
      is_rdata TYPE text1024.

DATA: it_fields TYPE TABLE OF fieldname.

DATA: it_file TYPE REF TO data,
      is_file TYPE REF TO data.

DATA: w_error TYPE text132.


* Macros
DEFINE write_error.
  CONCATENATE 'Error: table'
                          p_table
                          &1
                          &2
                   INTO w_error
    SEPARATED BY space.
  CONDENSE w_error.
   WRITE: / w_error.
   STOP.
END-OF-DEFINITION.


* Field symbols
FIELD-SYMBOLS: <table> TYPE STANDARD TABLE,
               <data>  TYPE any,
               <fs>    TYPE any.

* Selection screen
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
PARAMETERS: p_file  TYPE localfile DEFAULT 'C:\temp\' OBLIGATORY,
            p_separ TYPE c DEFAULT ';' OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK b01.

SELECTION-SCREEN: BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
PARAMETERS: p_table TYPE tabname OBLIGATORY
MEMORY ID dtb
MATCHCODE OBJECT dd_dbtb_16.
SELECTION-SCREEN: END OF BLOCK b02.

SELECTION-SCREEN: BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-b03.
PARAMETERS: p_create TYPE c AS CHECKBOX.
SELECTION-SCREEN: END OF BLOCK b03,
SKIP.

SELECTION-SCREEN: BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-b04.
PARAMETERS: p_nodb RADIOBUTTON GROUP g1 DEFAULT 'X'
USER-COMMAND rg1,
            p_save RADIOBUTTON GROUP g1,
            p_dele RADIOBUTTON GROUP g1.
SELECTION-SCREEN: SKIP.
PARAMETERS: p_test TYPE c AS CHECKBOX,
            p_list TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: END OF BLOCK b04.


* At selection screen
AT SELECTION-SCREEN.
  IF sy-ucomm = 'RG1'.
    IF p_nodb IS INITIAL.
      p_test = 'X'.
    ENDIF.
  ENDIF.


* At selection screen
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.


* Start of selection
START-OF-SELECTION.

  PERFORM f_table_definition USING p_table.

  PERFORM f_upload_data USING p_file.

  PERFORM f_prepare_table USING p_table.

  PERFORM f_process_data.

  IF p_nodb IS INITIAL.
    PERFORM f_modify_table.
  ENDIF.

  IF p_list = 'X'.
    PERFORM f_list_records.
  ENDIF.

* End of selection
END-OF-SELECTION.


*---------------------------------------------------------------------*
* FORM f_table_definition *
*---------------------------------------------------------------------*
* --> VALUE(IN_TABLE) *
*---------------------------------------------------------------------*
FORM f_table_definition USING VALUE(in_table).
  DATA: l_tname TYPE tabname,
        l_state TYPE ddgotstate,
        l_dd02v TYPE dd02v.

  l_tname = in_table.
  CALL FUNCTION 'DDIF_TABL_GET'
    EXPORTING
      name          = l_tname
    IMPORTING
      gotstate      = l_state
      dd02v_wa      = l_dd02v
    TABLES
      dd03p_tab     = it_dd03p
    EXCEPTIONS
      illegal_input = 1
      OTHERS        = 2.
  IF l_state NE 'A'.
    write_error 'does not exist or is not active' space.
  ENDIF.
  IF l_dd02v-tabclass NE 'TRANSP' AND
  l_dd02v-tabclass NE 'CLUSTER'.
    write_error 'is type' l_dd02v-tabclass.
  ENDIF.
ENDFORM.


*---------------------------------------------------------------------*
* FORM f_prepare_table *
*---------------------------------------------------------------------*
* --> VALUE(IN_TABLE) *
*---------------------------------------------------------------------*
FORM f_prepare_table USING VALUE(in_table).
  DATA: l_tname TYPE tabname,
        lt_ftab TYPE lvc_t_fcat.

  l_tname = in_table.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = l_tname
    CHANGING
      ct_fieldcat      = lt_ftab
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc NE 0.
    WRITE: / 'Error while building field catalog'.
    STOP.
  ENDIF.

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = lt_ftab
    IMPORTING
      ep_table        = it_file.

  ASSIGN it_file->* TO <table>.
  CREATE DATA is_file LIKE LINE OF <table>.
  ASSIGN is_file->* TO <data>.

ENDFORM.


*---------------------------------------------------------------------*
* FORM f_upload_data *
*---------------------------------------------------------------------*
* --> VALUE(IN_FILE) *
*---------------------------------------------------------------------*
FORM f_upload_data USING VALUE(in_file).
  DATA: l_file  TYPE string,
        l_ltext TYPE string.

  DATA: l_lengt TYPE i,
        l_field TYPE fieldname.

  DATA: l_missk TYPE c.

  l_file = in_file.
  l_lengt = strlen( in_file ).

  FORMAT INTENSIFIED ON.
  WRITE: / 'Reading file', in_file(l_lengt).
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename = l_file
      filetype = 'ASC'
    TABLES
      data_tab = it_rdata
    EXCEPTIONS
      OTHERS   = 1.
  IF sy-subrc <> 0.
    WRITE: /3 'Error uploading', l_file.
    STOP.
  ENDIF.

* File not empty
  DESCRIBE TABLE it_rdata LINES sy-tmaxl.
  IF sy-tmaxl = 0.
    WRITE: /3 'File', l_file, 'is empty'.
    STOP.
  ELSE.
    WRITE: '-', sy-tmaxl, 'rows read'.
  ENDIF.

* File header on first row
  READ TABLE it_rdata INTO is_rdata INDEX 1.
  l_ltext = is_rdata.
  WHILE l_ltext CS p_separ.
    SPLIT l_ltext AT p_separ INTO l_field l_ltext.
    APPEND l_field TO it_fields.
  ENDWHILE.
  IF sy-subrc = 0.
    l_field = l_ltext.
    APPEND l_field TO it_fields.
  ENDIF.

* Check all key fields are present
  SKIP.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING.
  WRITE: /3 'Key fields'.
  FORMAT RESET.
  LOOP AT it_dd03p INTO is_dd03p WHERE NOT keyflag IS INITIAL.
    WRITE: /3 is_dd03p-fieldname.
    READ TABLE it_fields WITH KEY table_line = is_dd03p-fieldname
    TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      FORMAT COLOR COL_POSITIVE.
      WRITE: 'ok'.
      FORMAT RESET.
    ELSEIF is_dd03p-datatype NE 'CLNT'.
      FORMAT COLOR COL_NEGATIVE.
      WRITE: 'error'.
      FORMAT RESET.
      l_missk = 'X'.
    ENDIF.
  ENDLOOP.

* Log other fields
  SKIP.
  FORMAT COLOR COL_HEADING.
  WRITE: /3 'Other fields'.
  FORMAT RESET.
  LOOP AT it_dd03p INTO is_dd03p WHERE keyflag IS INITIAL.
    WRITE: /3 is_dd03p-fieldname.
    READ TABLE it_fields WITH KEY table_line = is_dd03p-fieldname
    TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      WRITE: 'X'.
    ENDIF.
  ENDLOOP.

* Missing key field
  IF l_missk = 'X'.
    SKIP.
    WRITE: /3 'Missing key fields - no further processing'.
    STOP.
  ENDIF.

ENDFORM.


*---------------------------------------------------------------------*
* FORM f_process_data *
*---------------------------------------------------------------------*
FORM f_process_data.
  DATA: l_ltext TYPE string,
        l_stext TYPE text40,
        l_field TYPE fieldname,
        l_datat TYPE c.

  LOOP AT it_rdata INTO is_rdata FROM 2.
    l_ltext = is_rdata.
    LOOP AT it_fields INTO l_field.
      ASSIGN COMPONENT l_field OF STRUCTURE <data> TO <fs>.
      IF sy-subrc = 0.
* Field value comes from file, determine conversion
        DESCRIBE FIELD <fs> TYPE l_datat.
        CASE l_datat.
          WHEN 'N'.
            SPLIT l_ltext AT p_separ INTO l_stext l_ltext.
            WRITE l_stext TO <fs> RIGHT-JUSTIFIED.
            OVERLAY <fs> WITH '0000000000000000'. "max 16
          WHEN 'P'.
            SPLIT l_ltext AT p_separ INTO l_stext l_ltext.
            TRANSLATE l_stext USING ',.'.
            <fs> = l_stext.
          WHEN 'F'.
            SPLIT l_ltext AT p_separ INTO l_stext l_ltext.
            TRANSLATE l_stext USING ',.'.
            <fs> = l_stext.
          WHEN 'D'.
            SPLIT l_ltext AT p_separ INTO l_stext l_ltext.
            TRANSLATE l_stext USING '/.-.'.
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                date_external = l_stext
              IMPORTING
                date_internal = <fs>
              EXCEPTIONS
                OTHERS        = 1.
          WHEN 'T'.
            CALL FUNCTION 'CONVERT_TIME_INPUT'
              EXPORTING
                input  = l_stext
              IMPORTING
                output = <fs>
              EXCEPTIONS
                OTHERS = 1.
          WHEN OTHERS.
            SPLIT l_ltext AT p_separ INTO <fs> l_ltext.
        ENDCASE.
      ELSE.
        SHIFT l_ltext UP TO p_separ.
        SHIFT l_ltext.
      ENDIF.
    ENDLOOP.
    IF NOT <data> IS INITIAL.
      LOOP AT it_dd03p INTO is_dd03p WHERE datatype = 'CLNT'.
* This field is mandant
        ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
        TO <fs>.
        <fs> = sy-mandt.
      ENDLOOP.
      IF p_create = 'X'.
        IF is_dd03p-rollname = 'ERDAT'.
          ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
          TO <fs>.
          <fs> = sy-datum.
        ENDIF.
        IF is_dd03p-rollname = 'ERZET'.
          ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
          TO <fs>.
          <fs> = sy-uzeit.
        ENDIF.
        IF is_dd03p-rollname = 'ERNAM'.
          ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
          TO <fs>.
          <fs> = sy-uname.
        ENDIF.
      ENDIF.
      IF is_dd03p-rollname = 'AEDAT'.
        ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
        TO <fs>.
        <fs> = sy-datum.
      ENDIF.
      IF is_dd03p-rollname = 'AETIM'.
        ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
        TO <fs>.
        <fs> = sy-uzeit.
      ENDIF.
      IF is_dd03p-rollname = 'AENAM'.
        ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data>
        TO <fs>.
        <fs> = sy-uname.
      ENDIF.
      APPEND <data> TO <table>.
    ENDIF.
  ENDLOOP.
ENDFORM.


*---------------------------------------------------------------------*
* FORM f_modify_table *
*---------------------------------------------------------------------*
FORM f_modify_table.
  SKIP.
  IF p_save = 'X'.
    MODIFY (p_table) FROM TABLE <table>.
  ELSEIF p_dele = 'X'.
    DELETE (p_table) FROM TABLE <table>.
  ELSE.
    EXIT.
  ENDIF.

  IF sy-subrc EQ 0.
    FORMAT COLOR COL_POSITIVE.
    IF p_save = 'X'.
      WRITE: /3 'Modify table OK'.
    ELSE.
      WRITE: /3 'Delete table OK'.
    ENDIF.
    FORMAT RESET.
    IF p_test IS INITIAL.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      WRITE: '- test only, no update'.
    ENDIF.
  ELSE.
    FORMAT COLOR COL_NEGATIVE.
    WRITE: /3 'Error while modifying table'.
    FORMAT RESET.
  ENDIF.
ENDFORM.


*---------------------------------------------------------------------*
* FORM f_list_records *
*---------------------------------------------------------------------*
FORM f_list_records.
  DATA: l_tleng TYPE i,
        l_lasti TYPE i,
        l_offst TYPE i.

* Output width
  l_tleng = 1.
  LOOP AT it_dd03p INTO is_dd03p.
    l_tleng = l_tleng + is_dd03p-outputlen.
    IF l_tleng LT sy-linsz.
      l_lasti = sy-tabix.
      l_tleng = l_tleng + 1.
    ELSE.
      l_tleng = l_tleng - is_dd03p-outputlen.
      EXIT.
    ENDIF.
  ENDLOOP.

* Output header
  SKIP.
  FORMAT COLOR COL_HEADING.
  WRITE: /3 'Contents'.
  FORMAT RESET.
  ULINE AT /3(l_tleng).

* Output records
  LOOP AT <table> ASSIGNING <data>.
    LOOP AT it_dd03p INTO is_dd03p FROM 1 TO l_lasti.
      IF is_dd03p-position = 1.
        WRITE: /3 sy-vline.
        l_offst = 3.
      ENDIF.
      ASSIGN COMPONENT is_dd03p-fieldname OF STRUCTURE <data> TO <fs>.
      l_offst = l_offst + 1.
      IF is_dd03p-decimals LE 2.
        WRITE: AT l_offst <fs>.
      ELSE.
        WRITE: AT l_offst <fs> DECIMALS 3.
      ENDIF.
      l_offst = l_offst + is_dd03p-outputlen.
      WRITE: AT l_offst sy-vline.
    ENDLOOP.
  ENDLOOP.

* Output end
  ULINE AT /3(l_tleng).

ENDFORM.
