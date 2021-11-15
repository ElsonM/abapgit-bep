*&---------------------------------------------------------------------*
*& Report Z03_SHIFT_NEGATIVE_SIGN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_shift_negative_sign.

DATA: gv_amount          TYPE konp-kbetr,
      gv_amount_text(15) TYPE c.

gv_amount = 100.
WRITE:/ 'Positive Value: ', gv_amount.

gv_amount = gv_amount * -1.
WRITE:/ 'Negative Value: ', gv_amount.

gv_amount_text = gv_amount.

CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
  CHANGING
    value = gv_amount_text.

WRITE:/ 'After Shifting: ', gv_amount_text RIGHT-JUSTIFIED.
