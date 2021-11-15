*&---------------------------------------------------------------------*
*& Report Z15_FILE_SERVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z15_file_server.

*----------------------------------------------------------------------*
*     Data Decalaration
*----------------------------------------------------------------------*
DATA: g_directory(30).

*----------------------------------------------------------------------*
*     SELECTION-SCREEN
*----------------------------------------------------------------------*
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.

*----------------------------------------------------------------------*
*     AT SELECTION-SCREEN ON VALUE-REQUEST
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

* Set default directory
  g_directory = '.'.

* F4 help for file name on SAP application server
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = g_directory
    IMPORTING
      serverfile       = p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Error Message' TYPE 'I'.
  ENDIF.

*----------------------------------------------------------------------*
*     START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  WRITE:/ 'Filepath: ', p_file.

*DATA: g_type TYPE dd01v-datatype.
*DATA: g_string(5) TYPE c.
*
*g_string = 'Hello'.
*
** Check whether first character of material description is NUMERIC or CHAR
*CALL FUNCTION 'NUMERIC_CHECK'
*  EXPORTING
*    string_in = g_string
*  IMPORTING
*    htype     = g_type.
*
*WRITE:/ 'The Value', g_string, 'is a', g_type.
*
*g_string = '25'.
*
** Check whether first character of material description is NUMERIC or CHAR
*CALL FUNCTION 'NUMERIC_CHECK'
*  EXPORTING
*    string_in = g_string
*  IMPORTING
*    htype     = g_type.
*
*WRITE:/ 'The Value', g_string, 'is a', g_type.
