*&---------------------------------------------------------------------*
*& Report Z_LDB_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_ldb_02.

NODES: spfli, sflight, sbook.
DATA weight type i value 0.

GET spfli.
  SKIP.
  WRITE:/ 'Carrid:', spfli-carrid,
          'Connid:', spfli-connid,
        / 'From:',   spfli-cityfrom,
          'To:',     spfli-cityto.
  ULINE.

GET sflight.
  SKIP.
  WRITE: /'Date:', sflight-fldate.

GET sbook.
  weight = weight + sbook-luggweight.

GET sflight LATE.
  WRITE: /'Total luggage weight =', weight.
  ULINE.
  CLEAR weight.
