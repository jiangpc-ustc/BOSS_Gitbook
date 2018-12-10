# * Some folder paths * #
BESFS="/besfs/users/${USER}"
IHEPBATCH="/ihepbatch/bes/${USER}"
BOSS_Afterburner="${BESFS}/BOSS_Afterburner"

# * Setup BOSS area * #
BOSSVERSION="7.0.4"
BOSSWORKAREA="${BOSS_Afterburner}/boss"
BOSS_SOURCE="/afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-${BOSSVERSION}"
CMTHOME="/afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-${BOSSVERSION}"
CMTHOMENAME="cmthome"
WORKAREANAME="workarea"
source "${BOSSWORKAREA}/${CMTHOMENAME}/setupCMT.sh"
source "${BOSSWORKAREA}/${CMTHOMENAME}/setup.sh"
source "${BOSSWORKAREA}/${WORKAREANAME}/TestRelease/TestRelease-"*"/cmt/setup.sh"
export PATH=$PATH:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin/