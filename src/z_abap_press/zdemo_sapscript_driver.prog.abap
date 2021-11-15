*&---------------------------------------------------------------------*
*& Report ZDEMO_SAPSCRIPT_DRIVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_sapscript_driver.

*Document header data
TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbeln_vf,
          fkdat TYPE fkdat,
          kunrg TYPE kunrg,
          netwr TYPE netwr,
        END OF ty_vbrk.

*Document item data
TYPES : BEGIN OF ty_vbrp,
          vbeln TYPE vbeln_vf,
          posnr TYPE posnr,
          arktx TYPE arktx,
          netwr TYPE netwr,
        END OF ty_vbrp.

*Customer data
TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kunnr,
          land1 TYPE land1_gp,
          name1 TYPE name1_gp,
          name2 TYPE name2_gp,
          ort01 TYPE ort01_gp,
        END OF ty_kna1.

DATA : wa_vbrk TYPE ty_vbrk,
       wa_kna1 TYPE ty_kna1,
       wa_vbrp TYPE ty_vbrp,
       it_vbrp TYPE STANDARD TABLE OF ty_vbrp.

PARAMETERS p_vbeln TYPE vbeln_vf.

START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM print_form.

*&------------------------------------------------------------*
*& Form FETCH_DATA
*&------------------------------------------------------------*
FORM fetch_data.

  SELECT SINGLE vbeln fkdat kunrg netwr FROM vbrk
    INTO wa_vbrk
    WHERE vbeln EQ p_vbeln.

  IF sy-subrc IS INITIAL.

    SELECT SINGLE kunnr land1 name1 name2 ort01 FROM kna1
      INTO wa_kna1
      WHERE kunnr EQ wa_vbrk-kunrg.

    SELECT vbeln posnr arktx netwr FROM vbrp
      INTO TABLE it_vbrp
      WHERE vbeln EQ wa_vbrk-vbeln.

  ENDIF.

ENDFORM.

*&------------------------------------------------------------*
*& Form PRINT_FORM
*&------------------------------------------------------------*
FORM print_form.

  LOOP AT it_vbrp INTO wa_vbrp.

    AT FIRST.
      CALL FUNCTION 'OPEN_FORM'
        EXPORTING
          form     = 'ZCA_FORM'
          language = sy-langu.
    ENDAT.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        type   = 'BODY'
        window = 'MAIN'.

    AT LAST.
      CALL FUNCTION 'CLOSE_FORM'.
    ENDAT.

  ENDLOOP.

ENDFORM.
