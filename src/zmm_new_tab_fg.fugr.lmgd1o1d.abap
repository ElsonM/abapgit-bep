*------------------------------------------------------------------
*           Feldauswahl
*
*Die Feldauswahlleiste wird im Modul VERK_FELDAUSWAHL erstellt.
*mk/12.07.95 Lesen T130F vorgezogen aus FB incl. Fauswtab ergänzen
*mk/05.12.95 KZINI wird nur im Erweiterungsfall benötigt bzw.
*für den Kurtext im Anlegefall (Sonfausw_in_fgrup) sowie für Kopffelder
*------------------------------------------------------------------
MODULE FELDAUSWAHL OUTPUT.

* (del) TRANSLATE AKTVSTATUS USING ' $'.                     "BE/070597

*-------- Aufbauen Feldauswahl-Tabelle --------------------------------

  PERFORM T130F_LESEN_KOMPLETT.

  REFRESH FAUSWTAB.   CLEAR FAUSWTAB.
  CLEAR CHAR_2.  "temp. Hilfsfeld für SCREEN-GROUP+1 wg. Ausblenden
  "Bezeichnungen zu ausgebl. zentralen Daten  /ch zu 3.0F

  LOOP AT SCREEN.
    CLEAR KZ_FIELD_INITIAL.

ENHANCEMENT-POINT LMGD1O1D_01 SPOTS ES_LMGD1O1D INCLUDE BOUND.

*mk/05.12.95 nur beim Erweitern sowie für Kurztext und Kopffelder
*wird die Information benötigt, ob Feld initial ist
    IF SCREEN-NAME CA '-'.             "mk/4.0A sonst Dump
      IF ( T130M-AKTYP = AKTYPH AND NEUFLAG IS INITIAL )        OR
         ( T130M-AKTYP = AKTYPH  AND SCREEN-NAME = MAKT_MAKTX ) OR
         ( SCREEN-NAME(5) = T_RMMG1 AND SCREEN-NAME NE RMMG1_MATNR
                                    AND SCREEN-NAME(9) NE T_RMMG1_BEZ ).
*   ASSIGN (SCREEN-NAME) TO <F>.     mk/05.12.95
        ASSIGN TABLE FIELD (SCREEN-NAME) TO <F>.
*       if <f> is initial.                        "mk/4.0A
        IF SY-SUBRC EQ 0 AND <F> IS INITIAL.      "mk/4.0A
          KZ_FIELD_INITIAL = X.        "Übergabe Kennung Feld initial
* Ungefüllte OrgEbenenfelder werden ausgeblendet
          IF SCREEN-NAME(5) = T_RMMG1 AND SCREEN-NAME NE RMMG1_MATNR
                                      AND SCREEN-NAME(9) NE T_RMMG1_BEZ.
            SCREEN-INVISIBLE = 1.
            SCREEN-ACTIVE    = 0.
            SCREEN-OUTPUT    = 0.      "mk/3.0D
            SCREEN-INPUT     = 0.      "mk/3.0D
            SCREEN-REQUIRED  = 0.      "mk/3.0D
          ENDIF.
        ENDIF.
      ENDIF.
ENHANCEMENT-POINT LMGD1O1D_06 SPOTS ES_LMGD1O1D INCLUDE BOUND .
    ENDIF.                             "mk/4.0A

*   Auswerten der Berechtigung für zentrale Felder.     neu zu 3.0F
    IF RMMG2-MANBR NE SPACE.
      IF SCREEN-NAME(4) = T_MARA   OR SCREEN-NAME(4) = T_MAKT
      OR SCREEN-NAME(4) = T_MARM   OR SCREEN-NAME(4) = T_MEAN
      OR SCREEN-NAME(6) = T_SMEINH OR SCREEN-NAME(6) = T_SKTEXT
      OR SCREEN-NAME = RMMZU_XLTYF
      OR SCREEN-NAME = KT_DELETE       "Löschen KText /ch zu 4.0
      OR SCREEN-NAME = ME_DELETE       "Löschen ME    /ch zu 4.0
      OR SCREEN-NAME = EAN_DELETE .    "Löschen EAN   /ch zu 4.0
        IF RMMG2-MANBR = 1
        OR SCREEN-NAME    = MARA_MEINS "BasisME wird nicht ausgebl.
        OR SCREEN-NAME(4) = T_MAKT     "Kurztexte werden nicht ausgebl.
        OR SCREEN-NAME(6) = T_SKTEXT.
          IF SCREEN-NAME NE MARA_LGHTY.
            SCREEN-INPUT     = 0.
            SCREEN-REQUIRED  = 0.
          ENDIF.
        ELSE.
          SCREEN-INVISIBLE = 1.
          SCREEN-ACTIVE    = 0.
          SCREEN-OUTPUT    = 0.
          SCREEN-INPUT     = 0.
          SCREEN-REQUIRED  = 0.
        ENDIF.
      ENDIF.
    ENDIF.
ENHANCEMENT-POINT LMGD1O1D_05 SPOTS ES_LMGD1O1D INCLUDE BOUND.

*   note 1296499: use SMEINH-EAN11/NUMTP for MEAN fields
    IF SCREEN-NAME = 'MEAN-EAN11'.
      SCREEN-NAME = 'SMEINH-EAN11'.
    ENDIF.
    IF SCREEN-NAME = 'MEAN-EANTP'.
      SCREEN-NAME = 'SMEINH-NUMTP'.
    ENDIF.

*   note 1358288: override invisible flag set by table control to
*   enable correct execution of field selection
    IF <F_TC> IS ASSIGNED.
      READ TABLE <F_TC>-COLS INTO TC_COL WITH KEY SCREEN-NAME = SCREEN-NAME.
      IF sy-subrc = 0 AND SCREEN-INVISIBLE = 1.
        SCREEN-INVISIBLE = 0.
      ENDIF.
    ENDIF.

    FAUSWTAB-FNAME = SCREEN-NAME.
    FAUSWTAB-KZINI = KZ_FIELD_INITIAL.
    FAUSWTAB-KZACT = SCREEN-ACTIVE.
    FAUSWTAB-KZINP = SCREEN-INPUT.
    FAUSWTAB-KZINT = SCREEN-INTENSIFIED.
    FAUSWTAB-KZINV = SCREEN-INVISIBLE.
    FAUSWTAB-KZOUT = SCREEN-OUTPUT.
    FAUSWTAB-KZREQ = SCREEN-REQUIRED.
    READ TABLE IT130F WITH KEY FNAME = FAUSWTAB-FNAME BINARY SEARCH.
    IF SY-SUBRC NE 0.
      CLEAR IT130F.
*mk/4.0A Sonderlogik für Pushbuttons etc.
      SPLIT SCREEN-NAME AT '-' INTO IT130F-TBNAM IT130F-FIELDNAME.
      IF IT130F-FIELDNAME IS INITIAL.
        SPLIT SCREEN-NAME AT '_' INTO IT130F-TBNAM IT130F-FIELDNAME.
      ENDIF.
    ENDIF.
    FAUSWTAB-PSTAT = IT130F-PSTAT.
    FAUSWTAB-KZREF = IT130F-KZREF.
    FAUSWTAB-KZKEY = IT130F-KZKEY.
    FAUSWTAB-SFGRU = IT130F-SFGRU.
    FAUSWTAB-KZKMA = IT130F-KZKMA.
    FAUSWTAB-FGRUP = IT130F-FGRUP.
    FAUSWTAB-TBNAM = IT130F-TBNAM.     "mk/4.0A
    FAUSWTAB-FIELDNAME  = IT130F-FIELDNAME.        "mk/4.0A
    FAUSWTAB-FGROU = IT130F-FGROU.     "4.0A  BE/190997
    fauswtab-fixre = it130f-fixre.     "TF 4.6C Materialfixierung

ENHANCEMENT-POINT LMGD1O1D_02 SPOTS ES_LMGD1O1D INCLUDE BOUND.
    APPEND FAUSWTAB.
  ENDLOOP.

*---------Feldauswahl Langtexte TF 4.6A--------------------------------
* Langtextbilder werden als Ganzes über einen einzigen Eintrag in der
* T130F verwaltet. In der Langtextpflege wird fauswtab um den ent-
* sprechenden Eintrag erweitert, welcher der standardmäßigen Feldauswahl
* unterzogen wird. Abhängig vom Ergebnis werden die Parameter ltext_*
* gesetzt und danach der Eintrag aus der fauswtab wieder entfernt.

  if not langtextbild_feldauswahl is initial.
    case langtextbild_feldauswahl.
      when GRUNDDTEXT_BILD.
        FAUSWTAB-FNAME = ltext_grun.
      when BESTELLTEXT_BILD.
        FAUSWTAB-FNAME = ltext_best.
      when VERTRIEBSTEXT_BILD.
        FAUSWTAB-FNAME = ltext_vert.
      when IVERMTEXT_BILD.
        FAUSWTAB-FNAME = ltext_iver.
      when PRUEFTEXT_BILD.
        FAUSWTAB-FNAME = ltext_prue.
      when GRUNDDTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_grun.
      when BESTELLTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_best.
      when VERTRIEBSTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_vert.
      when IVERMTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_iver.
      when PRUEFTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_prue.
    endcase.
    if anz_sprachen > 0.               "TF 4.6C Materialfixierung
      FAUSWTAB-KZINI = ' '.
    else.                              "TF 4.6C Materialfixierung
      FAUSWTAB-KZINI = 'X'.            "TF 4.6C Materialfixierung
    endif.                             "TF 4.6C Materialfixierung
    FAUSWTAB-KZACT = 1.
    FAUSWTAB-KZINP = 1.
    FAUSWTAB-KZINT = 0.
    FAUSWTAB-KZINV = 0.
    FAUSWTAB-KZOUT = 1.
    FAUSWTAB-KZREQ = 0.
    READ TABLE IT130F WITH KEY FNAME = FAUSWTAB-FNAME BINARY SEARCH.
    IF SY-SUBRC NE 0.
      CLEAR IT130F.
*mk/4.0A Sonderlogik für Pushbuttons etc.
      SPLIT SCREEN-NAME AT '-' INTO IT130F-TBNAM IT130F-FIELDNAME.
      IF IT130F-FIELDNAME IS INITIAL.
        SPLIT SCREEN-NAME AT '_' INTO IT130F-TBNAM IT130F-FIELDNAME.
      ENDIF.
    ENDIF.
    FAUSWTAB-PSTAT = IT130F-PSTAT.
    FAUSWTAB-KZREF = IT130F-KZREF.
    FAUSWTAB-KZKEY = IT130F-KZKEY.
    FAUSWTAB-SFGRU = IT130F-SFGRU.
    FAUSWTAB-KZKMA = IT130F-KZKMA.
    FAUSWTAB-FGRUP = IT130F-FGRUP.
    FAUSWTAB-TBNAM = IT130F-TBNAM.     "mk/4.0A
    FAUSWTAB-FIELDNAME  = IT130F-FIELDNAME.        "mk/4.0A
    FAUSWTAB-FGROU = IT130F-FGROU.     "4.0A  BE/190997
    fauswtab-fixre = it130f-fixre.     "TF 4.6C Materialfixierung
    APPEND FAUSWTAB.
  endif.
*---------Feldauswahl Langtexte TF 4.6A--------------------------------


*---------Feldauswahl Dokumentdaten ( note 522456 )------------------
* Dokumentdaten werden als Ganzes über einen einzigen Eintrag in der
* T130F verwaltet. In der Dokumentdatenpflege wird fauswtab um den ent-
* sprechenden Eintrag erweitert, welcher der standardmäßigen Feldauswahl
* unterzogen wird.
* Danach der Eintrag aus der fauswtab wieder entfernt.

  IF NOT dokumente_feldauswahl IS INITIAL.
    CASE dokumente_feldauswahl.
      WHEN dokumente_bild.
        fauswtab-fname = 'DOKUMENTE'.
    ENDCASE.


    fauswtab-kzact = 1.
    fauswtab-kzinp = 1.
    fauswtab-kzint = 0.
    fauswtab-kzinv = 0.
    fauswtab-kzout = 1.
    fauswtab-kzreq = 0.

    READ TABLE it130f WITH KEY fname = fauswtab-fname BINARY SEARCH.

    fauswtab-pstat = it130f-pstat.
    fauswtab-kzref = it130f-kzref.
    fauswtab-kzkey = it130f-kzkey.
    fauswtab-sfgru = it130f-sfgru.
    fauswtab-kzkma = it130f-kzkma.
    fauswtab-fgrup = it130f-fgrup.
    fauswtab-tbnam = it130f-tbnam.     "mk/4.0A
    fauswtab-fieldname  = it130f-fieldname.        "mk/4.0A
    fauswtab-fgrou = it130f-fgrou.     "4.0A  BE/190997
    fauswtab-fixre = it130f-fixre.     "TF 4.6C Materialfixierung
    APPEND fauswtab.
  ENDIF.
*---------Feldauswahl Dokumentdaten ( note 522456 )-------

  SORT FAUSWTAB BY FNAME.

*-------- Aufrufen FB für Feldauswahl ---------------------------------

* Vereinigung der Feldauswahl-FB's Industrie und Retail      "BE/130197
* CALL FUNCTION 'MATERIAL_FIELD_SELECTION'                   "BE/130197
  CALL FUNCTION 'MATERIAL_FIELD_SELECTION_NEW'               "BE/130197
        EXPORTING
             AKTVSTATUS   = AKTVSTATUS
             IT130M       = T130M
             NEUFLAG      = NEUFLAG
             IRMMG1       = RMMG1
             IRMMG2       = RMMG2                                       " n_2307549
             RMMG2_KZKFG  = MARA-KZKFG
             IT134_WMAKG  = T134-WMAKG "4.0A  BE/050697
             IMARC_DISPR  = MARC-DISPR
             IMARC_PSTAT  = MARC-PSTAT
             IMPOP_PROPR  = MPOP-PROPR
             IMVKE_PMATN  = MVKE-PMATN "BE/130197
             IMBEW_BWTTY  = MBEW-BWTTY "4.0A  BE/150897
             RMMG2_KZMPN  = RMMG2-KZMPN"mk/4.0A  MPN
             IMARA_MSTAE  = MARA-MSTAE "4.0A  BE/071097
             IT133A_PSTAT = T133A-PSTAT"RWA Hinw.127870
             iv_matfi     = mara-matfi "TF 4.6C Materialfixierung
        TABLES
             FAUSWTAB     = FAUSWTAB
             PTAB         = PTAB.


ENHANCEMENT-POINT LMGD1O1D_03 SPOTS ES_LMGD1O1D INCLUDE BOUND.
*---------Feldauswahl Langtexte TF 4.6A--------------------------------

  if not langtextbild_feldauswahl is initial.
    case langtextbild_feldauswahl.
      when GRUNDDTEXT_BILD.
        FAUSWTAB-FNAME = ltext_grun.
      when BESTELLTEXT_BILD.
        FAUSWTAB-FNAME = ltext_best.
      when VERTRIEBSTEXT_BILD.
        FAUSWTAB-FNAME = ltext_vert.
      when IVERMTEXT_BILD.
        FAUSWTAB-FNAME = ltext_iver.
      when PRUEFTEXT_BILD.
        FAUSWTAB-FNAME = ltext_prue.
      when GRUNDDTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_grun.
      when BESTELLTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_best.
      when VERTRIEBSTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_vert.
      when IVERMTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_iver.
      when PRUEFTXTE_BILD.
        FAUSWTAB-FNAME = ltxte_prue.
    endcase.
    read table fauswtab with key fname = fauswtab-fname.
    ltext_invisible = FAUSWTAB-KZINV.
    ltext_input = fauswtab-kzinp.
    ltext_required = fauswtab-kzreq.
    delete fauswtab index sy-tabix.

* siehe Hinweis 516889 wg02.05.02
   IF ( t130m-aktyp = aktypa OR t130m-aktyp = aktypz ).
     READ TABLE fauswtab WITH KEY fname = 'DESC_LANGU_GDTXT'.
       if sy-subrc = 0.
         fauswtab-kzinp = '0'.
         modify fauswtab index sy-tabix.
       endif.
   ENDIF.

endif.
*---------Feldauswahl Langtexte TF 4.6A--------------------------------

*---------Feldauswahl Dokumentdaten ( note 522456 )-----------------
* die Anzeigeeigenschaften der Dokumentdaten kann nur auf Anzeigen
* beschränkt werden. Ausblenden bzw. Mußfeld werden nicht unterstützt

  IF NOT dokumente_feldauswahl IS INITIAL.
    CASE dokumente_feldauswahl.
      WHEN dokumente_bild.
        fauswtab-fname = 'DOKUMENTE'.
    ENDCASE.
    READ TABLE fauswtab WITH KEY fname = fauswtab-fname.
    dokumente_input = fauswtab-kzinp.
    DELETE fauswtab INDEX sy-tabix.
  ENDIF.

*---------Feldauswahl Dokumentdaten  ( note 522456 ) -----------------


*-------- Modifizieren Screen über Feldauswahl-Tabelle ----------------

  LOOP AT SCREEN.

*   read table fauswtab with key screen-name binary search.  mk/4.0A
    READ TABLE FAUSWTAB WITH KEY FNAME = SCREEN-NAME BINARY SEARCH.

    SCREEN-ACTIVE      = FAUSWTAB-KZACT.
    SCREEN-INPUT       = FAUSWTAB-KZINP.
    SCREEN-INTENSIFIED = FAUSWTAB-KZINT.
    SCREEN-INVISIBLE   = FAUSWTAB-KZINV.
    SCREEN-OUTPUT      = FAUSWTAB-KZOUT.

* note 549538
* Kennzeichen nicht übernehmen für Bezeichnungen
    IF SCREEN-GROUP1(1) NE 'T'.
      SCREEN-REQUIRED    = FAUSWTAB-KZREQ.
    ENDIF.

*   note 1358288: override columns set by TC_VIEW customizing
    IF <F_TC> IS ASSIGNED.
      READ TABLE <F_TC>-COLS INTO TC_COL WITH KEY SCREEN-NAME = SCREEN-NAME.
      IF sy-subrc = 0.
*       If field is set by table control to invisible and it is not
*       required due to material field selection, then hide the field.
*       Otherwise make sure, that the field is not hidden.
        IF TC_COL-INVISIBLE = CX_TRUE AND SCREEN-REQUIRED = 0.
          SCREEN-INVISIBLE = 1.
          SCREEN-ACTIVE    = 1.                            "note 1575018
          SCREEN-OUTPUT    = 1.                            "note 1575018
          SCREEN-INPUT     = 0.
        ELSEIF SCREEN-INVISIBLE = 1.
          SCREEN-ACTIVE    = 1.                            "note 1575018
          SCREEN-OUTPUT    = 1.                            "note 1575018
          TC_COL-INVISIBLE = CX_TRUE.
        ELSE.
          TC_COL-INVISIBLE = CX_FALSE.
        ENDIF.
        TC_COL-SCREEN = SCREEN.
        MODIFY <F_TC>-COLS FROM TC_COL INDEX sy-tabix.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.



ENHANCEMENT-POINT LMGD1O1D_04 SPOTS ES_LMGD1O1D INCLUDE BOUND.
* (del) TRANSLATE AKTVSTATUS USING '$ '.                     "BE/070597

ENDMODULE.
