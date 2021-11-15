*&---------------------------------------------------------------------*
*&      Module  SET_DATEN_SUB
*&---------------------------------------------------------------------*
* Zurückgeben der Daten des Bildbausteins an die U-WA´s, falls         *
* nicht alle Bildbausteine des Bildes zu einem einheitlichen Programm
* gehören
* Festhalten der aktuellen REFTAB (zusätzliches Vorlagehandling)
*----------------------------------------------------------------------*
MODULE SET_DATEN_SUB OUTPUT.

*mk/3.0E Setzen Kz. 'Status-Update am Ende des Bildes erforderlich',
*falls auf dem Bild Felder zu statusrelevanten Tabellen vorhanden
*sind
  IF RMMZU-KZSTAT_UPD IS INITIAL.
    LOOP AT SUB_PTAB WHERE NOT KZSTA IS INITIAL.
      RMMZU-KZSTAT_UPD = X.
    ENDLOOP.
  ENDIF.

  IF ANZ_SUBSCREENS IS INITIAL.
* Keine Bildbausteine auf dem Bild vorhanden
    CALL FUNCTION 'MAIN_PARAMETER_SET_REFTAB'
         EXPORTING
              RMMZU_KZSTAT_UPD = RMMZU-KZSTAT_UPD
         TABLES
              REFTAB           = REFTAB.
  ELSEIF NOT KZ_EIN_PROGRAMM IS INITIAL.
* Bildbausteine auf dem Bild vorhanden, alle aus einheitlichem Programm
    CLEAR KZ_BILDBEGINN.
    SUB_ZAEHLER = SUB_ZAEHLER + 1.
    IF SUB_ZAEHLER EQ ANZ_SUBSCREENS.
      KZ_BILDBEGINN = X.               "für PAI notwendig
      CALL FUNCTION 'MAIN_PARAMETER_SET_REFTAB'
           EXPORTING
                RMMZU_KZSTAT_UPD = RMMZU-KZSTAT_UPD
           TABLES
                REFTAB           = REFTAB.
    ENDIF.
  ELSE.
* Bildbausteine auf dem Bild vorhanden, aus unterschiedlichen Programmen
    PERFORM ZUSATZDATEN_SET_SUB.
    PERFORM MATABELLEN_SET_SUB.
    CALL FUNCTION 'MAIN_PARAMETER_SET_REFTAB'
         EXPORTING
              RMMZU_KZSTAT_UPD = RMMZU-KZSTAT_UPD
         TABLES
              REFTAB           = REFTAB.
  ENDIF.
  IF T130M-AKTYP = AKTYPH.
    PERFORM ZUSATZDATEN_SET_SUB.
    CALL FUNCTION 'MAIN_PARAMETER_SET_REFTAB'
      EXPORTING
           RMMZU_KZSTAT_UPD = RMMZU-KZSTAT_UPD
      TABLES
           REFTAB           = REFTAB.

  ENDIF.
ENHANCEMENT-POINT LMGD1019_01 SPOTS ES_LMGD1019 INCLUDE BOUND.

ENDMODULE.                             " SET_DATEN_SUB  OUTPUT
