*------------------------------------------------------------------
*  Module MARC-XCHPF.
*
*  Beim Ändern des Kennzeichens Chargenpflicht wird geprüft, ob
*  diese Änderung erlaubt ist.
*  - die vorhandenen Objekte zum Material werden überprüft. Dies
*    geschieht auch bei der Erweiterung eines Werkes, da bei kundenspez.
*    Änderung des Pflegestatus des Feldes Chargenpflicht ein Werk
*    ohne Pflege der Chargenpflicht angelegt werden könnte.
*    ab 2.0 auch Prüfung bzgl. Kundenkonsi- und Kundenleergutbestände
*    ab 2.1 auch Prüfung bzgl. Lieferantenbeistellungs- und Kunden-
*       auftragsbestand
*  - Chargeneinzelbewertung darf bei Rücknahme der Chargenpflicht nicht
*    vereinbart sein (Für MBEW-BWTTY sitzt Kz. Bewertungsart automat.)
*    (auch bei Neuanlage zu überprüfen, da Buchhaltungsdaten zuerst
*    gepflegt werden können)
*  Nach erfolgreicher Änderung wird das Rettfeld RET_XCHPF aktualisiert.
*------------------------------------------------------------------
MODULE marc-xchpf.
  CHECK t130m-aktyp NE aktypa AND t130m-aktyp NE aktypz.
  CHECK bildflag IS INITIAL.           "mk/21.04.95

  IF rmmg2-chargebene = chargen_ebene_0.    "ch zu 3.0C
    hxchpf = lmarc-xchpf.              "-> IPr. 366/1996
  ELSE.
    hxchpf = lmara-xchpf.
  ENDIF.

ENHANCEMENT-SECTION     LMGD1I1V_01 SPOTS ES_LMGD1I1V INCLUDE BOUND.
  CALL FUNCTION 'MARC_XCHPF'
       EXPORTING
            neuflag           = neuflag
            chargen_ebene     = rmmg2-chargebene
            mara_in_matnr     = rmmg1-matnr
            wmarc_xchpf       = marc-xchpf
            wmara_xchpf       = mara-xchpf
            ret_xchpf         = hxchpf
            marc_in_werks     = rmmg1-werks
            wrmmg1_bwkey      = rmmg1-bwkey
            wmarc_sernp       = marc-sernp
            wmara_mtart       = mara-mtart  "ch zu 4.0
            wmara_kzwsm       = mara-kzwsm  "ch zu 4.0
            wmara_vpsta       = mara-vpsta  "ch zu 4.5b
            p_kz_no_warn      = space  "ch zu 3.0F
           sperrmodus        = sperrmodus                   "fbo/171298
      IMPORTING
           wmarc_xchpf       = marc-xchpf
           wmara_xchpf       = mara-xchpf
      EXCEPTIONS
           error_nachricht   = 01
           error_call_screen = 02.
END-ENHANCEMENT-SECTION.

  IF sy-subrc NE 0.                    "Zurücksetzen der Chargenebene
    IF rmmg2-chargebene NE chargen_ebene_a.
      IF mara-xchpf = space.
        mara-xchpf = x.
      ELSE.
        mara-xchpf = space.
      ENDIF.
      marc-xchpf = mara-xchpf.
    ELSE.
      IF marc-xchpf = space.
        marc-xchpf = x.
      ELSE.
        marc-xchpf = space.
      ENDIF.
    ENDIF.
  ENDIF.

ENHANCEMENT-POINT LMGD1I1V_02 SPOTS ES_LMGD1I1V INCLUDE BOUND.

  CASE sy-subrc.
    WHEN '1'.
*---- Chargenpflicht nicht änderbar --------------------------------
      MOVE lmarc-xchpf TO marc-xchpf.
      rmmzu-flg_fliste = x.
      rmmzu-err_chpf   = x.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      bildflag = x.
    WHEN '2'.
*---- Chargenpflicht nicht änderbar --------------------------------
      MOVE lmarc-xchpf TO marc-xchpf.
      rmmzu-flg_fliste = x.
      rmmzu-err_chpf   = x.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      bildflag = x.
  ENDCASE.
ENDMODULE.
