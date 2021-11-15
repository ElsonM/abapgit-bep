*&---------------------------------------------------------------------*
*& Report Z01_STAND_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_stand_table.

*Declaring the local structure of internal table
TYPES: BEGIN OF ty_tab,
        item     TYPE char10,
        quantity TYPE i,
        price    TYPE i,
      END OF ty_tab.

*Declaring the Standard internal table with non unique key
DATA: itab TYPE STANDARD TABLE OF ty_tab WITH NON-UNIQUE KEY item,
      wtab TYPE ty_tab.

*Entering records to each field
wtab-item = 'Rice'.     wtab-quantity = 2. wtab-price = 80.

*Now one single row has been fulfilled with data
*Next appending one single row data into the table
APPEND wtab TO itab.

wtab-item = 'Sugar'.    wtab-quantity = 1. wtab-price = 90.
APPEND wtab TO itab.

wtab-item = 'Tea'.      wtab-quantity = 1. wtab-price = 100.
APPEND wtab TO itab.

wtab-item = 'Rice'.     wtab-quantity = 3. wtab-price = 150.
APPEND wtab TO itab.

wtab-item = 'Horlicks'. wtab-quantity = 1. wtab-price = 200.
APPEND wtab TO itab.

wtab-item = 'Sugar'.    wtab-quantity = 2. wtab-price = 70.
APPEND wtab TO itab.

WRITE:  /3 'Item',
        17 'Quantity',
        32 'Price'.
WRITE / '=========================================='.
SKIP. "Skipping one single line

LOOP AT itab INTO wtab.

  WRITE:  /3 wtab-item,
          12 wtab-quantity,
          25 wtab-price.

ENDLOOP.

SKIP.
WRITE '=========================================='.
