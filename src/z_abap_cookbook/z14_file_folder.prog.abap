*&---------------------------------------------------------------------*
*& Report Z14_FILE_FOLDER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z14_file_folder.

PARAMETERS: folder   TYPE c LENGTH 80.
PARAMETERS: filename TYPE c LENGTH 50.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR folder.

*  CALL FUNCTION 'TMP_GUI_BROWSE_FOR_FOLDER'                 "Using Function Module
*    EXPORTING
*      window_title    = 'Choose the folder of your choice'
*      initial_folder  = folder
*    IMPORTING
*      selected_folder = folder
*    EXCEPTIONS
*      cntl_error      = 1
*      OTHERS          = 2.

  DATA: temp_string TYPE string.
  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = 'File Directory'
      initial_folder  = 'C:'
    CHANGING
      selected_folder = temp_string.
  CALL METHOD cl_gui_cfw=>flush.
  folder = temp_string.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR filename.

  DATA: number_of_files TYPE i.

*  DATA: file_names_tab  TYPE STANDARD TABLE OF sdokpath.   "Using Function Module
*  DATA: wa_names_tab    TYPE sdokpath.
*  CLEAR file_names_tab.

*  CALL FUNCTION 'TMP_GUI_FILE_OPEN_DIALOG'
*    EXPORTING
*      window_title   = 'Enter the File names'
*      multiselection = ' '
*    IMPORTING
*      rc             = number_of_files
*    TABLES
*      file_table     = file_names_tab
*    EXCEPTIONS
*      cntl_error     = 1
*      OTHERS         = 2.

  DATA: file_names_tab TYPE filetable.
  DATA: wa_names_tab   TYPE LINE OF filetable.
  CLEAR file_names_tab.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title   = 'Enter the file name'
      multiselection = ' '
    CHANGING
      file_table     = file_names_tab
      rc             = number_of_files.

  READ TABLE file_names_tab INTO wa_names_tab INDEX 1.
  filename = wa_names_tab.
