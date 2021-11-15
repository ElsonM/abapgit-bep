*&---------------------------------------------------------------------*
*& Report Z_ELSON_UPLOAD
*& Program to upload a flat file from path provided
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_upload.

*———————————————————————*
* Data declarations
*———————————————————————*
TYPES: BEGIN OF lty_ttab,
         rec TYPE string,
       END OF lty_ttab.
DATA: lt_itab TYPE STANDARD TABLE OF lty_ttab WITH HEADER LINE.
DATA: lv_file_str TYPE string,
      lv_column   TYPE n LENGTH 4.
*Dynamic Table and Work area
FIELD-SYMBOLS :
  <lfs_table>   TYPE ANY TABLE,
  <lfs_watable> .

DATA : lv_tabname TYPE dd02l-tabname. " DataBase Table Name
DATA : lt_tble TYPE REF TO data,
       lt_line TYPE REF TO data.
"Structure for Reading Field Names of DataBase Table
TYPES : BEGIN OF lty_dd03vv,
          tabname   TYPE tabname,
          fieldname TYPE fieldname,
          position  TYPE tabfdpos,
        END OF lty_dd03vv .
"internal table and work area for reading field names of database table
DATA : lt_dd03vv  TYPE STANDARD TABLE OF lty_dd03vv WITH HEADER LINE,
       lwa_dd03vv LIKE LINE OF lt_dd03vv.
DATA : lv_fieldname  TYPE fieldname,
       lv_counter(2) TYPE n VALUE 0.

FIELD-SYMBOLS: <lfs_field_from>.
*———————————————————————-*
* selection screen design
*———————————————————————-*
SELECTION-SCREEN BEGIN OF BLOCK bi WITH FRAME TITLE  txt_t1 .
SELECTION-SCREEN BEGIN OF LINE .
SELECTION-SCREEN COMMENT (25) txt_file .
PARAMETERS: lp_file TYPE localfile.
SELECTION-SCREEN END OF LINE .

SELECTION-SCREEN BEGIN OF LINE .
SELECTION-SCREEN COMMENT (25) txt_tabl .
PARAMETERS: lp_tble LIKE lv_tabname.
SELECTION-SCREEN END OF LINE .
SELECTION-SCREEN SKIP 1 .

SELECTION-SCREEN BEGIN OF LINE .
PARAMETERS : cb_hdr AS CHECKBOX  DEFAULT 'x' MODIF ID m1.
SELECTION-SCREEN COMMENT (70) txt_warn MODIF ID m1.
SELECTION-SCREEN END OF LINE .

SELECTION-SCREEN END OF BLOCK bi.
*———————————————————————-*
* At selection screen for field
*———————————————————————-*
INITIALIZATION .
  txt_file = 'file path  '.
  txt_t1  = 'file upload details '.
  txt_tabl = 'target table Name '.
  txt_warn = 'ignore Header Line in file uploading .'.
*———————————————————————-*
* Read File Path
*———————————————————————-*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR lp_file.
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    EXPORTING
      static    = 'X'
    CHANGING
      file_name = lp_file.
*———————————————————————-*
* Validation
*———————————————————————-*
AT SELECTION-SCREEN ON BLOCK bi .
  IF  lp_tble IS INITIAL.
    MESSAGE 'Target Table Name cannot be Empty.' TYPE 'E'.
  ENDIF.

*———————————————————————-*
* Start of selection
*———————————————————————-*

START-OF-SELECTION.
  lv_file_str = lp_file.

*FM to read file content from path provided
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_file_str
    TABLES
      data_tab                = lt_itab
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE 'file could not be uploaded' TYPE 'E'.
  ENDIF.

*———————————————————————-*
* Dynamic Internal Table and Work Area creation
*———————————————————————-*

  IF lp_tble IS NOT INITIAL.

    lv_tabname = lp_tble.
    "check if table exist in data dictionary and no of columns in table

    SELECT COUNT(*)
    FROM dd03vv
    INTO  lv_counter
    WHERE tabname = lv_tabname
    AND as4local = 'A' .

    IF sy-subrc = 0 AND lv_counter GT 0 .

      "dynamic internal table defination
      CREATE DATA lt_tble TYPE TABLE OF (lp_tble).
      ASSIGN lt_tble->* TO <lfs_table> .

      "dynamic work area defination
      CREATE DATA lt_line LIKE LINE OF <lfs_table>.
      ASSIGN lt_line->* TO <lfs_watable> .

      SELECT
      tabname
      fieldname
      position
      FROM dd03vv
      INTO TABLE lt_dd03vv
      WHERE tabname = lv_tabname
      AND as4local = 'A' .

      SORT lt_dd03vv BY  position .
*———————————————————————-*
* Assign Data to Internal Table via Work Area
*———————————————————————-*
      LOOP AT lt_itab.
        " ignore header row if checkbox is checked
        IF cb_hdr = 'x'.

          cb_hdr = ''.
        ELSE.
          "read field name from internal table one by one
          DO  lv_counter TIMES.
            READ TABLE lt_dd03vv INTO lwa_dd03vv
            WITH KEY position = sy-index BINARY SEARCH .
            lv_fieldname =  lwa_dd03vv-fieldname.

            "assign data to each field
            ASSIGN COMPONENT lv_fieldname OF STRUCTURE
            <lfs_watable> TO <lfs_field_from>.

          ENDDO.

          "insert row into dynamic internal table
          INSERT <lfs_watable> INTO TABLE  <lfs_table> .
        ENDIF.
      ENDLOOP.
*———————————————————————-*
***——- Modify Database tabe with Internal table ——-***
*   If record already exist it will be update ,
*   else new entry will get created
*———————————————————————-*

      MODIFY (lp_tble) FROM TABLE  <lfs_table>.
      IF sy-subrc = 0.
        WRITE : 'table ',lp_tble ,'successfully updated'.
      ENDIF.
    ELSE .

      MESSAGE 'table not found in DATA dictionary .' TYPE 'E'.

    ENDIF.

  ENDIF.
*———————————————————————-*
* End Of Program
*———————————————————————-*
