*&---------------------------------------------------------------------*
*&      Form  AUSME_GEAENDERT
*&---------------------------------------------------------------------*
*       Prüfen, ob LieferME geändert wurde. Wenn kein Fehler vorliegt, *
*       LieferME nach MAW1 übernehmen.                                 *
*       Achtung: Prüfung wird nur durchgeführt, wenn MAW1 gepflegt ist *
*       (Retail).                                                      *
*----------------------------------------------------------------------*
FORM AUSME_GEAENDERT.

  CHECK ME_FEHLERFLG IS INITIAL AND NOT MAW1-MATNR IS INITIAL.

  IF ME_AUSME IS INITIAL.
*   BasisME wird als AusgabeME interpretiert.
    READ TABLE MEINH WITH KEY ME_BME.
    IF SY-SUBRC = 0.
      MEINH-KZAUSME = X.
      MODIFY MEINH INDEX SY-TABIX.
    ENDIF.
  ELSEIF ME_AUSME NE MAW1-WAUSM AND ME_AUSME = MARA-MEINS.
    CLEAR ME_AUSME.
  ENDIF.

  IF ( ME_AUSME NE MAW1-WAUSM AND
       NOT ( MAW1-WAUSM IS INITIAL AND ME_AUSME = MARA-MEINS ) ).
*   LieferME wurde geändert.
    IF BILDFLAG IS INITIAL.    "cfo/10.8.96 falls BasisME geändert
*    Prüfungen durchführen, wenn Bildflag nicht gesetzt.
      CALL FUNCTION 'MAW1_WAUSM'
           EXPORTING
                WMARA_MATNR      = MARA-MATNR
                WMARA_ATTYP      = MARA-ATTYP
                WMAW1_WAUSM      = ME_AUSME
                WMARA_MEINS      = MARA-MEINS
                WMARA_SATNR      = MARA-SATNR                "BE/030696
                WRMMG1_REF_MATNR = RMMG1_REF-MATNR
*               WRMMZU           =
                LMAW1_WAUSM      = LMAW1-WAUSM
                OMAW1_WAUSM      = *MAW1-WAUSM
                AKTYP            = T130M-AKTYP
                NEUFLAG          = NEUFLAG
                OK_CODE          = RMMZU-OKCODE
*               FLG_UEBERNAHME   = ' '
                P_MESSAGE        = ' '
           IMPORTING
                WMAW1_WAUSM      = ME_AUSME
*               WRMMZU           =
                FLAG_BILDFOLGE   = RMMZU-BILDFOLGE
*               HOKCODE          = RMMZU-OKCODE   mk/15.08.96 vertauscht
*               OK_CODE          = RMMZU-HOKCODE  ""
                HOKCODE          = RMMZU-HOKCODE  ""
                OK_CODE          = RMMZU-OKCODE   ""
           TABLES
                MEINH            = MEINH
                Z_MEINH          = RMEINH
                DMEINH           = DMEINH
           EXCEPTIONS
                ERROR_NACHRICHT  = 1
                ERROR_MEINS      = 2
                OTHERS           = 3.
      IF SY-SUBRC NE 0.
        ME_FEHLERFLG = KZMEINH.
        SAVMEINH = ME_AUSME.
        MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.

*   Daten der LieferME nach MAW1 übernehmen.
    IF ME_FEHLERFLG IS INITIAL.
      CALL FUNCTION 'DATENUEBERNAHME_AUSME'
           EXPORTING
                WMAW1   = MAW1
                P_AUSME = ME_AUSME
           IMPORTING
                WMAW1   = MAW1
           TABLES
                PTAB    = PTAB.
*              EXCEPTIONS
*                   OTHERS   = 1.
    ELSE.
*---- Liefer-ME nicht änderbar --------------------------------------
*---- Kennzeichen in MEINH zurücksetzen. cfo/6.9.96
      READ TABLE MEINH WITH KEY MAW1-WAUSM.
      IF SY-SUBRC = 0.
        MEINH-KZAUSME = X.
        MODIFY MEINH INDEX SY-TABIX.
      ENDIF.
* cfo/6.9.96 Loop statt read, damit bei Doppeleintrag auch wirklich
* gelöscht wird.
*     Liefermengeneinheit wieder zurücksetzen. cfo/11.10.96
      IF ME_AUSME IS INITIAL.
        ME_AUSME = MARA-MEINS.
      ENDIF.
      LOOP AT MEINH WHERE MEINH = ME_AUSME.
        CLEAR MEINH-KZAUSME.
        MODIFY MEINH.
      ENDLOOP.
      ME_AUSME = MAW1-WAUSM.
    ENDIF.

*   Liefermengeneinheit wieder zurücksetzen.
    IF ME_AUSME IS INITIAL.
      ME_AUSME = MARA-MEINS.
    ENDIF.

  ENDIF.                               "IF ME_AUSME ...

ENDFORM.                               " AUSME_GEAENDERT
