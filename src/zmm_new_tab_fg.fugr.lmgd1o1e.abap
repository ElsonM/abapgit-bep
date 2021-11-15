*&---------------------------------------------------------------------*
*&      Module  FAUSW_BEZEICHNUNGEN  OUTPUT
*&---------------------------------------------------------------------*
* Ausblenden der Texte zu den unsichtbaren Feldern                     *
* insbesondere auch die Daten zum Einkaufswerteschlüssel, falls dieser
* ausgeblendet ist
*----------------------------------------------------------------------*
MODULE fausw_bezeichnungen OUTPUT.

  DATA: hgroup1 LIKE screen-group1.

  hgroup1(1) = 'F'.
  LOOP AT SCREEN.
*   check screen-group1(1) eq 'T' and screen-input eq 0.
*mk/4.0A für Buttons sitzt input = 1
    IF screen-group1(1) EQ 'T'.
      hgroup1+1 = screen-group1+1.
      READ TABLE feldbeztab WITH KEY group1 = hgroup1.
      IF sy-subrc NE 0.
        screen-invisible = 1.
        screen-output    = 0.
        screen-input     = 0.     "mk/4.0A
        MODIFY SCREEN.
        CONTINUE.
      ENDIF.
    ENDIF.
*   note 1611251: extend the logic also for SCREEN-GROUP2
    IF screen-group2(1) EQ 'T'.
      hgroup1+1 = screen-group2+1.
      READ TABLE feldbeztab2 WITH KEY group1 = hgroup1.
      IF sy-subrc NE 0.
        screen-invisible = 1.
        screen-output    = 0.
        screen-input     = 0.     "mk/4.0A
        MODIFY SCREEN.
        CONTINUE.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDMODULE.                             " FAUSW_BEZEICHNUNGEN  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  FELDAUSW_TEXTE  OUTPUT
*&---------------------------------------------------------------------*
* Ausblenden der Texte zu den unsichtbaren Feldern, wenn kein Lagerort *
* eingegeben (nur für Dynpro 2732)                                     *
*----------------------------------------------------------------------*
MODULE feldausw_texte OUTPUT.

  CHECK rmmg1-lgnum IS INITIAL.                        "begin 783025
  LOOP AT SCREEN.
    CHECK screen-group1(1) EQ 'T'.
    screen-invisible = 1.
    screen-output    = 0.
    screen-input     = 0.
    MODIFY SCREEN.
  ENDLOOP.                                                  "end 783025

ENDMODULE.                                  " FELDAUSW_TEXTE  OUTPUT
