*&---------------------------------------------------------------------*
*& Report ZTEST_EM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_em.

TYPES: BEGIN OF ty_usr,
         bname TYPE usr02-bname,
         trdat TYPE usr02-trdat,
       END OF ty_usr.

DATA gt_usr TYPE TABLE OF ty_usr.
DATA gs_usr TYPE ty_usr.

DATA gt_fcat TYPE slis_t_fieldcat_alv.

START-OF-SELECTION.

  SELECT * FROM usr02 INTO CORRESPONDING FIELDS OF TABLE gt_usr.

*  PERFORM build_fcat_1.
*  PERFORM build_fcat_2.
  PERFORM build_fcat_3.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = gt_fcat
    TABLES
      t_outtab    = gt_usr.

FORM build_fcat_1.

  DATA: ls_fcat TYPE slis_fieldcat_alv.

  CLEAR ls_fcat.
  ls_fcat-col_pos     = 1.
  ls_fcat-ref_tabname = 'USR02'.
  ls_fcat-fieldname   = 'BNAME'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-col_pos     = 2.
  ls_fcat-ref_tabname = 'USR02'.
  ls_fcat-fieldname   = 'TRDAT'.
  APPEND ls_fcat TO gt_fcat.

ENDFORM.

FORM build_fcat_2.

  PERFORM add_fc USING 'USR02' 'BNAME' 10 'Username'.
  PERFORM add_fc USING 'USR02' 'TRDAT' 10 'Last login'.

ENDFORM.

FORM add_fc USING pi_tabname pi_fieldname pi_outputlen pi_seltext.

  DATA: ls_fcat TYPE slis_fieldcat_alv,
        lv_col  TYPE i.

  DESCRIBE TABLE gt_fcat LINES lv_col.
  ADD 1 TO lv_col.

  ls_fcat-col_pos      = lv_col.
  ls_fcat-ref_tabname  = pi_tabname.
  ls_fcat-fieldname    = pi_fieldname.
  ls_fcat-seltext_l    = pi_seltext.
  ls_fcat-seltext_m    = pi_seltext.
  ls_fcat-seltext_s    = pi_seltext.
  ls_fcat-reptext_ddic = pi_seltext.
  ls_fcat-outputlen    = pi_outputlen.
  APPEND ls_fcat TO gt_fcat.

ENDFORM.

FORM build_fcat_3.

  DATA: lv_repid         LIKE sy-repid,
        lv_alvbuffer(11) TYPE c.

  lv_alvbuffer = 'BFOFF EUOFF'.
  SET PARAMETER ID 'ALVBUFFER' FIELD lv_alvbuffer.

  lv_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = lv_repid
      i_internal_tabname = 'GT_USR'
      i_inclname         = lv_repid
    CHANGING
      ct_fieldcat        = gt_fcat.

  BREAK-POINT.
ENDFORM.
