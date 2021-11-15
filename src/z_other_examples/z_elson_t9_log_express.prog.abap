*&---------------------------------------------------------------------*
*& Report Z_ELSON_T9_LOG_EXPRESS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t9_log_express.

PARAMETERS p_number TYPE i.
PARAMETERS p_string TYPE string.

CONSTANTS c_10 TYPE i VALUE 10.
CONSTANTS c_abc TYPE string VALUE 'ABCDEF'.

NEW-LINE.
WRITE: 'Sample number:', c_10.
NEW-LINE.
WRITE: 'Sample String:', c_abc.

*IF p_number eq c_10.
*  NEW-LINE.
*  WRITE: p_number, 'equal to', c_10.
*ENDIF.
*
*IF p_number ne c_10.
*  NEW-LINE.
*  WRITE: p_number, 'not equal to', c_10.
*ENDIF.
*
*IF p_number gt c_10.
*  NEW-LINE.
*  WRITE: p_number, 'greater than', c_10.
*ENDIF.
*
*IF p_number lt c_10.
*  NEW-LINE.
*  WRITE: p_number, 'less than', c_10.
*ENDIF.
*
*IF p_number ge c_10.
*  NEW-LINE.
*  WRITE: p_number, 'greater than or equal to', c_10.
*ENDIF.
*
*IF p_number le c_10.
*  NEW-LINE.
*  WRITE: p_number, 'less than or equal to', c_10.
*ENDIF.

IF p_string CO c_abc. "Contains Only
  NEW-LINE.
  WRITE: p_string, 'Contains only characters form the string:',
    c_abc.
ENDIF.

IF p_string CN c_abc. "Contains Not Only
  NEW-LINE.
  WRITE: p_string, 'Contains -not only- characters form the string:',
    c_abc.
ENDIF.

IF p_string CA c_abc. "Contains Any
  NEW-LINE.
  WRITE: p_string, 'Contains at least one characters form the string:',
    c_abc.
ENDIF.

IF p_string NA c_abc. "Contains Not Any
  NEW-LINE.
  WRITE: p_string, 'Contains no characters form the string:',
    c_abc.
ENDIF.

IF p_string CS c_abc. "Contains String
  NEW-LINE.
  WRITE: p_string, 'Contains the character string:',
    c_abc.
ENDIF.

IF p_string NS c_abc. "Contains No String
  NEW-LINE.
  WRITE: p_string, 'does not contain:',
    c_abc.
ENDIF.

IF p_string CP c_abc. "Contains Pattern
  NEW-LINE.
  WRITE: 'The complete string', p_string, 'matches the pattern', c_abc.
ENDIF.

IF p_string NP c_abc. "Contains No Pattern
  NEW-LINE.
  WRITE: p_string, 'does not match', c_abc.
ENDIF.
