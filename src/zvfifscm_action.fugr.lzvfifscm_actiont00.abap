*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 28.08.2019 at 17:31:45
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFIFSCM_ACTION.................................*
TABLES: ZVFIFSCM_ACTION, *ZVFIFSCM_ACTION. "view work areas
CONTROLS: TCTRL_ZVFIFSCM_ACTION
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFIFSCM_ACTION. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFIFSCM_ACTION.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFIFSCM_ACTION_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_ACTION.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_ACTION_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFIFSCM_ACTION_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_ACTION.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_ACTION_TOTAL.

*.........table declarations:.................................*
TABLES: ZFIFSCM_ACTION                 .
TABLES: ZFIFSCM_ACTIONT                .
