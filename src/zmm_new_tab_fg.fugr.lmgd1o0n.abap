*&---------------------------------------------------------------------*
*&      Module  GET_VERB_SUB  OUTPUT
*&---------------------------------------------------------------------*
*       Analog GET_DATEN_SUB aber speziell für Verbrauchswerte         *
*----------------------------------------------------------------------*
MODULE GET_VERB_SUB OUTPUT.

  CHECK NOT ANZ_SUBSCREENS IS INITIAL.

  IF NOT KZ_EIN_PROGRAMM IS INITIAL.
    IF NOT KZ_BILDBEGINN IS INITIAL.
      CLEAR SUB_ZAEHLER.
*     IF BILDFLAG IS INITIAL OR NOT BILDTAB-KZPRO IS INITIAL.
* AHE: 19.02.96 bildtab-kzpro darf nicht mehr benutzt werden (3.0D)
      IF BILDFLAG IS INITIAL OR NOT RMMZU-BILDPROZ IS INITIAL.
        PERFORM ZUSATZDATEN_GET_SUB.
      ENDIF.
    ENDIF.

* Achtung:
* Spezielles Lesen der Verbrauchs-Daten und wir befinden uns NICHT auf
* dem ersten Bildbaustein des Trägerdynpros  ==> es muß unabhängig von
* KZ_BILDBEGINN gelesen werden (und nicht direkt hinter dem Form
* ZUSATZDATEN_GET_SUB).
    CALL FUNCTION 'MVER_GET_SUB'
         TABLES
              WUNG_VERBTAB = UNG_VERBTAB
              WGES_VERBTAB = GES_VERBTAB
              XUNG_VERBTAB = DUNG_VERBTAB
              XGES_VERBTAB = DGES_VERBTAB
              YUNG_VERBTAB = LUNG_VERBTAB
              YGES_VERBTAB = LGES_VERBTAB.

ENHANCEMENT-POINT GET_VERB_SUB_01 SPOTS ES_LMGD1O0N INCLUDE BOUND.
* AHE: 20.11.95 - A
    CALL FUNCTION 'MARC_GET_SUB'
         IMPORTING
              WMARC = MARC
              XMARC = *MARC
              YMARC = LMARC.

    CALL FUNCTION 'T001W_SINGLE_READ'
         EXPORTING
              KZRFB       = KZRFB
              T001W_WERKS = MARC-WERKS
         IMPORTING
              WT001W      = T001W
         EXCEPTIONS
              NOT_FOUND   = 1
              OTHERS      = 2.
* AHE: 20.11.95 - E

  ELSE.
*   IF BILDFLAG IS INITIAL OR NOT BILDTAB-KZPRO IS INITIAL.
* AHE: 19.02.96 bildtab-kzpro darf nicht mehr benutzt werden (3.0D)
    IF BILDFLAG IS INITIAL OR NOT RMMZU-BILDPROZ IS INITIAL.
      PERFORM ZUSATZDATEN_GET_SUB.
      CALL FUNCTION 'MVER_GET_SUB'
           TABLES
                WUNG_VERBTAB = UNG_VERBTAB
                WGES_VERBTAB = GES_VERBTAB
                XUNG_VERBTAB = DUNG_VERBTAB
                XGES_VERBTAB = DGES_VERBTAB
                YUNG_VERBTAB = LUNG_VERBTAB
                YGES_VERBTAB = LGES_VERBTAB.

ENHANCEMENT-POINT GET_VERB_SUB_02 SPOTS ES_LMGD1O0N INCLUDE BOUND.
* AHE: 20.11.95 - A
      CALL FUNCTION 'MARC_GET_SUB'
           IMPORTING
                WMARC = MARC
                XMARC = *MARC
                YMARC = LMARC.

      CALL FUNCTION 'T001W_SINGLE_READ'
           EXPORTING
                KZRFB       = KZRFB
                T001W_WERKS = MARC-WERKS
           IMPORTING
                WT001W      = T001W
           EXCEPTIONS
                NOT_FOUND   = 1
                OTHERS      = 2.
* AHE: 20.11.95 - E

    ENDIF.
  ENDIF.
    IF T130M-AKTYP = AKTYPH.
    PERFORM ZUSATZDATEN_GET_SUB.
  ENDIF.


ENDMODULE.                             " GET_VERB_SUB  OUTPUT
