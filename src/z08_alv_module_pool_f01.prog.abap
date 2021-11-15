*&---------------------------------------------------------------------*
*&  Include           Z08_ALV_MODULE_POOL_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CLEAR_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_screen.

  CLEAR: s_pspid, p_vbukr.
  REFRESH s_pspid[].

ENDFORM.                    " CLEAR_SCREEN

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_PROJECT_WBS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_project_wbs.

  TYPES: BEGIN OF ty_psphi,
           psphi TYPE prps-psphi,
         END OF ty_psphi.

  "Work Area & Table to get converted PSPHI -
  "Project Definition Internal Version
  DATA: lw_psphi TYPE                   ty_psphi,
        lt_psphi TYPE STANDARD TABLE OF ty_psphi.

  SELECT pspnr pspid objnr ernam
         erdat vbukr vgsbr vkokr
    FROM proj INTO TABLE it_proj
    WHERE pspid IN s_pspid
      AND vbukr =  p_vbukr.

  IF sy-subrc = 0.
    SORT it_proj BY pspid.
    REFRESH lt_psphi.

    LOOP AT it_proj INTO wa_proj.
      CALL FUNCTION 'CONVERSION_EXIT_KONPD_INPUT'
        EXPORTING
          input     = wa_proj-pspid
        IMPORTING
          output    = lw_psphi
*         PROJWA    =
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.

      IF lw_psphi IS NOT INITIAL.
        "Making the table of Project definition Internal Version
        APPEND lw_psphi TO lt_psphi.
      ENDIF.

      CLEAR: wa_proj, lw_psphi.
    ENDLOOP.
  ELSE.
    MESSAGE 'Project doesn''t exist' TYPE 'I'.
  ENDIF.

  IF lt_psphi IS NOT INITIAL.
    SELECT pspnr posid psphi poski
           pbukr pgsbr pkokr
      FROM prps INTO TABLE it_prps
      FOR ALL ENTRIES IN lt_psphi
      WHERE psphi = lt_psphi-psphi.

    IF sy-subrc = 0.
      SORT it_prps BY posid.
      CALL SCREEN 9002.
    ELSE.
      MESSAGE 'WBS Elements don''t exist' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " DISPLAY_PROJECT_WBS
