*------------------------------------------------------------------
*  Module SONFAUSW_IN_FGUPPEN.
*------------------------------------------------------------------
* Felder ,die in T130F zu einer Sonderfeldauswahlgruppe zusammenge-
* fasst wurden, werden in Abhaengigkeit von der Gruppennummer einer
* Sonderbehandlung unterzogen.
* Sonderregel 010 neu für Änderungsdienst                 QHBADIK001125
* mk/27.02.95: Festhalten der ausgeblendeten Felder, denen reine
* Anzeigetexte zugeordnet sind (Screen-Group1 gefüllt) in der
* internen Tabelle feldbeztab
*mk/1995: Feldauswahl für KMAT wird hier ebenfalls ausgeführt
*------------------------------------------------------------------
MODULE SONFAUSW_IN_FGRUPPEN OUTPUT.

*-------- Aufbauen Feldauswahl-Tabelle --------------------------------

* Tabelle FAUSWTAB wird in Module FELDAUSWAHL/ANF_FELDAUSWAHL aufgebaut

*mk/12.07.95 Aufbauen Fauswtab_Sond gemäß Fauswtab
  REFRESH FAUSWTAB_SOND.
*mk/3.1G/1.2B Tuning: fauswtab ist in der Regel kleiner als ftab_sfgrup
*(ftab_sfgrup ist sortiert)
* LOOP AT FTAB_SFGRUP.
*   READ TABLE FAUSWTAB WITH KEY FTAB_SFGRUP-FNAME BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     FAUSWTAB_SOND = FAUSWTAB.
*     APPEND FAUSWTAB_SOND.
*   ENDIF.
* ENDLOOP.
  LOOP AT FAUSWTAB.
    READ TABLE FTAB_SFGRUP WITH KEY FAUSWTAB-FNAME BINARY SEARCH.
    IF SY-SUBRC EQ 0.
      FAUSWTAB_SOND = FAUSWTAB.
      APPEND FAUSWTAB_SOND.
    ENDIF.
  ENDLOOP.

*-------- Aufrufen FB für Feldauswahl ---------------------------------

* Vereinigung der Sonderfeldauswahl-FB's Industrie + Retail  "BE/100197
* CALL FUNCTION 'MATERIAL_FIELD_SPECIAL_SELECT'              "BE/100197
ENHANCEMENT-SECTION     SONFAUSW_IN_FGRUPPEN_01 SPOTS ES_LMGD1O18 INCLUDE BOUND.
  CALL FUNCTION 'MATERIAL_FIELD_SPECIAL_SEL_NEW'             "BE/100197
       EXPORTING
            KZRFB               = KZRFB
            ALT_STANDARDPR_ALLG = *MARA-SATNR  "ch zu 3.0C
            ALT_STANDARDPRODUKT = *MARC-STDPD
            FLGSTEUER_MUSS      = RMMG2-STEUERMUSS
*           flg_cad_aktiv       = flg_cad_aktiv mk/4.0A in RMMG2 integr.
            MTART_BESKZ         = RMMG2-BESKZ
            IMARA               = MARA "ch zu 3.0C
            IMARC               = MARC
            IMPOP               = MPOP
            MPOP_PRDAT_DB       = *MPOP-PRDAT
            IMYMS               = MYMS
            IMBEW               = MBEW
            IMLGT               = MLGT                 "4.0A  BE/140897
            IRMMG1              = RMMG1
            IRMMG2              = RMMG2
            IRMMZU              = RMMZU
            IT130M              = T130M
            IT134_WMAKG         = T134-WMAKG                 "BE/100197
            IT134_VPRSV         = T134-VPRSV
            IT134_KZVPR         = T134-KZVPR
            IT134_KZPRC         = T134-KZPRC
            IT134_KZKFG         = T134-KZKFG  "ch zu 3.0C
            OMARA_KZKFG         = *MARA-KZKFG  "ch zu 3.0C
            LANGTEXTBILD        = LANGTEXTBILD
            NEUFLAG             = NEUFLAG
            QM_PRUEFDATEN       = MARC-QMATV
            AKTVSTATUS          = AKTVSTATUS
            KZ_KTEXT_ON_DYNP    = KZ_KTEXT_ON_DYNP
            IT133A_PSTAT        = T133A-PSTAT                "BE/100197
            IT133A_RPSTA        = T133A-RPSTA                "BE/240297
            IV_MATFI            = MARA-MATFI "TF 4.6C Materialfixierung
       IMPORTING
            FLGSTEUER_MUSS      = RMMG2-STEUERMUSS
            IMBEW               = MBEW
       TABLES
            FAUSWTAB            = FAUSWTAB_SOND
            PTAB                = PTAB
            STEUERTAB           = STEUERTAB
            STEUMMTAB           = STEUMMTAB.
END-ENHANCEMENT-SECTION.


ENHANCEMENT-POINT LMGD1O18_01 SPOTS ES_LMGD1O18 INCLUDE BOUND.

*-------- Modifizieren Screen über Feldauswahl-Tabelle ----------------
  CLEAR FELDBEZTAB. REFRESH FELDBEZTAB.
  CLEAR FELDBEZTAB2. REFRESH FELDBEZTAB2.                 "note 1611251

  LOOP AT SCREEN.
*   read table fauswtab_sond with key screen-name binary search. mk/4.0A
    READ TABLE FAUSWTAB_SOND WITH KEY FNAME = SCREEN-NAME BINARY SEARCH.
ENHANCEMENT-SECTION     LMGD1O18_03 SPOTS ES_LMGD1O18 INCLUDE BOUND .
    IF SY-SUBRC EQ 0.
*     read table fauswtab with key screen-name binary search. mk/4.0A
      READ TABLE FAUSWTAB WITH KEY FNAME = SCREEN-NAME BINARY SEARCH.
      IF SY-SUBRC EQ 0.
        FAUSWTAB = FAUSWTAB_SOND.
        MODIFY FAUSWTAB INDEX SY-TABIX.
      ENDIF.
      SCREEN-ACTIVE      = FAUSWTAB_SOND-KZACT.
      SCREEN-INPUT       = FAUSWTAB_SOND-KZINP.
      SCREEN-INTENSIFIED = FAUSWTAB_SOND-KZINT.
      SCREEN-INVISIBLE   = FAUSWTAB_SOND-KZINV.
      SCREEN-OUTPUT      = FAUSWTAB_SOND-KZOUT.
      SCREEN-REQUIRED    = FAUSWTAB_SOND-KZREQ.

*     note 1358288: override columns set by TC_VIEW customizing
      IF <F_TC> IS ASSIGNED.
        READ TABLE <F_TC>-COLS INTO TC_COL WITH KEY SCREEN-NAME = SCREEN-NAME.
        IF sy-subrc = 0.
*         If field is set by table control to invisible and it is not
*         required due to material field selection, then hide the field.
*         Otherwise make sure, that the field is not hidden.
          IF TC_COL-INVISIBLE = CX_TRUE AND SCREEN-REQUIRED = 0.
            SCREEN-INVISIBLE = 1.
            SCREEN-ACTIVE    = 1.                          "note 1575018
            SCREEN-OUTPUT    = 1.                          "note 1575018
            SCREEN-INPUT     = 0.
          ELSEIF SCREEN-INVISIBLE = 1.
            SCREEN-ACTIVE    = 1.                          "note 1575018
            SCREEN-OUTPUT    = 1.                          "note 1575018
            TC_COL-INVISIBLE = CX_TRUE.
          ELSE.
            TC_COL-INVISIBLE = CX_FALSE.
          ENDIF.
          TC_COL-SCREEN = SCREEN.
          MODIFY <F_TC>-COLS FROM TC_COL INDEX sy-tabix.
        ENDIF.
      ENDIF.

      MODIFY SCREEN.

*mk/4.0A wieder in FB integriert
*mk/3.0F Butttons Prognose-/Verbrauchswerte ausblenden (keine
*SFGRUP in T130F) beim Planen von Änderungen
*     if screen-name = marc_verb or screen-name = mpop_prgw.
*..............
*     endif.
    ENDIF.
END-ENHANCEMENT-SECTION.
* Festhalten der nicht ausgeblendeten Felder, denen Bezeichnungen
* zugeordnet sind
    IF ( SCREEN-INVISIBLE = 0 OR SCREEN-OUTPUT = 1 ) AND NOT
       SCREEN-GROUP1 IS INITIAL.
      FELDBEZTAB-NAME   = SCREEN-NAME.
      FELDBEZTAB-GROUP1 = SCREEN-GROUP1.
      APPEND FELDBEZTAB.
    ENDIF.
*   note 1611251: extend the logic also for SCREEN-GROUP2
    IF ( SCREEN-INVISIBLE = 0 OR SCREEN-OUTPUT = 1 ) AND NOT
       SCREEN-GROUP2 IS INITIAL.
      FELDBEZTAB2-NAME   = SCREEN-NAME.
      FELDBEZTAB2-GROUP1 = SCREEN-GROUP2.
      APPEND FELDBEZTAB2.
    ENDIF.

  ENDLOOP.

ENHANCEMENT-POINT LMGD1O18_02 SPOTS ES_LMGD1O18 INCLUDE BOUND.
  SORT FELDBEZTAB.
  SORT FELDBEZTAB2.                                       "note 1611251

  IF T130M-AKTYP EQ AKTYPH AND NOT RMMG1_REF-MATNR IS INITIAL.
*  Prüfen, ob Feld ein für das Vorlagematerial relevantes Währungsfeld
*  ist. In diesem Fall wird das  KZCURR in der Fauswtab gesetzt
    CALL FUNCTION 'MATERIAL_CURRFIELD_REF'
         TABLES
              RPTAB    = RPTAB
              FAUSWTAB = FAUSWTAB.
  ENDIF.

ENDMODULE.
