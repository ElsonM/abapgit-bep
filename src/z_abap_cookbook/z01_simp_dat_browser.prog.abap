*&---------------------------------------------------------------------*
*& Report Z_SIMP_DAT_BROWSER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT z01_simp_dat_browser NO STANDARD PAGE HEADING LINE-SIZE 500.

PARAMETERS: myt_name(30) DEFAULT 'LFA1',
            rows         TYPE i,
            columns      TYPE i.

TYPES: BEGIN OF ty_positions,
         position TYPE i,
       END OF ty_positions.

DATA: it_positions TYPE TABLE OF ty_positions,
      wa_positions TYPE          ty_positions,
      end_position TYPE          i.

DATA: tab_reference   TYPE REF TO data,
      struc_reference TYPE REF TO data.

FIELD-SYMBOLS: <my_struc> TYPE any,
               <my_field> TYPE any,
               <my_itab>  TYPE ANY TABLE.

*DATA: descr TYPE REF TO cl_abap_structdescr.
*DATA: wa_header TYPE LINE OF abap_compdescr_tab.

DATA: temp_line LIKE sy-linno.

START-OF-SELECTION.

  CHECK columns GE 1.

  TRY.
      CREATE DATA tab_reference TYPE STANDARD TABLE OF (myt_name) WITH NON-UNIQUE DEFAULT KEY.
      ASSIGN tab_reference->* TO <my_itab>.

      CREATE DATA struc_reference TYPE (myt_name).
      ASSIGN struc_reference->* TO <my_struc>.

      SELECT * FROM (myt_name) INTO TABLE <my_itab> UP TO rows ROWS.

*      descr ?= cl_abap_typedescr=>describe_by_data( <my_struc> ). "descr->components saves the fields of the table
      DATA(struct_components) = CAST cl_abap_structdescr(
                                  cl_abap_typedescr=>describe_by_data( <my_struc> ) )->components.

      SKIP.                                                       "Line at the begining of the table will be written here
                                                                  "---> We need to find its length and save it in end_position
      wa_positions-position = 1.
      LOOP AT struct_components INTO DATA(wa_header) FROM 1 TO columns.
        WRITE AT wa_positions-position '|'.
        IF wa_header-length LT 10.
          wa_header-length = 10.
        ENDIF.
        WRITE wa_header-name.
        APPEND wa_positions TO it_positions.
        wa_positions-position = wa_header-length + wa_positions-position.
      ENDLOOP.
      end_position = wa_positions-position + 1.
      WRITE AT end_position '|'.

      NEW-LINE.

      temp_line = sy-linno.            "Third line is saved in the variable temp_line

      SKIP TO LINE 1.
      ULINE AT 1(end_position).
      SKIP TO LINE temp_line.
      ULINE AT 1(end_position).        "Print lines below and above the table header

      CLEAR wa_positions.
      FORMAT COLOR COL_NORMAL ON.

      LOOP AT <my_itab> INTO <my_struc>.
        NEW-LINE.
        DO columns TIMES.
          READ TABLE it_positions INDEX sy-index INTO wa_positions.
          ASSIGN COMPONENT sy-index OF STRUCTURE <my_struc> TO <my_field>.
          IF sy-subrc EQ 0.
            WRITE AT wa_positions-position '|'.
            WRITE <my_field>.
          ELSE.
            EXIT.
          ENDIF.
        ENDDO.
        WRITE AT end_position '|'.
      ENDLOOP.

      NEW-LINE.
      ULINE AT 1(end_position).

      FORMAT COLOR COL_TOTAL ON.
      WRITE :/ '   Total Columns Shown : ' , columns.
      WRITE :/ '   Total Rows Shown    : ' , rows.


    CATCH cx_sy_create_data_error.
      WRITE :/ 'Wrong Table Name'.
  ENDTRY.
