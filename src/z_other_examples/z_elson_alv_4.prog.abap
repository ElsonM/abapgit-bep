*&---------------------------------------------------------------------*
*& Report Z_ELSON_ALV_4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_alv_4.

TYPES: BEGIN OF ty_data1,
         name  TYPE char20,
         age   TYPE i,
         check TYPE c,
       END OF ty_data1.

TYPES: BEGIN OF ty_data2,
         name TYPE char20,
         age  TYPE i,
       END OF ty_data2.

DATA: it_data1 TYPE TABLE OF ty_data1 WITH HEADER LINE,
      it_data2 TYPE TABLE OF ty_data2 WITH HEADER LINE.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF it_fieldcat,

      it_layout   TYPE slis_layout_alv,

      it_events   TYPE slis_t_event,
      wa_event    LIKE LINE OF it_events.

PARAMETERS: alv_list RADIOBUTTON GROUP g1,
            alv_grid RADIOBUTTON GROUP g1.

START-OF-SELECTION.

  it_data1-name = 'Venkat1'.
  it_data1-age  = '11'.
  APPEND it_data1.

  it_data1-name = 'Venkat2'.
  it_data1-age  = '12'.
  APPEND it_data1.

  it_data1-name = 'Venkat3'.
  it_data1-age  = '13'.
  APPEND it_data1.

  wa_fieldcat-fieldname = 'CHECK'.
  wa_fieldcat-seltext_m = 'Check'.
  wa_fieldcat-edit      = 'X'.
  wa_fieldcat-checkbox  = 'X'.
  wa_fieldcat-input     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME'.
  wa_fieldcat-seltext_m = 'Name'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'AGE'.
  wa_fieldcat-seltext_m = 'Age'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  it_layout-edit          = 'X'.
  it_layout-box_fieldname = 'CHECK'.

  IF alv_list IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'SET_PF_STATUS'
        i_callback_user_command  = 'USER_COMMAND'
        is_layout                = it_layout
        it_fieldcat              = it_fieldcat
      TABLES
        t_outtab                 = it_data1.

  ELSE.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'SET_PF_STATUS'
        i_callback_user_command  = 'USER_COMMAND'
        is_layout                = it_layout
        it_fieldcat              = it_fieldcat
      TABLES
        t_outtab                 = it_data1.
  ENDIF.

*--------------------------------------------------------------*
* SET_PF_STATUS
*--------------------------------------------------------------*
FORM set_pf_status USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'GUI_STATUS'.

ENDFORM.

*--------------------------------------------------------------*
* USER_COMMAND
*--------------------------------------------------------------*
FORM user_command USING r_ucomm     LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  rs_selfield-refresh = 'X'.

  REFRESH: it_data2.

  CASE r_ucomm.

    WHEN 'TEST'.

      IF alv_list IS NOT INITIAL.

        LOOP AT it_data1 WHERE check = 'X'.
          MOVE-CORRESPONDING it_data1 TO it_data2.
          APPEND it_data2.
          CLEAR :it_data1, it_data2.
        ENDLOOP.

      ELSEIF alv_grid IS NOT INITIAL.

        DATA: ref_grid TYPE REF TO cl_gui_alv_grid.

        IF ref_grid IS INITIAL.

          CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
            IMPORTING
              e_grid = ref_grid.

        ENDIF.

        IF NOT ref_grid IS INITIAL.

          CALL METHOD ref_grid->check_changed_data.

        ENDIF.

        LOOP AT it_data1 WHERE check = 'X'.
          MOVE-CORRESPONDING it_data1 TO it_data2.
          APPEND it_data2.
          CLEAR :it_data1, it_data2.
        ENDLOOP.

      ENDIF.

    WHEN 'BACK'.

      LEAVE TO SCREEN 0.

  ENDCASE.

  DELETE it_fieldcat WHERE fieldname = 'CHECK'.

  IF alv_list IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'SET_PF_STATUS'
        i_callback_user_command  = 'USER_COMMAND'
        is_layout                = it_layout
        it_fieldcat              = it_fieldcat
      TABLES
        t_outtab                 = it_data2.

  ELSE.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'SET_PF_STATUS'
        i_callback_user_command  = 'USER_COMMAND'
        is_layout                = it_layout
        it_fieldcat              = it_fieldcat
      TABLES
        t_outtab                 = it_data2.

  ENDIF.

ENDFORM.
