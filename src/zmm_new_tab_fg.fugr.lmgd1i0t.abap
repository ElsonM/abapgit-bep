*       - Prüfung bzgl Serialnummernprofil
*       - Prüfung, ob Standardprodukt zugeo. ist
*       - Prüfung, ob das Material als Standardprodukt verwendet wird
*------------------------------------------------------------------
MODULE MARA-MEINS.

  CHECK BILDFLAG IS INITIAL.           "Neu 20.02.93/MK
  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.

* Prüfstatus zurücksetzen, falls Felder geändert wurden.
  IF ( NOT RMMZU-PS_MEINS  IS INITIAL ) AND
* Note 316843
     ( ( UMARA-MEINS NE MARA-MEINS ) OR
* Da im Retail von einem SA auf eine VAR gewechselt werden kann, muß
* auch die MATNR in den Vergleich miteinbezogen werden, weil ansonsten
* die Prüfung für die VAR nicht mehr läuft, wenn die Prüfung schon für
* den SA gelaufen ist und die Daten bei beiden den gleichen Stand haben.
       ( UMARA-MATNR NE MARA-MATNR ) ).
    CLEAR RMMZU-PS_MEINS.
  ENDIF.
* Wenn Prüfstatus = Space, Prüfbaustein aufrufen.
  IF ( RMMZU-PS_MEINS IS INITIAL ).
*mk/4.0 Kopie LMGD2I05 wieder mit Original LMGD1I01 vereint
*im Retailfall wird ein anderer Baustein aufgerufen
    IF RMMG2-FLG_RETAIL IS INITIAL.
      CALL FUNCTION 'MARA_MEINS'
           EXPORTING
                WMARA            = MARA
                WMARC            = MARC
*               ret_meins        = lmara-meins          "TF 4.5B H126371
                AKTYP            = T130M-AKTYP
                NEUFLAG          = NEUFLAG
                MATNR            = RMMG1-MATNR
                ZMARA            = *MARA
                FLG_UEBERNAHME   = ' '
                KZ_MEINS_DIMLESS = RMMG2-MEINS_DIML
                P_MESSAGE        = ' '
                RMMG2_KZMPN      = RMMG2-KZMPN  "mk/4.0A
                REPID            = SY-REPID               "note 2309145
                DYNNR            = SY-DYNNR               "note 2309145
           IMPORTING
                FLAG1            = FLAG1
                FLAG2            = FLAG2
                WMARA            = MARA
           TABLES
                MEINH            = MEINH
           CHANGING                                     "TF 4.5B H126371
                RET_MEINS        = LMARA-MEINS          "TF 4.5B H126371
           EXCEPTIONS
                ERROR_MPN        = 01.
      IF NOT SY-SUBRC IS INITIAL.
        BILDFLAG = 'X'.
        MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ELSE.                              "Retailfall
      CALL FUNCTION 'MARA_MEINS_RETAIL'"BE/030996
           EXPORTING
                WMARA            = MARA
*               ret_meins        = lmara-meins          "TF 4.5B H126371
                AKTYP            = T130M-AKTYP
                NEUFLAG          = NEUFLAG
                MATNR            = RMMG1-MATNR
                ZMARA            = *MARA
                KZ_MEINS_DIMLESS = RMMG2-MEINS_DIML
                RMMG2_KZMPN      = RMMG2-KZMPN     "mk/4.0A
           IMPORTING
                FLAG1            = FLAG1
                FLAG2            = FLAG2
                WMARA            = MARA
           TABLES
                MEINH            = MEINH
           CHANGING                                     "TF 4.5B H126371
                RET_MEINS        = LMARA-MEINS.         "TF 4.5B H126371
    ENDIF.
    IF NOT FLAG1 IS INITIAL OR NOT FLAG2 IS INITIAL.
      RMMZU-PS_MEINS = X.
      UMARA = MARA.
    ELSE.
      CLEAR RMMZU-PS_MEINS.
    ENDIF.
  ELSE.
* Wenn Prüfstatus = X und Felder wurden nicht geändert, Folgebearbeitung
*--- Aktualisieren der internen Tabelle Meinh und alte ME--------------
    PERFORM MEINH_AKTUALISIEREN.
    CLEAR: FLAG1, FLAG2.
  ENDIF.

ENHANCEMENT-POINT LMGD1I0T_02 SPOTS ES_LMGD1I0T INCLUDE BOUND .


  IF NOT FLAG1 IS INITIAL AND FLAG2 IS INITIAL.
*----Basis-ME änderbar - aber abhängige Objekte sind zu prüfen ---
    IF NOT SY-BINPT IS INITIAL.
      MESSAGE W188 WITH *MARA-MEINS MARA-MEINS.
    ELSE.
* Aufruf Warnungsbild 551
      RMMZU-HOKCODE   = OK-CODE.
      RMMZU-OKCODE    = FCODE_BMEW.
      RMMZU-BILDFOLGE = X.
      BILDFLAG        = X.
    ENDIF.
  ENDIF.

  IF NOT FLAG2 IS INITIAL.
*---- Basis-ME nicht änderbar --------------------------------------
    MOVE *MARA-MEINS TO MARA-MEINS.
*mk/3.0C UMARA zu früh gefüllt, deswegen ging der 2. Änderungsversuch
*mit der gleichen ME durch
    UMARA = MARA.                      "mk/3.0C
    RMMZU-ERR_BME = X.
    RMMZU-FLG_FLISTE = X.

* ch/4.6C: Dequeue deaktiviert, da dieser die MARA-Sperre zurücknimmt !!
* (Ansonsten hat dieser Dequeue keine Wirkung gehabt, da er ohne
* OrgEbene abgesetzt wurde und daher nur generische (MARC-/MBEW-/..)
* Sperren ohne OrgEbene zurücksetzen würde. Solche Sperren werden aber
* schon lange nicht mehr abgesetzt)         "
*   CALL FUNCTION 'DEQUEUE_EMMATAE'         "
*        EXPORTING                          "
*             MATNR = RMMG1-MATNR.

* JH/20.03.98/4.0C Neues Sperrobj. für die Basismengeneinheit (Anfang)
    CALL FUNCTION 'DEQUEUE_EMMARME'
         EXPORTING
              MATNR = RMMG1-MATNR.     "generisch alle ME
    IF LMARA-ATTYP = ATTYP_SAMM.
      PERFORM DEQUEUE_VARIANTS USING RMMG1-MATNR.
    ENDIF.
* JH/20.03.98/4.0C Neues Sperrobj. für die Basismengeneinheit (Ende)
    IF NOT SY-BINPT IS INITIAL OR NOT SY-BATCH IS INITIAL.
      MESSAGE E189.
    ENDIF.
    MESSAGE S189.                      "Änderung GUI-Status
    BILDFLAG = X.
  ENDIF.
ENHANCEMENT-POINT LMGD1I0T_01 SPOTS ES_LMGD1I0T INCLUDE BOUND.


ENDMODULE.
