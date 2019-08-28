*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 28.08.2019 at 16:21:18
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFIFSCM_CAT_REA................................*
TABLES: ZVFIFSCM_CAT_REA, *ZVFIFSCM_CAT_REA. "view work areas
CONTROLS: TCTRL_ZVFIFSCM_CAT_REA
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFIFSCM_CAT_REA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFIFSCM_CAT_REA.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFIFSCM_CAT_REA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_CAT_REA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_CAT_REA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFIFSCM_CAT_REA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_CAT_REA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_CAT_REA_TOTAL.

*.........table declarations:.................................*
TABLES: SCMGATTR_CATEGO                .
TABLES: SCMGATTR_CATEGOT               .
TABLES: SCMGATTR_REASON                .
TABLES: SCMGATTR_REASONT               .
TABLES: ZFIFSCM_CAT_REAS               .
