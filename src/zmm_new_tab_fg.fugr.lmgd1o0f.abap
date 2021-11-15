*----------------------------------------------------------------------*
*        Module ANZEIGEN_TAXIM OUTPUT                                  *
* Anzeigen des Steuerindikators für den Einkauf.                       *
*----------------------------------------------------------------------*
MODULE ANZEIGEN_TAXIM OUTPUT.

  READ TABLE STEUMMTAB INDEX 1.
  CHECK SY-SUBRC = 0.

*-------Aufbereiten Daten für Dynpro-----------------------------------
  MOVE STEUMMTAB TO MG03STEUMM.

ENDMODULE.                             " ANZEIGEN_TAXIM  OUTPUT
