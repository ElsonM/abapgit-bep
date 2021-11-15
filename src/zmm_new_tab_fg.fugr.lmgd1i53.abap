*------------------------------------------------------------------
*  Module MVKE-VMSTD.
*  Pruefung des Gültigkeitsdatums zum Vertriebsstatus
*------------------------------------------------------------------
MODULE MVKE-VMSTD.

  CHECK BILDFLAG = SPACE.
  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.

  CALL FUNCTION 'MVKE_VMSTD'
       EXPORTING
            LMVKE_VMSTA = LMVKE-VMSTA           "ch zu 4.0C
            LMVKE_VMSTD = LMVKE-VMSTD           "ch zu 4.0C
            WMVKE_VMSTA = MVKE-VMSTA
            WMVKE_VMSTD = MVKE-VMSTD.

ENDMODULE.
