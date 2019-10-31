*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 19.09.2019 at 17:44:28
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFSCM_DM_CAT_RE................................*
TABLES: ZVFSCM_DM_CAT_RE, *ZVFSCM_DM_CAT_RE. "view work areas
CONTROLS: TCTRL_ZVFSCM_DM_CAT_RE
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFSCM_DM_CAT_RE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFSCM_DM_CAT_RE.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFSCM_DM_CAT_RE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFSCM_DM_CAT_RE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFSCM_DM_CAT_RE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFSCM_DM_CAT_RE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFSCM_DM_CAT_RE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFSCM_DM_CAT_RE_TOTAL.

*.........table declarations:.................................*
TABLES: SCMGATTR_CATEGO                .
TABLES: SCMGATTR_CATEGOT               .
TABLES: SCMGATTR_REASON                .
TABLES: SCMGATTR_REASONT               .
TABLES: ZFSCM_DM_CAT_REA               .
