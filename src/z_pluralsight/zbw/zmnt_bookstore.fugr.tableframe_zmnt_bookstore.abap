*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZMNT_BOOKSTORE
*   generation date: 22.08.2017 at 15:14:12
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZMNT_BOOKSTORE     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
