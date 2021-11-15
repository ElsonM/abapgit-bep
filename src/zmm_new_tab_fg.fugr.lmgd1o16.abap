*&---------------------------------------------------------------------*
*&      Module  ZUSREF_VORSCHLAGEN_A  OUTPUT
*&---------------------------------------------------------------------*
*       Vorlagenhandling NACH dem Modul REFDATEN_VORSCHLAGEN           *
*       War ursprünglich in allen PBO Modulen verteilt und wird        *
*       hier zusammengefaßt.
*----------------------------------------------------------------------*
MODULE ZUSREF_VORSCHLAGEN_A OUTPUT.

* note 482447
  DATA reference_herkunft like t130f-kzref.
  CLEAR reference_herkunft.

  CHECK T130M-AKTYP EQ AKTYPH.
  CALL FUNCTION 'USRM1_SINGLE_READ'
       EXPORTING
           UNAME  = SY-UNAME
           BILDS  = BILDSEQUENZ
       IMPORTING
           WUSRM1 = USRM1_H.

* CHECK BILDFLAG IS INITIAL.               "cfo/3.1I
  CHECK NOT ( T133A-PSTAT CO 'C ' AND USRM1_H-SISEL IS INITIAL ).


*--- Pruefen, ob Bild bereits prozessiert wurde ----------------
* CHECK BILDTAB-KZPRO IS INITIAL.        "cfo/3.1I

*--- Aufrufe der Vorlagehandling - FB's AFTER ------------------
  PERFORM ZUSREF_VORSCHLAGEN_AFTER_D using reference_herkunft.

  perform ref_user_exit_d.              "cfo/4.6C

*mk/21.07.95  - mk/24.08.95 am Ende des Vorlagehandlings
*Aufruf des Vorlagehandlings aus den übergeordneten Daten desselben
*Materials
  CALL FUNCTION 'MATERIAL_REFERENCE_ITSELF'
       EXPORTING
            FLG_UEBERNAHME  = FLG_UEBERNAHME
            FLG_PRUEFDUNKEL = FLG_PRUEFDUNKEL
            AKTVSTATUS      = AKTVSTATUS
            WMBEW           = MBEW
            MARC_LOSGR      = MARC-LOSGR
            MVKE_PRODH      = MVKE-PRODH
            MARA_PRDHA      = MARA-PRDHA
            MARC_DISMM      = MARC-DISMM  "mk/19.12.95
            MARC_SBDKZ      = MARC-SBDKZ  "mk/19.12.95
            WRMMG1          = RMMG1    "mk/19.12.95
       IMPORTING
            WMBEW           = MBEW
            MARC_LOSGR      = MARC-LOSGR
            MVKE_PRODH      = MVKE-PRODH
            MARC_SBDKZ      = MARC-SBDKZ  "mk/19.12.95
       TABLES
            FAUSWTAB        = FAUSWTAB
            MPTAB           = PTAB.


ENDMODULE.                             " ZUSREF_VORSCHLAGEN_A  OUTPUT
