*&---------------------------------------------------------------------*
*& Report Z_PROCESSING_BLOCKS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_processing_blocks.

TYPES: BEGIN OF ty_vbrp,
         vbeln TYPE vbeln_vf, "Document Number
         posnr TYPE posnr,    "Item Number
         fkimg TYPE fkimg,    "Quantity
         vrkme TYPE vrkme,    "UoM
         netwr TYPE netwr,    "Net Value
         matnr TYPE matnr,    "Material Number
         arktx TYPE arktx,    "Description
         mwsbp TYPE mwsbp,    "Tax Amount
       END OF ty_vbrp.

DATA: it_vbrp TYPE STANDARD TABLE OF ty_vbrp,
      wa_vbrp LIKE LINE OF it_vbrp,
      v_vbeln TYPE vbeln_vf.

PARAMETERS p_vbeln TYPE vbeln_vf.

INITIALIZATION. "Event Block
  AUTHORITY-CHECK OBJECT 'V_VBRK_FKA'
    ID 'FKART' FIELD 'F2'
    ID 'ACTVT' FIELD '03'.

  IF sy-subrc <> 0.
* Implement a suitable exception handling here
    MESSAGE 'Authorization check failed' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN. "Event Block
  SELECT SINGLE vbeln FROM vbrk
                      INTO v_vbeln
                      WHERE vbeln EQ p_vbeln.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE 'Invalid Document Number' TYPE 'E'.
  ENDIF.

START-OF-SELECTION. "Event Block
  PERFORM get_data. "Calls procedure
  PERFORM show_output. "Calls procedure

*&--------------------------------------------------------------*
*& Form GET_DATA
*&--------------------------------------------------------------*
FORM get_data. "Subroutine
  SELECT vbeln
         posnr
         fkimg
         vrkme
         netwr
         matnr
         arktx
         mwsbp
               FROM vbrp
               INTO TABLE it_vbrp
               WHERE vbeln EQ p_vbeln.
ENDFORM. "GET_DATA

*&--------------------------------------------------------------*
*& Form SHOW_OUTPUT
*&--------------------------------------------------------------*
FORM show_output. "Subroutine
  FORMAT COLOR COL_HEADING.
  WRITE :/ 'Item',
        10 'Description',
        33 'Billed Qty',
        48 'UoM',
        57 'Net value',
        70 'Material',
        80 'Tax amount'.
  FORMAT COLOR OFF.
  LOOP AT it_vbrp INTO wa_vbrp.
    WRITE :/ wa_vbrp-posnr,
          10 wa_vbrp-arktx,
          33 wa_vbrp-fkimg LEFT-JUSTIFIED,
          48 wa_vbrp-vrkme,
          57 wa_vbrp-netwr LEFT-JUSTIFIED,
          70 wa_vbrp-matnr,
          80 wa_vbrp-mwsbp LEFT-JUSTIFIED.
  ENDLOOP.
ENDFORM. "SHOW_OUTPUT
