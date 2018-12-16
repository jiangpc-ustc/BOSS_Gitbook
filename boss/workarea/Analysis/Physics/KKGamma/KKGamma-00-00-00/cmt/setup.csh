# echo "setup KKGamma KKGamma-00-00-00 in /besfs/users/deboer/BOSS_Afterburner/boss/workarea/Analysis/Physics"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /afs/ihep.ac.cn/bes3/offline/ExternalLib/SLC6/contrib/CMT/v1r25
endif
source ${CMTROOT}/mgr/setup.csh
set cmtKKGammatempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if $status != 0 then
  set cmtKKGammatempfile=/tmp/cmt.$$
endif
${CMTROOT}/mgr/cmt setup -csh -pack=KKGamma -version=KKGamma-00-00-00 -path=/besfs/users/deboer/BOSS_Afterburner/boss/workarea/Analysis/Physics  -no_cleanup $* >${cmtKKGammatempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/mgr/cmt setup -csh -pack=KKGamma -version=KKGamma-00-00-00 -path=/besfs/users/deboer/BOSS_Afterburner/boss/workarea/Analysis/Physics  -no_cleanup $* >${cmtKKGammatempfile}"
  set cmtsetupstatus=2
  /bin/rm -f ${cmtKKGammatempfile}
  unset cmtKKGammatempfile
  exit $cmtsetupstatus
endif
set cmtsetupstatus=0
source ${cmtKKGammatempfile}
if ( $status != 0 ) then
  set cmtsetupstatus=2
endif
/bin/rm -f ${cmtKKGammatempfile}
unset cmtKKGammatempfile
exit $cmtsetupstatus
