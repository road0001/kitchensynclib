This document should help you gain access to the KitchenSync library and set it up for use in a Flash or Flex project. Once you have included the source files in your class path, check out the [getting started](GettingStarted.md) page for help with coding.

## Downloading KitchenSync Code ##
The code for KitchenSync is freely available for download through the Google Code site. There are two basic ways to get the code.
  1. Visit the [Downloads tab](http://code.google.com/p/kitchensynclib/downloads/list) and download the latest stable build.
  1. Use [Subversion](http://subversion.tigris.org/) (SVN) to check out the code from the repository through the [Source tab](http://code.google.com/p/kitchensynclib/source/checkout).

**Note** The code in the `/trunk` folder is the latest build and may be unstable or have partially implemented features. However, all stable versions are available to download since they will be tagged in the `/tags` folder. If you're not sure what a [tag](http://svnbook.red-bean.com/en/1.4/svn.branchmerge.tags.html) is (or have no idea what I'm talking about), I recommend [learning all about Subversion](http://svnbook.red-bean.com/) or just downloading the .zip file.

### Source files vs. Compiled code library (SWC) ###
Whether you download a zip or checkout from the repository, the code will come in one of two forms: as a series of folders containing .as files (in the `/src` folder in the repository), or as a single compiled code library in a .swc file (in the `/bin` folder in the repository).

If you use Flash CS3 to code, you will need to use the **source files** since, unfortunately, Flash CS3 cannot use .swc files compiled by the Flex SDK. Also, I would strongly suggest that you consider switching to FlexBuilder or another platform to do your development work.

If you use any other platform you can choose between the two. The pre-compiled .swc file will save you time when compiling and still give you the benefits of code-hinting in tools like FlexBuilder but is un-editable and does not allow you to view its contents. The raw source code can be viewed and edited but must be recompiled each time your program changes and, if edited, can become out of sync with the repository.

## Installing KitchenSync to your project ##
In order to 'install' the library, you'll need to follow one of the following paths.

### Flash CS3 users ###
First, seriously consider using FlexBuilder. The code completion features make working with KitchenSync much simpler.

You'll need to add the source folder (the folder containing KitchenSync's `/org` folder) to your .fla file's classpath. For information on how to do this, consult the [boring Flash documentation](http://livedocs.adobe.com/flash/9.0/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000775.html).

Remember to import the right packages (`import org.as3lib.kitchensync.*;`) or the code won't be recognized by the compiler!

### FlexBuilder users ###
You'll need to add the .swc or the source folder to your project in the Build Path panel of the properties window. For .swc's, click the Library Path tab and then click the 'Add SWC...' or 'Add SWC Folder' to locate the .swc file. For source, click the 'Add Folder...' button on the Source Path tab and navigate to the folder containing the `/com` and `/org` folders for KitchenSync.

![http://as3lib.org/kitchensync/docs/img/buildPathHelp.png](http://as3lib.org/kitchensync/docs/img/buildPathHelp.png)

For more help with this, check out the [Adobe LiveDocs](http://livedocs.adobe.com/labs/flex3/html/help.html?content=ui_reference_3.html).

**Note:** If your project is a Flex project (rather than ActionScript 3.0 project), check out the wiki page on [Using KitchenSync for a Flex Project](Using_KitchenSync_with_Flex.md).

### Flex SDK users ###
You probably don't need my help.

## Related Links ##
  * [Getting started](GettingStarted.md)
  * [Using KitchenSync for a Flex Project](Using_KitchenSync_with_Flex.md)
  * [Setting up a new project with Flash CS3 or FlexBuilder](http://mimswright.com/blog/?p=210)
  * [Version Control with Subversion](http://svnbook.red-bean.com/) free eBook