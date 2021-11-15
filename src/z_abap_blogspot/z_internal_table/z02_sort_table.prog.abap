*&---------------------------------------------------------------------*
*& Report Z02_SORT_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_sort_table.

*Declaring the local structure of internal table
TYPES: BEGIN OF ty_tab,
         item     TYPE char10,
         quantity TYPE i,
         price    TYPE i,
       END OF ty_tab.

*Declaring the Sorted internal table with unique key
DATA: itab1 TYPE SORTED TABLE OF ty_tab WITH UNIQUE KEY item,
      wtab1 TYPE ty_tab.

*Declaring the Sorted internal table with non unique key
DATA: itab2 TYPE SORTED TABLE OF ty_tab WITH NON-UNIQUE KEY item,
      wtab2 TYPE ty_tab.

PERFORM fill_first_table.
PERFORM fill_second_table.

PERFORM print_first_table.
PERFORM print_second_table.

*&---------------------------------------------------------------------*
*&      Form  FILL_FIRST_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_first_table.

*Entering records to each FIELD
  wtab1-item = 'Rice'.     wtab1-quantity = 2. wtab1-price = 80.

*Now one single row has been fulfilled with data
*Next inserting one single row data into the table
  INSERT wtab1 INTO TABLE itab1.

  wtab1-item = 'Suger'.    wtab1-quantity = 1. wtab1-price = 90.
  INSERT wtab1 INTO TABLE itab1.

  wtab1-item = 'Tea'.      wtab1-quantity = 1. wtab1-price = 100.
  INSERT wtab1 INTO TABLE itab1.

  wtab1-item = 'Rice'.     wtab1-quantity = 3. wtab1-price = 150.
  INSERT wtab1 INTO TABLE itab1.

  wtab1-item = 'Horlicks'. wtab1-quantity = 1. wtab1-price = 200.
  INSERT wtab1 INTO TABLE itab1.

  wtab1-item = 'Suger'.    wtab1-quantity = 2. wtab1-price = 70.
  INSERT wtab1 INTO TABLE itab1.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FILL_SECOND_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_second_table.

*Entering records to each field
  wtab2-item = 'Rice'.     wtab2-quantity = 2. wtab2-price = 80.

*Now one single row has been fulfilled with data
*Next inserting one single row data into the table
  INSERT wtab2 INTO TABLE itab2.

  wtab2-item = 'Suger'.    wtab2-quantity = 1. wtab2-price = 90.
  INSERT wtab2 INTO TABLE itab2.

  wtab2-item = 'Tea'.      wtab2-quantity = 1. wtab2-price = 100.
  INSERT wtab2 INTO TABLE itab2.

  wtab2-item = 'Rice'.     wtab2-quantity = 3. wtab2-price = 150.
  INSERT wtab2 INTO TABLE itab2.

  wtab2-item = 'Horlicks'. wtab2-quantity = 1. wtab2-price = 200.
  INSERT wtab2 INTO TABLE itab2.

  wtab2-item = 'Suger'.    wtab2-quantity = 2. wtab2-price = 70.
  INSERT wtab2 INTO TABLE itab2.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PRINT_FIRST_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_first_table.

  WRITE:/3 'Item',
        13 'Quantity (KG)',
        28 'Price (Rs)'.
  WRITE / '=========================================='.
  SKIP. "Skipping one single line

  LOOP AT itab1 INTO wtab1.

    WRITE:  /3 wtab1-item,
            12 wtab1-quantity,
            25 wtab1-price.
  ENDLOOP.

  SKIP.
  WRITE '=========================================='.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PRINT_SECOND_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_second_table.

  WRITE:/3 'Item',
        13 'Quantity (KG)',
        28 'Price (Rs)'.
  WRITE / '=========================================='.
  SKIP. "Skipping one single line

  LOOP AT itab2 INTO wtab2.

    WRITE:  /3 wtab2-item,
            12 wtab2-quantity,
            25 wtab2-price.
  ENDLOOP.

  SKIP.
  WRITE '=========================================='.

ENDFORM.
