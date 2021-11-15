*&---------------------------------------------------------------------*
*& Report Z14_UPLOAD_FILE_DATASET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z14_upload_file_dataset.

*----------------------------------------------------------------------*
*     Data Decalaration
*----------------------------------------------------------------------*
DATA: gt_spfli  TYPE TABLE OF spfli,
      gwa_spfli TYPE          spfli.

DATA: gv_file   TYPE rlgrap-filename.

*----------------------------------------------------------------------*
*     START-OF-SELECTION
*----------------------------------------------------------------------*
PERFORM read_file.
PERFORM display_data.

*&---------------------------------------------------------------------*
*&      Form  read_file
*&---------------------------------------------------------------------*
FORM read_file.
  DATA: lv_data TYPE string.

* Move complete path to filename
  gv_file = 'spfli.txt'.

* Open the file in application server to read the data
  OPEN DATASET gv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc NE 0.
    MESSAGE 'Unable to open file' TYPE 'I'.
  ENDIF.

  DO.
* Loop through the file, if a record is found move it
* to temporary structure else exit out of the loop.
    READ DATASET gv_file INTO lv_data.
    IF sy-subrc = 0.
* Split the fields in temporary structure to corresponding
* fields in workarea.
      SPLIT lv_data AT ',' INTO gwa_spfli-carrid
                                gwa_spfli-connid
                                gwa_spfli-countryfr
                                gwa_spfli-cityfrom
                                gwa_spfli-airpfrom
                                gwa_spfli-countryto
                                gwa_spfli-cityto
                                gwa_spfli-airpto
                                gwa_spfli-arrtime.
      APPEND gwa_spfli TO gt_spfli.
      CLEAR gwa_spfli.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
* Close the file
  CLOSE DATASET gv_file.
ENDFORM.                    " READ_FILE

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .
  LOOP AT gt_spfli INTO gwa_spfli.
    WRITE:/ gwa_spfli-carrid,
            gwa_spfli-connid,
            gwa_spfli-countryfr,
            gwa_spfli-cityfrom,
            gwa_spfli-airpfrom,
            gwa_spfli-countryto,
            gwa_spfli-cityto,
            gwa_spfli-airpto,
            gwa_spfli-arrtime.
    CLEAR: gwa_spfli.
  ENDLOOP.
ENDFORM.                    " DISPLAY_DATA
