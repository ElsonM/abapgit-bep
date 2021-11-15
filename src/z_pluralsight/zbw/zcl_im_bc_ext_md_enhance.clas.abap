class ZCL_IM_BC_EXT_MD_ENHANCE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_RSU5_SAPI_BADI .

  methods _TEMPLATE_DATASOURCE
    importing
      value(I_DATASOURCE) type RSAOT_OLTPSOURCE
      value(I_UPDMODE) type SBIWA_S_INTERFACE-UPDMODE
      value(I_T_SELECT) type SBIWA_T_SELECT
      value(I_T_FIELDS) type SBIWA_T_FIELDS
    changing
      !C_T_DATA type ANY TABLE
      !C_T_MESSAGES type RSU5_T_MESSAGES optional
    exceptions
      RSAP_BADI_EXIT_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BC_EXT_MD_ENHANCE IMPLEMENTATION.


  method IF_EX_RSU5_SAPI_BADI~DATA_TRANSFORM.

**********************************************************
*	To implement an exit for a
*	datasource create your own method by copying the
*	method _TEMPLATE_DATASOURCE and rename it to the name
*	of your datasource. In case you enhance a Business
* Content datasource skip the 0 at the beginning (e.g.
* Datasource 0FI_AR_3 -> Method FI_AR_3
*	The method is then called by the Exit Framework
*********************************************************

  CONSTANTS:
    lk_load(5)          TYPE c VALUE 'LOAD_',
    lk_0_9(10)          TYPE c VALUE'0123456789'.

  DATA: ls_oltpsource    TYPE rsaot_s_osource,
        lv_data          TYPE REF TO data,
        lv_method        TYPE seocmpname.

  FIELD-SYMBOLS: <lt_data>   TYPE STANDARD TABLE.

  CHECK c_t_data IS NOT INITIAL.

*  CALL FUNCTION 'RSA1_SINGLE_OLTPSOURCE_GET'
*    EXPORTING
*      i_oltpsource   = i_datasource
*      i_objvers      = 'A'
*    IMPORTING
*      e_s_oltpsource = ls_oltpsource
*    EXCEPTIONS
*      no_authority   = 1
*      not_exist      = 2
*      inconsistent   = 3
*      OTHERS         = 4.
*
*  IF sy-subrc <> 0.
*    EXIT.
*  ENDIF.
*
**  create data for Extract Structure
*  CREATE DATA lv_data   TYPE TABLE OF (ls_oltpsource-exstruct).
*  ASSIGN lv_data->* TO <lt_data>.
*
*  ASSIGN c_t_data TO <lt_data>.

*	get method name for datasource
  lv_method = i_datasource.

  IF lv_method(1) CA lk_0_9.
*	shift by one character as methods can't start with a number
    SHIFT lv_method.
  ENDIF.
  CONCATENATE lk_load lv_method INTO lv_method.

*	check method is implemented
*  CHECK _check_method_exists( lv_method ) = 'X'.

  TRY.
      CALL METHOD (lv_method)
        EXPORTING
          i_datasource = i_datasource
          i_updmode    = i_updmode
          i_t_select   = i_t_select
          i_t_fields   = i_t_fields
        CHANGING
*          c_t_data     = <lt_data>
          c_t_data     = c_t_data
          c_t_messages = c_t_messages.
    CATCH cx_sy_dyn_call_illegal_method.
  ENDTRY.

  endmethod.


  method IF_EX_RSU5_SAPI_BADI~HIER_TRANSFORM.
* Local data declaration
*  data:
*    l_classname type seoclsname,
*    l_s_msg     type balmi.
*
*Initialization
*  clear:
*    l_classname,
*    l_s_msg.
*
* Determine DataSource specific enhancement class
*  select single classname from ybwsapibadi into l_classname
*    where datasource = i_datasource.
*
* Call DataSource specific enhancement class if found
*  if sy-subrc = 0.
*    try.
*        call method (l_classname)=>yif_sapi_badi_hier_transform~hier_transform
*          exporting
*            i_datasource = i_datasource
*            i_s_hieflag  = i_s_hieflag
*            i_s_hier_sel = i_s_hier_sel
*            i_t_langu    = i_t_langu
*          changing
*            c_t_hietext  = c_t_hietext
*            c_t_hienode  = c_t_hienode
*            c_t_foldert  = c_t_foldert
*            c_t_hieintv  = c_t_hieintv
*            c_t_messages = c_t_messages.
*      catch cx_sy_dyn_call_illegal_class.
*        l_s_msg-msgty = 'E'.
*        l_s_msg-msgid = 'YBWSAPIBADI'.
*        l_s_msg-msgno = '000'.
*        append l_s_msg to c_t_messages.
*        l_s_msg-msgty = 'E'.
*        l_s_msg-msgid = 'YBWSAPIBADI'.
*        l_s_msg-msgno = '001'.
*        l_s_msg-msgv1 = l_classname.
*        append l_s_msg to c_t_messages.
*      catch cx_sy_dyn_call_illegal_method.
*        l_s_msg-msgty = 'E'.
*        l_s_msg-msgid = 'YBWSAPIBADI'.
*        l_s_msg-msgno = '000'.
*        append l_s_msg to c_t_messages.
*        l_s_msg-msgty = 'E'.
*        l_s_msg-msgid = 'YBWSAPIBADI'.
*        l_s_msg-msgno = '003'.
*        append l_s_msg to c_t_messages.
*    endtry.
*  endif.
  endmethod.


  method _TEMPLATE_DATASOURCE.

**  Data Definition
*  DATA: lt_prps     TYPE HASHED TABLE OF prps
*                    WITH UNIQUE KEY pspnr,
*        ls_prps     TYPE prps,
*        lt_data     type STANDARD TABLE OF biw_prps.
*
*  FIELD-SYMBOLS: <l_s_data>    TYPE biw_prps.
*
**  Init
**  Perform always a mass select into an internal table
*  lt_data = c_t_data.
*
*  SELECT * FROM prps INTO TABLE lt_prps
*  FOR ALL ENTRIES IN lt_data
*      WHERE pspnr = lt_data-pspnr.
*
**  map the data
*  LOOP AT c_t_data ASSIGNING <l_s_data>.
*
*    READ TABLE lt_prps INTO ls_prps
*       WITH TABLE KEY pspnr = <l_s_data>-pspnr.
*    IF sy-subrc EQ 0.
*      <l_s_data>-zz_voce_pl = ls_prps-zz_voce_pl.
** !!! No MODIFY necessary as the field is changed immediatly in the
** internal table by using Field Symbols
*    ENDIF.
*  ENDLOOP.

  endmethod.
ENDCLASS.
