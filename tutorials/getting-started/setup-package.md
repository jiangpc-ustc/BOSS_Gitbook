# Set up a BOSS package

## How to set up a BOSS package?    <a id="how-to-set-up-a-boss-package"></a>

Now that you have configured your **BOSS** work area, you can start developing packages. In theory, you can start from scratch. We'll have a short look at that procedure here, because it gives some insight into the default structure of a package in CMT.

### Structure of a default CMT package    <a id="structure-of-a-default-cmt-package"></a>

As explained in [The BOSS Analysis Framework](intro.md), BOSS is organised through packages. Packages are components of the entire BOSS framework on which individuals like you work independently. Each package on itself can have several versions that are maintained by you through CMT.

To create an empty package \(with a default format\), use the following command:

```bash
cmt create MyFirstPackage MyFirstPackage-00-00-01
```

Here, the name `MyFirstPackage` is just an example name of the package. The name will be used as the folder name as well. The second string is the so-called _tag_ of the package. Within BESIII, [the convention is that the tag is just the package name followed by 6 digits](https://docbes3.ihep.ac.cn/~offlinesoftware/index.php/How_to_tag_a_package): `-<major id>-<minor id>-<patch id>`. These digits should increase along with changes you make. Increase the:

* `patch id` if you only made some simple bug fixes that don't change the interface \(`.h` header file\);
* `minor id` if you only made changes that are backward compatible, such as new functionality;
* `major id` if you modified the interface \(header file\) that require you to completely recompile the package.

For more information on this numbering scheme, read more about this [**semantic versioning** here](https://semver.org/) \(many languages available\). The above only becomes relevant as when you start developing packages, so you can forget about this for now.

The result of the above command is a new folder, that we'll navigate into:

```bash
cd MyFirstPackage/MyFirstPackage-00-00-01
```

Note that the folder structure `MyFirstPackage/MyFirstPackage-00-00-01` is **required** for `cmt` to work properly within BOSS. If you don't have a subfolder with a string for the version as above, `cmt broadcast` won't work!

Within this folder, you see the core of a default CMT package:

* `cmd`: a folder that contains all files necessary for administration of the package through CMT. There are 6 files:
  * `cleanup.csh`

    This is a `tcsh` script that allows you to clean all installation files of the package \(for instance useful when you are moving to a new version\).

  * `cleanup.sh` The same as `cleanup.csh`, but than in `bash` shell script format.
  * `Makefile` A file that is necessary for compilation through `make`/`cmake`/`gmake`.
  * `requirements`

    The most important of file! Here, you define which other packages within BOSS your own package requires \(it defines the _dependencies_\). You can have a closer look at this file for the `TestRelease` example package or on [this page](http://polywww.in2p3.fr/activites/physique/glast/workbook/pages/cmtMRvcmt/cmtIntroduction.htm#requirementsFile) to see how this file is ordinarily formatted.

  * `setup.csh` Another important file. It is used when 'broadcasting' your package.
  * `setup.sh`: the same, but now in `bash` shell script format.
* `src`: an empty folder that will hold your `c++` source code \(`.cxx` files\). Optionally, corresponding headers of these files are usually placed in a folder called `share` but this folder is not generated by default.

For more information see [this nice introduction to CMT](http://polywww.in2p3.fr/activites/physique/glast/workbook/pages/cmtMRvcmt/cmtIntroduction.htm).

### Additional files you should create    <a id="additional-files-you-should-create"></a>

In addition to the default files above, it is advised that you also create the following files/directories:

* A subdirectory with the name of your package. In our case, it should be called `MyFirstPackage`.
* A subdirectory named`test`. You use this for private testing of your package.
* A subdirectory named`doc` for documentation files.
* A subdirectory named`share` for platform-independent configuration files, scripts, etc.
* A file named `README` that briefly describes the purpose and context of the package.
* A file named `ChangeLog` that contains a record of the changes.

The above is based on the [official BOSS page on how to create a new package](https://docbes3.ihep.ac.cn/~offlinesoftware/index.php/How_to_create_a_new_package) \(minimal explanations\).

{% hint style="info" %}
#### Origin of the BOSS in Gaudi

From here on, you can develop a package from scratch. For the basics of how to follow the guidelines of the BOSS framework \(which is based on Gaudi\), see [this `Hello World` example for Gaudi](https://lhcb.github.io/developkit-lessons/first-development-steps/02a-gaudi-helloworld.html).
{% endhint %}

### Updating a package    <a id="updating-a-package"></a>

Whenever you are planning to modify the code in your package \(particularly the header code in the `MyFirstPackage` and the source code in `src`\), it is best if you first make a copy of the latest version. You can then safely modify things in this copy and use CMT later to properly tag this new version later.

#### Copy and rename    <a id="copy-and-rename"></a>

First create some copy \(of course, you'll have to replace the names here\):

```bash
cd MyFirstPackagecp -fR MyFirstPackage-00-00-01 MyFirstPackage-00-00-02
```

Now, imagine you have modified the interface of the package in its header files. This, according to the [BOSS version naming convention](setup-package.md#structure-of-a-default-cmt-package), requires you to modify the `major id`. So you will have to rename the folder of the package:

```bash
mv MyFirstPackage-00-00-02 MyFirstPackage-01-00-00
```

#### Tag your version using CMT    <a id="tag-your-version-using-cmt"></a>

Finally, it is time to use CMT to tag this new version. The thing is, simply renaming the package is not sufficient: files like `setup.sh` need to be modified as well. Luckily, CMT does this for you automatically for. First go into the `cmt` folder of your new package:

```bash
cd MyFirstPackage-01-00-00/cmt
```

Now **create new CMT setup and cleanup scripts** using:

```bash
cmt config
```

If you for instance open the `setup.sh` file you will see that it has deduced the new version number from the folder name.

#### Build package    <a id="build-package"></a>

Now **build the executables** from the source code:

```bash
make
```

It is in this step that you 'tell' CMT which version of your package to use. First of all, executables \(`.o`\) and libraries \(`.d`\) are built in the package version folder \(in a folder like `x86_64-slc6-gcc46-opt`\). Then, symbolic links to the header files of your package are placed in a subfolder called `InstallArea` in your `workarea`. It are the symbolic links that determine which version of your package uses BOSS.

At this stage, you should verify in the terminal output whether your code is actually built correctly. If not, go through your `cxx` and `h` files.

#### Make package accessible to CMT    <a id="make-package-accessible-to-cmt"></a>

If it does build correctly, you can make the package accessible to BOSS using:

```bash
source setup.sh
```

This sets certain`bash` variables so that BOSS will use your version of this package. One of these variables is called `$<PACKAGENAME>ROOT` and can be used to call your package in job options file \(see for example `$RHOPIALGROOT` in [this template](https://github.com/redeboer/BOSS_IniSelect/blob/master/jobs/templates/analysis.txt)\).

Congratulations, you have created an update of your package!

#### Remark on `TestRelease`    <a id="remark-on-testrelease"></a>

As mentioned in [Step 3](setup.md#step-3-modify-requirements), when we were modifying the `requirements` of the BOSS environment, CMT will use the first occurrence of a package in the `$CMTPATH`. That's why we used `path_prepend` to add your _BOSS workarea_ to the `$CMTPATH`: in case of a name conflict with a package in the `$BesArea` and one in your _workarea_, CMT will use the one in your _workarea_.

Just to be sure, while modifying and debugging your package, you can do the entire build-and-source procedure above in one go, using:

```bash
cmt config
make
source setup.sh
```

BESIII has some documentation on working with CMT available [here](https://docbes3.ihep.ac.cn/~offlinesoftware/index.php/Getting_Started). It seems, however, that you need special admission rights to CVS to successfully perform these steps. The documentation is therefore probably outdated.

{% hint style="info" %}
#### Compare package output

Another reason for working with a copy of the old version of your package is that you can still checkout and run that old version \(just repeat the above procedure within the folder of that old version\). This allows you to run the same analysis \(see [Running jobs](jobs.md)\) again in the old package so that you can compare the output. **Making sure that structural updates of components of software still result in the same output is a vital part of software development!**
{% endhint %}

### Adding packages to BOSS    <a id="adding-packages-to-boss"></a>

{% hint style="warning" %}
**@todo** Go through Chinese documentation and [this page](https://docbes3.ihep.ac.cn/~offlinesoftware/index.php/Getting_Started) and write out.

**Note**: It seems special access rights are needed for this procedure, so I have currently not been able to test these procedures.
{% endhint %}

## Example packages    <a id="example-packages"></a>

Within BOSS, there are already a few 'example' packages available. All of these are accessible through the so-called [`TestRelease` package](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea/TestRelease), which will be described and set up first. We then focus on one of its main dependencies: the [RhopiAlg algorithm](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea/Analysis/Physics/RhopiAlg). Within BESIII, this package is typically used as an example for selecting events and usually forms the start of your research.

### The `TestRelease` package    <a id="the-testrelease-package"></a>

The `TestRelease` package is used to run certain basic packages that are already available within BOSS. It is best if you copy `TestRelease` into your [your _workarea_](setup.md#step-1-define-your-boss-workarea-folder), so you can play around with it. A slightly updated version of the `TestRelease` is already available in the BOSS Afterburner in the [`workarea` folder](https://github.com/redeboer/BOSS_IniSelect/tree/master/workarea).

You can also choose to copy it from its location in BOSS:

```bash
/afs/ihep.ac.cn/bes3/offline/Boss/$BOSSVERSION/TestRelease
```

If you [set up your BOSS environment](setup.md#step-2-import-environment-scripts) correctly, you can copy `TestRelease` to your _BOSS workarea_ as follows:

```bash
cp –r "$BesArea/TestRelease" "$BOSSWORKAREA"cd "$BOSSWORKAREA/TestRelease/TestRelease-"*
```

You are now in the folder `TestRelease/TestRelease-00-00-86`. Using `ls`, you can see that it contains the following folders:

* `cmt`: the _Configuration Management Tool_ that you will use to connect to **BOSS**
* `CVS`: a folder used for version management.
* `run`: which contains the `jobOptions` that are run with `boss.exe`

We can set up the `TestRelease` by going into `cmt` and 'broadcasting' to **BOSS** from there:

```bash
cd cmt
cmt broadcast      # connect your workarea to BOSS
cmt config         # perform setup and cleanup scripts
cmt broadcast make # build and connect executables to BOSS
source setup.sh    # set bash variables
```

The term `broadcast` is important here: as opposed to `config`, `broadcast` will first compile all the required packages and then require the package itself. The idea of the `TestRelease` it that make it require packages that you are interested in so that, if you `broadcast` it, all these dependents will be compiled.

We have now initialised the package, so that you can run it in BOSS from the `run` folder. This is done using `boss.exe`:

```bash
cd ../runboss.exe jobOptions_sim.txt
```

which, in this case, will run a Monte Carlo simulation.

Note that in [Step 5 when we set up the work area](setup.md#step-5-modify-your-bashrc) we added `source setup.sh` line to the `.bashrc` that ensures that the `TestRelease` package is loaded every time you log in, so you won't have to do this every time yourself.

{% page-ref page="../../packages/analysis/example-packages/rhopi.md" %}
