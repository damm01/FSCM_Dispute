*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 05.08.2019 at 16:26:43
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFIFSCM_REASON.................................*
TABLES: ZVFIFSCM_REASON, *ZVFIFSCM_REASON. "view work areas
CONTROLS: TCTRL_ZVFIFSCM_REASON
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFIFSCM_REASON. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFIFSCM_REASON.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFIFSCM_REASON_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_REASON.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_REASON_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFIFSCM_REASON_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_REASON.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_REASON_TOTAL.

*.........table declarations:.................................*
TABLES: SCMGATTR_REASON                .
TABLES: SCMGATTR_REASONT               .
