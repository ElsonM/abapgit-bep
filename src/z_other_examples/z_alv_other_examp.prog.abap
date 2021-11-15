*&---------------------------------------------------------------------*
*& Report Z_ALV_OTHER_EXAMP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_alv_other_examp.

"/""
" Abap Examples
" Bryan Abrams - Ctac NL - 17/01/2014
"
" A simple demonstration of using the object CL_SALV_TABLE which creates an easy to use
" table in your reports. The table includes the standard functionality of being able to
" edit the data, give the table pretty colors, sort, and the ability to add custom
" functionality. This is just a simple example of creating a table, formatting columns,
" and then displaying it.
"
"/

"/""
" This is the structure of how the data is gonna look in the table. Simple, elementary
" data types, no reason to gunk it up with all the different data elements.
"/
TYPES: BEGIN OF line_structure,
         id      TYPE i,
         date    TYPE datum,
         time    TYPE uzeit,
         message TYPE string,
       END OF line_structure.

PERFORM run_application.

"/""
" Global variables are BAD (Another tutorial).
"/
FORM run_application.

  DATA test_data TYPE STANDARD TABLE OF line_structure.
  DATA test_alv TYPE REF TO cl_salv_table.

  PERFORM create_test_data TABLES test_data.

  TRY.
      PERFORM create_alv_table TABLES test_data CHANGING test_alv.
      PERFORM set_alv_functions                 CHANGING test_alv.
      PERFORM format_columns                    CHANGING test_alv.
      test_alv->display( ).
    CATCH cx_salv_msg.
      WRITE: / 'ALV error'.
  ENDTRY.

ENDFORM.

"/""
" The constructor of CL_SALV_TABLE is private. The only way to be able to create
" and use an instance of an ALV list in your report is to create the table via
" a static method CL_SALV_TABLE.
"/
FORM create_alv_table TABLES table_data
                      CHANGING alv_table TYPE REF TO cl_salv_table RAISING cx_salv_msg.
  cl_salv_table=>factory(
    IMPORTING r_salv_table = alv_table
     CHANGING t_table      = table_data[] ).
ENDFORM.

"/""
" There is a standard set of functions for things like sorting, filtering, etc already
" avaliable with the ALV list. If you need custom events or buttons, those can be
" added as well.
"/
FORM set_alv_functions CHANGING alv_table TYPE REF TO cl_salv_table RAISING cx_salv_msg.

  " I want to make sure the table actually exists before assigning it functions
  IF ( alv_table IS NOT BOUND ).
    RETURN.
  ENDIF.

  DATA functions TYPE REF TO cl_salv_functions_list.
  functions = alv_table->get_functions( ).
  functions->set_all( ).

ENDFORM.

"/""
" This method isn't really that important to the ALV list. I just fill the table with
" some random data. Really you could replace this with data from a selection, or BAPI
" or whatever. The factory will handle the structure of the ALV table based on the
" structure of the table.
"/
FORM create_test_data TABLES line_table. "line_structure.

  DATA line  TYPE line_structure.
  DATA index TYPE i VALUE 0.

  DO 10 TIMES.
    line-id = index.
    line-date = sy-datum.
    line-time = sy-uzeit.
    line-message = 'Index Line: ' && space && line-id.
    index = index + 1.
    APPEND line TO line_table[].
  ENDDO.

ENDFORM.

"/""
" Normally if the structure of the table includes a data element with a text description,
" (The short, medium, and long text) than the column will automatically assume the title
" of the column should match the data element. If you don't use data elements, or don't want
" to use the text from the data element, you can format the column yourself to say
" what you want.
"/
FORM format_columns CHANGING alv_table TYPE REF TO cl_salv_table RAISING cx_salv_msg.

  " If I try to use the reference alv_table and it wasn't created for some reason
  " than the program will dump.
  IF ( alv_table IS NOT BOUND ).
    RETURN.
  ENDIF.

  " CL_SALV_COLUMNS_TABLE is the collection of columns IN TOTAL in your ALV list
  " CL_SALV_COLUMN_TABLE  is an individual column by itself
  DATA alv_columns TYPE REF TO cl_salv_columns_table.
  DATA alv_column TYPE REF TO cl_salv_column.

  " The reference for alv_columns should be equal to the reference in the ALV table object.
  alv_columns = alv_table->get_columns( ).

  " And as such now that you have the reference to all of the columns, you can begin
  " getting the individual columns to format them in specific ways.
  " Just a note: elementary types like integers, floats, packed, strings, characters
  " will have empty column names.
  TRY.
      " The short, medium, and long text are shown depending on the physical width
      " of the column on your screen. You select a column to modify by supplying
      " the instance method of CL_SALV_COLUMNS_TABLE with the ID of the field
      " in the structure of the data. It has to be in CAPS.
      alv_column = alv_columns->get_column( columnname = 'ID' ).
      alv_column->set_short_text( 'ID #' ).
      alv_column->set_medium_text( 'ID Num').
      alv_column->set_long_text( 'ID Number' ).
    CATCH cx_salv_not_found.
      " If this exception occured it means the column name you supplied
      " wasn't found in the ALV table. Just remember the name is all caps.
  ENDTRY.

  " And we repeat the same for the message column.
  TRY.
      alv_column = alv_columns->get_column( columnname = 'MESSAGE' ).
      alv_column->set_short_text( 'Msg' ).
      alv_column->set_medium_text( 'Message').
      alv_column->set_long_text( 'Message' ).
    CATCH cx_salv_not_found.
  ENDTRY.

ENDFORM.
