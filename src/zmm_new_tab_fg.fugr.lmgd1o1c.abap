*------------------------------------------------------------------
*        GET_DATEN_SUB
*
*- Holen der Materialstammdaten aus den U-WA´s in den Bildbaustein
* Falls keine Subscreens vorhanden sind, ist dies bereits schon im
* Modul get_daten_bild ausgeführt
* Die Daten werden nur beschafft, wenn das Bild nicht wiederholt
* wird oder das Bild bereits vollständig prozessiert wurde
*------------------------------------------------------------------
MODULE GET_DATEN_SUB OUTPUT.

  CHECK NOT ANZ_SUBSCREENS IS INITIAL.
*wk/4.0
  FLG_TC = ' '.

*
*mk/1.2B Die temporären Daten müssen unabhängig vom Bildflag aus
*den Puffern geholt werden, damit z.B. nach einem Wechsel auf
*
  IF NOT KZ_EIN_PROGRAMM IS INITIAL.
    IF NOT KZ_BILDBEGINN IS INITIAL.
      CLEAR SUB_ZAEHLER.
*     IF BILDFLAG IS INITIAL OR NOT BILDTAB-KZPRO IS INITIAL
*        OR NOT RMMZU-BILDPROZ IS INITIAL.   mk/3.0D
*mk/07.02.96 bildtab-kzpro darf nicht mehr benutzt werden
*     IF BILDFLAG IS INITIAL OR NOT RMMZU-BILDPROZ IS INITIAL. mk/1.2B
      PERFORM ZUSATZDATEN_GET_SUB.
      PERFORM MATABELLEN_GET_SUB.
*     ENDIF.
    ENDIF.
  ELSE.
*   IF BILDFLAG IS INITIAL OR NOT BILDTAB-KZPRO IS INITIAL
*      OR NOT RMMZU-BILDPROZ IS INITIAL.
*   IF BILDFLAG IS INITIAL OR NOT RMMZU-BILDPROZ IS INITIAL.  mk/1.2B
    PERFORM ZUSATZDATEN_GET_SUB.
    PERFORM MATABELLEN_GET_SUB.
*   ENDIF.
  ENDIF.
  IF T130M-AKTYP = AKTYPH.
    PERFORM ZUSATZDATEN_GET_SUB.
  ENDIF.


ENDMODULE.
