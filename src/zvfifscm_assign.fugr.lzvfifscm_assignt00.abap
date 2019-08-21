*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 07.08.2019 at 14:18:28
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFIFSCM_ASSIGN.................................*
TABLES: ZVFIFSCM_ASSIGN, *ZVFIFSCM_ASSIGN. "view work areas
CONTROLS: TCTRL_ZVFIFSCM_ASSIGN
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFIFSCM_ASSIGN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFIFSCM_ASSIGN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFIFSCM_ASSIGN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_ASSIGN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_ASSIGN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFIFSCM_ASSIGN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_ASSIGN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_ASSIGN_TOTAL.

*.........table declarations:.................................*
TABLES: ZFIFSCM_ACTION                 .
TABLES: ZFIFSCM_ACTIONT                .
TABLES: ZFIFSCM_ASSIGN                 .
