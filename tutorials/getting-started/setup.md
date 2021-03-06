# Set up your BOSS environment

{% hint style="warning" %}
**Warning:** In it's current version, this tutorial assumes you use a `bash` terminal. It should work for TC-shell as well, but if you experience problems, please [contact me]().
{% endhint %}

{% hint style="success" %}
See [last section of this page](setup.md#summary-of-commands) for an overview of all commands. If you are in a very lazy mood, you can also download and run [this bash script](https://github.com/redeboer/BOSS_StarterKit/blob/master/utilities/SetupBoss.sh):

```bash
wget https://raw.githubusercontent.com/redeboer/BOSS_StarterKit/master/utilities/SetupBoss.sh
bash SetupBoss.sh
```
{% endhint %}

In this section, you will learn how to 'install' BOSS. Since BOSS has already been compiled on the server, installing actually means that you set up _path variables_ in the `bash` shell. Shortly said, your user account then 'knows' where to locate BOSS and how to run it.

There are two main directories that you will be using:

1. a _local install area_, from which access to BOSS is managed and which contains your own BOSS packages \(mostly event selection\), and
2. an _analysis folder_, which contains scripts that you design yourself to analyse output from BOSS \(for example fitting histograms\). You can decide to have this folder locally on your own pc, because analyses of this type require less computing power.

It is totally up to you where you place these folders. A common procedure is to put the _analysis folder_ in the `ihepbatch` folder. Have a look at the [organisation of the IHEP server](server.md) to decide if there is some other folder that meets your needs.

{% hint style="info" %}
#### In case of large data

If you work with large data samples, you may want to write your output to a different folder in[`scratchfs`](server.md#main-directories). Take care to modify the paths your job option files accordingly! \(See [running jobs](jobs.md).\)
{% endhint %}

## Set up the BOSS environment

### **Step 1:** Define your local install folder

For the sake of making this tutorial work in a general setting, we will first define a `bash` variable here \(you can just execute this command in `bash`\):

In this part of the tutorial, we will do two things: \(1\) setup the necessary references to BOSS and \(2\) preparing your `workarea` folder. You will be developing and your own BOSS packages \(mainly code for event selection\) in this `workarea` folder. Next to your `workarea`, there will be a [_Configuration Management Tool_](intro.md#configuration-management-tool-cmt) folder \(`cmthome`\), which manages access to the BOSS installation. In the end you will have a file structure like this:

* `/besfs/users/$USER/boss/` \(local install area\)
  * `cmthome` \(manages access to BOSS\)
  * `workarea` \(contains your analysis code\)
    * `TestRelease` \(loads essential BOSS packages\)
    * `InstallArea` \(binaries and header files are collected here after compiling\)

{% hint style="info" %}
The above is equivalent to `BOSSINSTALL=/besfs/users/$USER/boss`, so why the quotation marks \(`"..."`\) and curly braces \(`{...}`\)? It's just a good habit in `bash`scripting to avoid bugs and improve readability. The quotation marks clarify that we are storing a string here and allow you to use spaces, while the curly braces clarify the extend of the variable name \(`USER` in this case\).
{% endhint %}

```bash
BOSSINSTALL="/besfs/users/${USER}/boss"
```

This variable points to the path that will contain your local 'install' of BOSS. You can change what is between the quotation marks by whatever folder you prefer in case you want your local BOSS install to be placed in some other path, for instance by `/ihepbatch/bes/$USER`.

At this stage, you'll have to decide which version of BOSS you have to use. At the time of writing, **version 7.0.4** is the latest stable version, though it could be that for your analysis you have to use data sets that were reconstructed with older versions of BOSS. Here, we'll stick with `7.0.4`, but you can replace this number with whatever version you need.

For convenience, we'll again define the version number as a variable here.

```bash
BOSSVERSION="7.0.4"
```

{% hint style="info" %}
An overview of all BOSS versions and their release notes can be found [here](https://docbes3.ihep.ac.cn/~offlinesoftware/index.php/ReleaseNotes) \(requires login\).
{% endhint %}

### **Step 2: Import environment scripts**

We first have to obtain some scripts that allow you to set up references to BOSS. This is done by copying the `cmthome` folder from the BOSS Software directory, which contains all source code for BOSS, to your local install area  \(option `-p` allows`mkdir` to work on arbitrary depth\):

```bash
mkdir -p "$BOSSINSTALL/cmthome"
cd "$BOSSINSTALL/cmthome"
cp -Rf /afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-$BOSSVERSION/* .
```

Note from the `cp` command that we have omitted the version from the original folder name. You can choose to keep that number as well, but here we chose to use the convention is that `cmthome` and `workarea` without a version number refers to the latest stable version of BOSS.

### **Step 3: Modify** `requirements`

In `cmthome*` , you now have to modify a file called `requirements`, so that it handles your username properly. We'll use the `vi` editor here, but you can use whatever editor you prefer:

```bash
vi requirements
```

The file contains the following lines:

```bash
#macro WorkArea "/ihepbatch/bes/maqm/workarea"

#path_remove CMTPATH "${WorkArea}"
#path_prepend CMTPATH "${WorkArea}"
```

Uncomment them \(remove the hash `#`\) and replace what is between the first quotation marks `"..."` with your the path to your workarea. In our case, it looks like this:

```bash
macro WorkArea "/besfs/users/$USER/boss/workarea"

path_remove CMTPATH "${WorkArea}"
path_prepend CMTPATH "${WorkArea}"
```

The `$CMTPATH` is an important variable for [CMT](intro.md#configuration-management-tool-cmt). It is comparable to `$PATH` in that it lists all directories that contain CMT packages. Note that, when CMT searches for packages that you listed in the `requirements` file, it will use the first occurrence in the `$CMTPATH`. This is why you `prepend` it.

### **Step 4: Set references to BOSS**

Now you can use the scripts in `cmthome` to set all references to BOSS at once, using:

```bash
source setupCMT.sh  # starts connection to the CMT
cmt config          # initiates configuration
source setup.sh     # sets path variables
```

Just to be sure, you can check whether the path variables have been set correctly:

```bash
echo $CMTPATH
```

If everything went well, it should print something like:

```bash
/besfs/users/$USER/boss/workarea:/afs/ihep.ac.cn/bes3/offline/Boss/7.0.4:
/afs/ihep.ac.cn/bes3/offline/ExternalLib/SLC6/ExternalLib/gaudi/GAUDI_v23r9:
/afs/ihep.ac.cn/bes3/offline/ExternalLib/SLC6/ExternalLib/LCGCMT/LCGCMT_65a
```

The paths listed here \(separated by `:` columns\) will be used to look for packages required by the `requirements` files of packages \(see [Set up a BOSS package](setup-package.md)\). The first of these paths points to your `workarea`, the second to the BOSS version you use \(also called `$BesArea`\), and the rest point to external libraries such as [Gaudi](https://dayabay.bnl.gov/dox/GaudiKernel/html/annotated.html).

### **Step 4: Create a** `workarea` **subfolder**

[As mentioned in the introduction](setup.md#set-up-the-boss-environment), the local install area contains a `workarea`folder next to the `cmthome`folder we have been using so far. In our case it will be:

```bash
mkdir -p "$BOSSWORKAREA/workarea"
```

We'll get back to the `workarea` folder when we [set up a BOSS package](setup-package.md).

{% hint style="info" %}
Your _BOSS workarea_ typically contains three folders \(see [an example here](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea)\):

1. [`Analysis`](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea/Analysis), which contains CMT packages that you use for your analysis
2. [`InstallArea`](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea/InstallArea), which is created when you use `cmt confi`
3. [`TestRelease`](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea/TestRelease), which is used to run all packages

The file structure of your _workarea_ follows that of the packages in `$BesArea` \(use `ls $BesArea` to verify this\), because, [as explained before](setup.md#step-3-modify-requirements), packages in your _workarea_ have priority over those in `$BesArea`. As such, you can expand your _workarea_ by copying certain packages from the `$BesArea` and modifying those. In the _BOSS Afterburner_, there is for instance [a modification of the `BesEvtGen` Monte Carlo generator](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea/Generator).
{% endhint %}

### Step 5: Implement the `TestRelease` package

BOSS is built up of a large number of packages, such as `VertexFit`. Your local account needs to load the essential ones in order for you to be able to run the `boss.exe` executable. For this, all versions of BOSS come with the `TestRelease` package. This package helps you to load those essential packages.

Copy the latest `TestRelease` package from the `$BesArea` \(where the source code of the BOSS version you chose is located\) to your `workarea`:

```bash
cd $BOSSINSTALL/workarea
cp -Rf $BesArea/TestRelease .
```

Then move into the `cmt` folder that comes with it and source scripts in there:

```bash
cd TestRelease/TestRelease-*/cmt
cmt broadcast      # load all packages to which TestRelease refers
cmt config         # perform setup and cleanup scripts
cmt broadcast make # build executables
source setup.sh    # set bash variables
```

### **Step 6: Test BOSS using** `boss.exe`

To test whether everything went correctly, you can try to run BOSS:

```text
boss.exe
```

It should result in a \(trivial\) error message like this:

```text
               BOSS version: 7.0.4
************** BESIII Collaboration **************

the jobOptions file is : jobOptions.txt
ERROR! the jobOptions file is empty!
```

If not, something went wrong and you should carefully recheck what you did in the above steps.

### **Step 7: Modify your** `bashrc`

In order to have the references to BOSS loaded automatically every time you log in on the server, we can add some of the steps we did above to your `bash` profile \(`.bash_profile`\) and _run commands_ file \(`.bashrc`\).

{% hint style="info" %}
On a _login terminal_, the `.bash_profile` script is loaded every time you log in, while a _local terminal_ \(like a Ubuntu install on your own pc\) loads `.bashrc` \(run commands\). In the following, we therefore just 'forward' the loading of `.bash_profile` to `.bash_rc`.
{% endhint %}

First, add the following lines to your bash profile \(use `vi ~/.bash_profile`\):

{% code title=".bash\_profile" %}
```bash
if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi
```
{% endcode %}

These lines force the server to source your `.bashrc` run commands file when you log in. In that file, you should add the following lines:

{% code title=".bashrc" %}
```bash
export BOSSINSTALL="/besfs/users/${USER}/boss"
export BOSSVERSION="7.0.4"
CMTHOME="/afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-${BOSSVERSION}"

source "${BOSSINSTALL}/cmthome/setupCMT.sh"
source "${BOSSINSTALL}/cmthome/setup.sh"
source "${BOSSINSTALL}/workarea/TestRelease/TestRelease-*/cmt/setup.sh"
export PATH=$PATH:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin/
```
{% endcode %}

Notice that the commands we used the previous steps appear here again. The last line allows you to submit BOSS jobs to the 'queue' \(using the `hep_sub` command\) — for now, don't worry what this means.

To reload the run commands, either just log in again or use `source ~/.bashrc`.

## Summary of commands

The following summarises all commands required to 'install' BOSS on `lxslc` on your IHEP user account. If you don't know what you are doing, go through the sections above to understand what's going on here.

```bash
BOSSINSTALL=/besfs/users/$USER/boss
BOSSVERSION=7.0.4
mkdir -p $BOSSINSTALL/cmthome
cd $BOSSINSTALL/cmthome
cp -Rf /afs/ihep.ac.cn/bes3/offline/Boss/cmthome/cmthome-$BOSSVERSION/* .
vi requirements

```

Now uncomment and change the lines containing `WorkArea` to `/besfs/users/$USER/boss/workarea`. Then:

```bash
source setupCMT.sh
cmt config
source setup.sh
mkdir -p $BOSSINSTALL/workarea
cd $BOSSINSTALL/workarea
cp -Rf $BesArea/TestRelease .
cd TestRelease/TestRelease-*/cmt
cmt broadcast      # load all packages to which TestRelease refers
cmt config         # perform setup and cleanup scripts
cmt broadcast make # build executables
source setup.sh    # set bash variables

```

If you want, you can add the `source` commands above your `.bash_profile` so that BOSS is sourced automatically setup scripts automatically each time you log in. In simple copy-paste commands:

```bash
OFILE=~/.bash_profile
echo >> $OFILE
echo "export BOSSINSTALL=/besfs/users/$USER/boss" >> $OFILE
echo "source \$BOSSINSTALL/cmthome/setupCMT.sh"  >> $OFILE
echo "source \$BOSSINSTALL/cmthome/setup.sh"  >> $OFILE
echo "source \$BOSSINSTALL/workarea/TestRelease/TestRelease-*/cmt/setup.sh" >> $OFILE
echo "export PATH=\$PATH:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin" >> $OFILE

```

