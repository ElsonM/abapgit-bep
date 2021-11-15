*&---------------------------------------------------------------------*
*& Report Z_ALV_INTERACTIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_alv_interactive.

*INCLUDE ZTEST_ALV2_DECL.
*&---------------------------------------------------------------------*
*&  Include           ZTEST_ALV2_DECL
*&---------------------------------------------------------------------*

TABLES: vbak, vbap, lips, likp, vbrk.

TYPES : BEGIN OF ty_vbak ,
          vbeln TYPE vbeln,
          vbtyp TYPE vbtyp,
          vkorg TYPE vkorg,
          vtweg TYPE vtweg,
          spart TYPE spart,
          erdat TYPE erdat,
        END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln TYPE vbeln,
         posnr TYPE posnr,
         matnr TYPE matnr,
         pstyv TYPE pstyv,
         matkl TYPE matkl,
         werks TYPE werks_ext,
         posar TYPE posar,
         waerk TYPE waerk,
         meins TYPE meins,
         netpr TYPE netpr,
         aufnr TYPE aufnr,
       END OF ty_vbap,

       BEGIN OF ty_vbrk,
         vbeln TYPE vbeln,
         vbtyp TYPE vbtyp,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         fkart TYPE fkart,
         fktyp TYPE fktyp,
       END OF ty_vbrk,

       BEGIN OF ty_vbrp,
         vbeln TYPE vbeln_vf,
         posnr TYPE posnr_vf,
         vrkme TYPE vrkme,
         fkimg TYPE fkimg,
         aubel TYPE vbeln_va,
         aupos TYPE posnr_va,
         matnr TYPE matnr,
         pmatn TYPE pmatn,
         charg TYPE charg_d,
         matkl TYPE matkl,
       END OF ty_vbrp,

       BEGIN OF ty_likp,
         vbeln TYPE vbeln_vl,
         vkorg TYPE vkorg,
         erdat TYPE erdat,
         lfart TYPE lfart,
         lddat TYPE lddat,
         lfdat TYPE lfdat_v,
       END OF ty_likp,

       BEGIN OF ty_lips,
         vbeln TYPE vbeln_vl,
         posnr TYPE posnr_vl,
         matnr TYPE matnr,
         pstyv TYPE pstyv_vl,
         werks TYPE werks_d,
         wavwr TYPE wavwr,
         charg TYPE charg_d,
         vrkme TYPE vrkme,
         netpr TYPE netpr,
         hsdat TYPE hsdat,
       END OF ty_lips.

DATA: it_vbak TYPE TABLE OF ty_vbak,
      wa_vbak TYPE ty_vbak,
      it_vbap TYPE TABLE OF ty_vbap,
      wa_vbap TYPE ty_vbap,
      it_vbrk TYPE TABLE OF ty_vbrk,
      wa_vbrk TYPE ty_vbrk,
      it_vbrp TYPE TABLE OF ty_vbrp,
      wa_vbrp TYPE ty_vbrp,
      it_likp TYPE TABLE OF ty_likp,
      wa_likp TYPE ty_likp,
      it_lips TYPE TABLE OF ty_lips,
      wa_lips TYPE ty_lips.


DATA: it_fldcat    TYPE slis_t_fieldcat_alv,
      wa_fldcat    TYPE slis_fieldcat_alv,
      tablname(20),
      fldname(20),
      sltxt_l(20).

DATA: it_alvevnt TYPE slis_t_event,
      wa_alvevnt TYPE slis_alv_event.

DATA: it_listhead TYPE slis_t_listheader,
      wa_listhead TYPE slis_listheader.

DATA: layout TYPE slis_layout_alv.

DATA : repid LIKE sy-repid.
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.


SELECT-OPTIONS:  s_vbeln FOR vbak-vbeln.
PARAMETERS:      p_vbtyp TYPE vbtyp OBLIGATORY.

SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN.
  IF NOT ( p_vbtyp EQ 'C'
      OR   p_vbtyp EQ 'J'
      OR   p_vbtyp EQ 'M'
      OR   p_vbtyp EQ 'A'
      OR   p_vbtyp EQ 'B'
      OR   p_vbtyp EQ 'H' ) .
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-002.
  ENDIF.

START-OF-SELECTION.
  IF p_vbtyp EQ 'C' OR p_vbtyp EQ 'A' OR p_vbtyp EQ 'B' OR p_vbtyp EQ 'H'.
    REFRESH it_fldcat.
    CLEAR   wa_fldcat.



    PERFORM prep_fldcat USING 'IT_VBAK' 'VBELN' 'DOC NUMBER'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'ERDAT' 'DOC CREATION DATE'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VBTYP' 'DOC TYPE'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VKORG' 'SALES ORG'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VTWEG' 'DISTRIBUTION CHNL'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'SPART' 'DIVISION'.

    PERFORM populate_event.
    PERFORM data_retrieve.
    PERFORM display_grid.
  ELSEIF p_vbtyp EQ 'M'.
    REFRESH it_fldcat.
    CLEAR   wa_fldcat.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VBELN' 'DOC NUMBER'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'FKART' 'BILLING TYPE'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VBTYP' 'DOC TYPE'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VKORG' 'SALES ORG'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'VTWEG' 'DISTRIBUTION CHNL'.
    PERFORM prep_fldcat USING 'IT_VBAK' 'FKTYP' 'BILLING CATG'.


    PERFORM populate_event.
    PERFORM data_retrieve_m.
    PERFORM display_grid_m.
  ELSEIF p_vbtyp EQ 'J'.
    REFRESH it_fldcat.
    CLEAR   wa_fldcat.
    PERFORM prep_fldcat USING 'IT_LIKP' 'VBELN' 'DOC NUMBER'.
    PERFORM prep_fldcat USING 'IT_LIKP' 'ERDAT' 'DOC CREATION DATE'.
    PERFORM prep_fldcat USING 'IT_LIKP' 'VKORG' 'SALES ORG'.
    PERFORM prep_fldcat USING 'IT_LIKP' 'LFART' 'DELIVERY TYPE'.
    PERFORM prep_fldcat USING 'IT_LIKP' 'LDDAT' 'LOADING DATE'.
    PERFORM prep_fldcat USING 'IT_LIKP' 'LFDAT' 'DELIVERY DATE'.


    PERFORM populate_event.
    PERFORM data_retrieve_j.
    PERFORM display_grid_j TABLES it_likp .
  ENDIF.






*&---------------------------------------------------------------------*
*&      Form  PREP_FLDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prep_fldcat USING tablname  fldname   sltxt_l.

  wa_fldcat-tabname = tablname.
  wa_fldcat-fieldname = fldname.
  wa_fldcat-seltext_l = sltxt_l.
  APPEND wa_fldcat TO it_fldcat.
  CLEAR wa_fldcat.

ENDFORM.                    " PREP_FLDCAT


*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_retrieve .

  SELECT  vbeln
          vbtyp
          vkorg
          vtweg
          spart
          erdat
    FROM vbak
    INTO CORRESPONDING FIELDS OF TABLE it_vbak
    WHERE vbeln IN s_vbeln
    AND   vbtyp EQ p_vbtyp.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-003.
  ENDIF.

ENDFORM.                    " DATA_RETRIEVE

*&---------------------------------------------------------------------*
*&      Form  POPULATE_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM populate_event .
  READ TABLE it_alvevnt INTO wa_alvevnt WITH KEY name = 'TOP_OF_PAGE'.
  IF sy-subrc EQ 0.
    wa_alvevnt-form = 'TOP_OF_PAGE'.
    MODIFY it_alvevnt FROM wa_alvevnt TRANSPORTING form WHERE name = wa_alvevnt-form.
  ENDIF.

  READ TABLE it_alvevnt INTO wa_alvevnt WITH KEY name = 'USER_COMMAND'.
  IF sy-subrc EQ 0.
    wa_alvevnt-form = 'USER_INPUT'.
    MODIFY it_alvevnt FROM wa_alvevnt TRANSPORTING form WHERE name = wa_alvevnt-name.
  ENDIF.
ENDFORM.                    " POPULATE_EVENT
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_grid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_INPUT'
      i_callback_top_of_page  = 'TOP_OF_PAGE'
      is_layout               = layout
      it_fieldcat             = it_fldcat
      it_events               = it_alvevnt
      i_save                  = 'A'
    TABLES
      t_outtab                = it_vbak
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_GRID

FORM top_of_page.                                           "#EC CALLED
  REFRESH it_listhead.
  wa_listhead-typ = 'H'.
  wa_listhead-info = TEXT-004.

  APPEND wa_listhead TO it_listhead.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_listhead.
ENDFORM.

FORM user_input USING cmd LIKE sy-ucomm  sel_fld TYPE slis_selfield.
  IF p_vbtyp EQ 'C' OR p_vbtyp EQ 'A' OR p_vbtyp EQ 'B' OR p_vbtyp EQ 'H'.
    READ TABLE it_vbak INTO wa_vbak INDEX sel_fld-tabindex.
    CASE cmd.
      WHEN '&IC1'.
        REFRESH it_fldcat.
        CLEAR   wa_fldcat.
        PERFORM prep_fldcat USING 'IT_VBAP' 'VBELN' 'DOC NUMBER'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'POSNR' 'DELIVERY ITEM'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'MATNR' 'MATERIAL NUMBER'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'PSTYV' 'ITEM CATG'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'MATKL' 'MATERIAL GRP'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'WERKS' 'PLANT'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'POSAR' 'ITEM TYPE'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'WAERK' 'CURRENCY'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'MEINS' 'MATRL WT '.
        PERFORM prep_fldcat USING 'IT_VBAP' 'NETPR' 'NET PRICE'.
        PERFORM prep_fldcat USING 'IT_VBAP' 'AUFNR' 'ORDER NUMBER'.

        PERFORM data_retrieve_1.
        PERFORM display_grid_1.
    ENDCASE.
  ELSEIF p_vbtyp EQ 'M'.
    READ TABLE it_vbrk INTO wa_vbrk INDEX sel_fld-tabindex.
    CASE cmd.
      WHEN '&IC1'.
        REFRESH it_fldcat.
        CLEAR   wa_fldcat.
        PERFORM prep_fldcat USING 'IT_VBRP' 'VBELN' 'DOC NUMBER'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'POSNR' 'DELIVERY ITEM'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'MATNR' 'MATERIAL NUMBER'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'VRKME' 'SALES UNIT'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'MATKL' 'MATERIAL GRP'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'FKIMG' 'INVOICED QTY'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'AUBEL' 'SALES DOC'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'AUPOS' 'DOC ITEM'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'PMATN' 'PRICE REF '.
*        PERFORM PREP_FLDCAT USING 'IT_VBRP' 'NETPR' 'NET PRICE'.
        PERFORM prep_fldcat USING 'IT_VBRP' 'CHARG' 'BATCH NUMBER'.

        PERFORM data_retrieve_m1.
        PERFORM display_grid_m1.
    ENDCASE.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSEIF p_vbtyp EQ 'J'.
    READ TABLE it_likp INTO wa_likp INDEX sel_fld-tabindex.
    CASE cmd.
      WHEN '&IC1'.
        REFRESH it_fldcat.
        CLEAR   wa_fldcat.
        PERFORM prep_fldcat USING 'IT_LIPS' 'VBELN' 'DOC NUMBER'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'POSNR' 'DELIVERY ITEM'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'MATNR' 'MATERIAL NUMBER'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'VRKME' 'SALES UNIT'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'WERKS' 'PLANT'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'PSTYV' 'ITEM CATG'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'WAVWR' 'COST'.
*        PERFORM PREP_FLDCAT USING 'IT_LIPS' 'AUPOS' 'DOC ITEM'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'NETPR' 'NET PRICE'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'CHARG' 'BATCH NUMBER'.
        PERFORM prep_fldcat USING 'IT_LIPS' 'HSDAT' 'MFG DATE '.
        PERFORM data_retrieve_j1.
        PERFORM display_grid_j1.
    ENDCASE.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVE_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_retrieve_1 .
  SELECT vbeln
        posnr
        matnr
        pstyv
        matkl
        werks
        posar
        waerk
        meins
        aufnr
        netpr
   FROM vbap
   INTO CORRESPONDING FIELDS OF TABLE it_vbap
   WHERE vbeln EQ wa_vbak-vbeln.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-005.
  ENDIF.
ENDFORM.                    " DATA_RETRIEVE_1
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRID_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_grid_1 .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP_OF_PAGE_1'
      is_layout              = layout
      it_fieldcat            = it_fldcat
    TABLES
      t_outtab               = it_vbap
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_GRID_1

FORM top_of_page_1.

  REFRESH it_listhead.
  wa_listhead-typ = 'H'.
  wa_listhead-info = TEXT-006.

  APPEND wa_listhead TO it_listhead.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_listhead.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVE_M
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_retrieve_m .
  SELECT vbeln
         vbtyp
         vkorg
         vtweg
         fkart
        fktyp
    FROM vbrk
    INTO CORRESPONDING FIELDS OF TABLE it_vbrk
    WHERE vbeln IN s_vbeln
    AND   vbtyp EQ p_vbtyp.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-003.
  ENDIF.
ENDFORM.                    " DATA_RETRIEVE_M

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRID_M
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_grid_m .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_INPUT'
      i_callback_top_of_page  = 'TOP_OF_PAGE'
      is_layout               = layout
      it_fieldcat             = it_fldcat
      it_events               = it_alvevnt
    TABLES
      t_outtab                = it_vbrk
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_GRID_M

*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVE_M1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_retrieve_m1 .
  SELECT  vbeln
          posnr
          vrkme
          fkimg
          aubel
          aupos
          matnr
          pmatn
          charg
          matkl
    INTO CORRESPONDING FIELDS OF TABLE it_vbrp
     FROM vbrp
      WHERE vbeln EQ wa_vbrk-vbeln .

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-003.
  ENDIF.
ENDFORM.                    " DATA_RETRIEVE_M1
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRID_M1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_grid_m1 .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP_OF_PAGE_1'
      is_layout              = layout
      it_fieldcat            = it_fldcat
    TABLES
      t_outtab               = it_vbrp
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_GRID_M1


*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVE_J
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_retrieve_j .
  SELECT vbeln
         vkorg
         erdat
         lfart
         lddat
         lfdat
    FROM likp
    INTO CORRESPONDING FIELDS OF TABLE it_likp
    WHERE vbeln IN s_vbeln
    AND   vbtyp EQ p_vbtyp.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-003.
  ENDIF.
ENDFORM.                    " DATA_RETRIEVE_J

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRID_J
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_grid_j TABLES it_likp_1 LIKE it_likp .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_INPUT'
      i_callback_top_of_page  = 'TOP_OF_PAGE'
      is_layout               = layout
      it_fieldcat             = it_fldcat
      it_events               = it_alvevnt
    TABLES
      t_outtab                = it_likp_1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_GRID_J

*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVE_J1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_retrieve_j1 .
  SELECT vbeln
         posnr
         matnr
         pstyv
         werks
         wavwr
         charg
         vrkme
         netpr
         hsdat
    FROM lips
    INTO CORRESPONDING FIELDS OF TABLE it_lips
    WHERE vbeln EQ wa_likp-vbeln.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER '002' WITH TEXT-003.
  ENDIF.
ENDFORM.                    " DATA_RETRIEVE_J1
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRID_J1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_grid_j1 .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP_OF_PAGE_1'
      is_layout              = layout
      it_fieldcat            = it_fldcat
    TABLES
      t_outtab               = it_lips
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DISPLAY_GRID_J1
