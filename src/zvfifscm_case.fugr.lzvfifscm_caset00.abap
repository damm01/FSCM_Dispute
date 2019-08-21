*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 05.08.2019 at 16:23:14
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVFIFSCM_CASE...................................*
TABLES: ZVFIFSCM_CASE, *ZVFIFSCM_CASE. "view work areas
CONTROLS: TCTRL_ZVFIFSCM_CASE
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVFIFSCM_CASE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVFIFSCM_CASE.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVFIFSCM_CASE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_CASE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_CASE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVFIFSCM_CASE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVFIFSCM_CASE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVFIFSCM_CASE_TOTAL.

*.........table declarations:.................................*
TABLES: SCMGCASETYPE                   .
TABLES: SCMGCASETYPET                  .
