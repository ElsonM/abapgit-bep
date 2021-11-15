*------------------------------------------------------------------
*  Module MBEW-BWTTY
*
*  Der Bewertungstyp ist nur eingebbar für den Fall, daß die
*  Bewertungsart ungefüllt ist. Die Eingabe wird über Fremdschlüssel-
*  Beziehung verprobt.
*
*- Anlage eines Bewertungskopfsatzes mit Bewertungstyp
*  - vorhandene MARC-Sätze zum Bewertungskreis sind zu aktualisieren
*    hinsichtlich des Kz. Chargenführung sowie des Bewertungstyps
*    (im Verbucher, dabei wird auch ein evtl. parallel angelegter
*    MARC-Satz berücksichtigt)
*    Dazu wird die MARC exklusiv und generisch zum Material gesperrt
*    Im Falle von Chargeneinzelbewertung wird die Chargenpflicht für
*    -  bereits vorhandene Werke zugehörige Werke geprüft. Es muß
*       für alle diese Werke Chargenpflicht vereinbart sein, sonst
*       ist der Bewertungstyp nicht erlaubt
*    -  ein parallel anzulegendes/angelegtes Werk hart gesetzt
*       (im Modul Sonfausw_in_fgruppen, falls Bild mit Chargenpflicht
*       prozessiert wird, ansonsten im Okcode_buchen).
*- Ändern des Bewertungstyps
*  Beim Ändern des Bewertungstyps wird geprüft, ob diese Änderung
*  erlaubt ist. Sobald dafür mehrere Werke gelesen werden müssen,
*  wird die MARC exclusiv und generisch zum Material gesperrt:
*  1. Wechsel von einheitlicher Bewertung auf getrennte Bewertung:
*     - bewerteter Bestand darf nicht vorhanden sein und es darf
*       keine Inventur aktiv sein
*     - Chargen dürfen nicht vorhanden sein (Bewertungsart fehlt)
*       ---> Reservierungen ok, Sonderbestände ok
*     - Bestellungen dürfen nicht vorhanden sein, da BWTTY
*       aus Bestellung an Bestandsführung übergeben wird und beim
*       Ändern der Bewertungsart verwendet werden
*  2. Wechsel von getrennter Bewertung auf einheitliche Bewertung:
*     - bewerteter Bestand darf nicht vorhanden sein
*     - Einzelbewertungssätze dürfen nicht vorhanden sein
*       ---> keine Chargen vorhanden --> keine Inventur aktiv
*     - Bestellungen dürfen nicht vorhanden sein (siehe Punkt 1)
*  3. Wechsel des Typs der getrennten Bewertung
*     - die vorhandenen Bewertungseinzelsätze müssen zum neuen
*       Bewertungstyp passen (nur kritisch, wenn für den neuen
*       Bewertungstyp keine automatische Anlage der Einzelsätze
*       vorgesehen ist) ---> Chargen ok, Bestand ok, Inventur ok
*     - Bestellungen dürfen nicht vorhanden sein (siehe Punkt 1)
*       Ist dies der Fall, so wird ein Kennzeichen zur Anpassung der
*       Bewertungstypen der Einzelsätze im Verbucher gesetzt
*  4. Zusatzprüfung, falls der neue Bewertungstyp Chargeneinzelbe-
*     wertung vereinbart:
*     Prüfen aller zugehörigen Werke zum Bewertungstyp auf Chargen-
*     pflicht
*  - aktualisieren der MARC-Sätze zum Bewertungskreis hinsichtlich
*    des Kz. Chargenführung im Verbucher, falls der Bewertungstyp von
*    space auf ungleich space bzw. umgedreht geändert wird
*    zusätzlich immer hinsichtlich des Bewertungstyps
*
*  Lesen der T149 zum neuen Bewertungstyp, falls er nicht initial ist.
*------------------------------------------------------------------
MODULE MBEW-BWTTY.

ENHANCEMENT-POINT EHP604_LMGD1I3R_01 SPOTS ES_LMGD1I3R INCLUDE BOUND .

  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.
  CHECK BILDFLAG IS INITIAL.             "mk/21.04.95

  CALL FUNCTION 'MBEW_BWTTY'
       EXPORTING
            WMBEW_BWTTY       = MBEW-BWTTY
            WMBEW_BWKEY       = MBEW-BWKEY
            WMBEW_BWTAR       = MBEW-BWTAR
            WMBEW_SALK3       = MBEW-SALK3
            WMBEW_LBKUM       = MBEW-LBKUM
            WMBEW_MLMAA       = MBEW-MLMAA
            WMBEW_KALN1       = MBEW-KALN1
            OMBEW_BWTTY       = *MBEW-BWTTY
            WRMMG1_WERKS      = RMMG1-WERKS
            WMARC_SERNP       = MARC-SERNP
            WMARC_XCHPF       = MARC-XCHPF                   "BE/241096
            WMARA_XCHPF       = MARA-XCHPF
            WMARA_MTART       = MARA-MTART             "ch zu 4.0
            WRMMG1_MATNR      = RMMG1-MATNR
* (del)     FLGBWTTY          = RMMG2-FLGBWTTY               "BE/081196
* (del)     FLGXCHAR_BEW      = RMMG2-XCHAR_BEW              "BE/081196
* (del)     FLGXCHPF_HART     = RMMG2-XCHPF_HART             "BE/301096
            NEUFLAG           = NEUFLAG
            P_AKTYP           = T130M-AKTYP
            CHARGEN_EBENE     = RMMG2-CHARGEBENE
            FLG_RETAIL        = RMMG2-FLG_RETAIL       "ch zu 4.0C
       IMPORTING
            WMBEW_BWTTY       = MBEW-BWTTY
            WMARC_XCHPF       = MARC-XCHPF                   "BE/241096
            WMARA_XCHPF       = MARA-XCHPF             "ch zu 3.0C
* (del)     FLGBWTTY          = RMMG2-FLGBWTTY               "BE/081196
* (del)     FLGXCHAR_BEW      = RMMG2-XCHAR_BEW              "BE/081196
* (del)     FLGXCHPF_HART     = RMMG2-XCHPF_HART             "BE/301096
       TABLES
            P_PTAB            = PTAB
       EXCEPTIONS
            ERROR_BWTTY       = 01
            SET_ERROR_BWTTY   = 02.

  CASE SY-SUBRC.
    WHEN '1'.
*---- Bewertungstyp nicht änderbar ---------------------------------
      MOVE *MBEW-BWTTY TO MBEW-BWTTY.
      RMMZU-FLG_FLISTE = X.
      RMMZU-ERR_BWTTY  = X.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      BILDFLAG = X.
    WHEN '2'.
*---- Bewertungstyp nicht änderbar ---------------------------------
      MOVE *MBEW-BWTTY TO MBEW-BWTTY.
      RMMZU-FLG_FLISTE = X.
      RMMZU-ERR_BWTTY  = X.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      BILDFLAG = X.
  ENDCASE.

ENDMODULE.
