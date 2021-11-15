*&---------------------------------------------------------------------*
*& Report Z_LOGICAL_DATABASE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_logical_database.

NODES: kna1, vbak.

GET kna1.
  WRITE:/ kna1-kunnr,
          kna1-land1,
          kna1-name1.
  SKIP 2.

GET kna1 LATE.
  WRITE:/ 'Test'.

GET vbak.
  WRITE:/ vbak-vbeln,
          vbak-erdat,
          vbak-ernam.
