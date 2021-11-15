*&---------------------------------------------------------------------*
*& Report Z_ELSON_ALV_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM z_elson_alv_5.

*Table declarations
TABLES: vbak, vbap.

*Internal table
DATA: BEGIN OF i_sales OCCURS 0,
        vbeln LIKE vbak-vbeln,
        erdat LIKE vbak-erdat,
        audat LIKE vbak-audat,
        kunnr LIKE vbak-kunnr,
        vkorg LIKE vbak-vkorg,
        matnr LIKE vbap-matnr,
        netpr LIKE vbap-netpr,
        check TYPE c, "checkbox
      END OF i_sales.

DATA: BEGIN OF i_final OCCURS 0,
        vbeln LIKE vbak-vbeln,
        erdat LIKE vbak-erdat,
        audat LIKE vbak-audat,
        kunnr LIKE vbak-kunnr,
        vkorg LIKE vbak-vkorg,
        matnr LIKE vbap-matnr,
        netpr LIKE vbap-netpr,
      END OF i_final.

DATA: v_fieldcat  TYPE slis_fieldcat_alv,
      gt_fieldcat TYPE slis_t_fieldcat_alv,
      gt_layout   TYPE slis_layout_alv,
      gt_sort     TYPE slis_sortinfo_alv,
      fieldcat    LIKE LINE OF gt_fieldcat.

*Selection screen
PARAMETERS: p_vkorg LIKE vbak-vkorg.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.

*Start of selection.
START-OF-SELECTION.
  PERFORM get_data.
  PERFORM fill_fieldcatalog.
  PERFORM write_data.

*-----------------------------------------------------------------
* Form GET_DATA
*-----------------------------------------------------------------
FORM get_data.

  SELECT a~vbeln
         a~erdat
         a~audat
         a~kunnr
         a~vkorg
         b~matnr
         b~netpr
    INTO CORRESPONDING FIELDS OF TABLE i_sales
    FROM vbak AS a INNER JOIN vbap AS b ON a~vbeln = b~vbeln
    WHERE a~vkorg = p_vkorg
      AND a~vbeln IN s_vbeln.

ENDFORM. " get_data

*-----------------------------------------------------------------
* Form WRITE_DATA
*-----------------------------------------------------------------
FORM write_data.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'GUI_SET'
      i_callback_user_command  = 'USER_COMMAND'
      is_layout                = gt_layout
      it_fieldcat              = gt_fieldcat
    TABLES
      t_outtab                 = i_sales.

ENDFORM. " write_data

*-----------------------------------------------------------------
* fill catalog
*-----------------------------------------------------------------
FORM fill_fieldcatalog.

  SORT i_sales BY vbeln.
  CLEAR v_fieldcat.
*for check box

  v_fieldcat-col_pos   = 1.
  v_fieldcat-fieldname = 'CHECK'.
  v_fieldcat-seltext_m = 'Check'.
  v_fieldcat-checkbox  = 'X'.
  v_fieldcat-input     = 'X'.
  v_fieldcat-edit      = 'X'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 2.
  v_fieldcat-fieldname = 'VBELN'.
  v_fieldcat-seltext_m = 'Sales Document'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 3.
  v_fieldcat-fieldname = 'ERDAT'.
  v_fieldcat-seltext_m = 'Creation Date'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 4.
  v_fieldcat-fieldname = 'AUDAT'.
  v_fieldcat-seltext_m = 'Document Date'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 5.
  v_fieldcat-fieldname = 'KUNNR'.
  v_fieldcat-seltext_m = 'Customer'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 6.
  v_fieldcat-fieldname = 'VKORG'.
  v_fieldcat-seltext_m = 'Sales Organization'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 7.
  v_fieldcat-fieldname = 'MATNR'.
  v_fieldcat-seltext_m = 'Material'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

  v_fieldcat-col_pos   = 8.
  v_fieldcat-fieldname = 'NETPR'.
  v_fieldcat-seltext_m = 'Net Value'.
  APPEND v_fieldcat TO gt_fieldcat.
  CLEAR v_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form GUI_SET
*&---------------------------------------------------------------------*
FORM gui_set USING rt_extab TYPE slis_t_extab .

  SET PF-STATUS 'GETDATA'.

ENDFORM. "GUI_SET

*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*

FORM user_command USING r_ucomm    LIKE sy-ucomm
                        r_selfield TYPE slis_selfield.

  CASE r_ucomm.

    WHEN 'DATA'.

      CLEAR i_final.
      CLEAR i_sales.
      REFRESH i_final.

      LOOP AT i_sales.

        IF i_sales-check = 'X'.

          i_final-vbeln = i_sales-vbeln.
          i_final-erdat = i_sales-erdat.
          i_final-audat = i_sales-audat.
          i_final-kunnr = i_sales-kunnr.
          i_final-vkorg = i_sales-vkorg.
          i_final-matnr = i_sales-matnr.
          i_final-netpr = i_sales-netpr.

          IF NOT i_final-vbeln IS INITIAL.
            APPEND i_final.
          ENDIF.

        ENDIF.

      ENDLOOP.

      PERFORM final_display.

    WHEN 'BACK'.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDFORM. "USER_COMMAND

*&---------------------------------------------------------------------*
*& Form FINAL_DISPLAY
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM final_display.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gt_layout
      it_fieldcat        = gt_fieldcat
    TABLES
      t_outtab           = i_final.

ENDFORM.
