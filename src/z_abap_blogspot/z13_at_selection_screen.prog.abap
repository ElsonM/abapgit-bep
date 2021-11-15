*&---------------------------------------------------------------------*
*& Report Z12_AT_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z13_at_selection_screen.

PARAMETERS: p_matnr TYPE mara-matnr,
            p_werks TYPE marc-werks,
            p_lgort TYPE mard-lgort.

* ---> Other fields are editable
*AT SELECTION-SCREEN.
*
*  IF p_werks IS INITIAL.
*    MESSAGE 'Enter Plant' TYPE 'E'.
*  ENDIF.

* ---> Other fields are not editable
AT SELECTION-SCREEN ON p_werks.

  IF p_werks IS INITIAL.
    MESSAGE 'Enter Plant' TYPE 'E'.
  ENDIF.
