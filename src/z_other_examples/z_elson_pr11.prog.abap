*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr11.

*----------------------------------------------------------------------*
* TYPE-POOLS:
*----------------------------------------------------------------------*
TYPE-POOLS: sscr.

*----------------------------------------------------------------------*
* TABLES
*----------------------------------------------------------------------*
TABLES: mara.

*----------------------------------------------------------------------*
* Data Declaration
*----------------------------------------------------------------------*
DATA: gs_opt_list TYPE sscr_opt_list,
      gs_restrict TYPE sscr_restrict,
      gs_ass      TYPE sscr_ass.

*----------------------------------------------------------------------*
* SELECTION-SCREEN
*----------------------------------------------------------------------*
SELECT-OPTIONS: s_matnr FOR mara-matnr NO INTERVALS.
SELECT-OPTIONS: s_mtart FOR mara-mtart NO INTERVALS.

* 1 ---> First EXAMPLE
*---------------------------------------------------------------------*
* Initialization Event
*---------------------------------------------------------------------*
INITIALIZATION.

* Create an option list where only EQUALS is enabled
  gs_opt_list-name       = 'EXAMPLE1'. " Any name
  gs_opt_list-options-eq = 'X'.        " Equals is enabled
  APPEND gs_opt_list TO gs_restrict-opt_list_tab.

* Apply the option list that has only EQUALS enabled to Select-option S_MATNR
  gs_ass-kind    = 'S'.       " Applicable to specific Select-option
  gs_ass-name    = 'S_MATNR'.
  gs_ass-sg_main = '*'.       " Both Include and Exclude options
  gs_ass-op_main = 'EXAMPLE1'.
  APPEND gs_ass TO gs_restrict-ass_tab.

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = gs_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.

* 2 ---> Second EXAMPLE
*---------------------------------------------------------------------*
* Initialization Event
*---------------------------------------------------------------------*
*INITIALIZATION.
*
** Create an option list where EQUALS and NOT EQUALS are enabled
*  gs_opt_list-name       = 'EXAMPLE2'.  " Any name
*  gs_opt_list-options-eq = 'X'.         " Equals is enabled
*  gs_opt_list-options-ne = 'X'.         " Not Equals is enabled
*  APPEND gs_opt_list TO gs_restrict-opt_list_tab.
*
** Apply the option list that has EQUALS and NOT EQUALS enabled to Select-option S_MATNR
*  gs_ass-kind    = 'A'.       " Applicable to ALL Select-options
*  gs_ass-sg_main = 'I'.       " Only Include
*  gs_ass-op_main = 'EXAMPLE2'.
*  APPEND gs_ass TO gs_restrict-ass_tab.
*
*  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
*    EXPORTING
*      restriction            = gs_restrict
*    EXCEPTIONS
*      too_late               = 1
*      repeated               = 2
*      selopt_without_options = 3
*      selopt_without_signs   = 4
*      invalid_sign           = 5
*      empty_option_list      = 6
*      invalid_kind           = 7
*      repeated_kind_a        = 8
*      OTHERS                 = 9.
