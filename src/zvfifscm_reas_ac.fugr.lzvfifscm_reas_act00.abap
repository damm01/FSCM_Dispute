*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 28.08.2019 at 16:53:43
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFIFSCM_REAS_AC................................*
TABLES: ZVFIFSCM_REAS_AC, *ZVFIFSCM_REAS_AC. "view work areas
CONTROLS: TCTRL_ZVFIFSCM_REAS_AC
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFIFSCM_REAS_AC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFIFSCM_REAS_AC.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFIFSCM_REAS_AC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_REAS_AC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_REAS_AC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFIFSCM_REAS_AC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_REAS_AC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_REAS_AC_TOTAL.

*.........table declarations:.................................*
TABLES: SCMGATTR_REASON                .
TABLES: SCMGATTR_REASONT               .
TABLES: ZFIFSCM_ACTION                 .
TABLES: ZFIFSCM_ACTIONT                .
TABLES: ZFIFSCM_REAS_ACT               .
