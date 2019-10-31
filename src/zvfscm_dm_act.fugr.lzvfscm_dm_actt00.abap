*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 24.09.2019 at 10:13:15
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFSCM_DM_ACT...................................*
TABLES: ZVFSCM_DM_ACT, *ZVFSCM_DM_ACT. "view work areas
CONTROLS: TCTRL_ZVFSCM_DM_ACT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFSCM_DM_ACT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFSCM_DM_ACT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFSCM_DM_ACT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFSCM_DM_ACT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFSCM_DM_ACT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFSCM_DM_ACT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFSCM_DM_ACT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFSCM_DM_ACT_TOTAL.

*.........table declarations:.................................*
TABLES: ZFSCM_DM_ACT                   .
TABLES: ZFSCM_DM_ACTT                  .
