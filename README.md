# Celestia-SPICE.linux

code cleanup and removing unused code 

then maybe merge back in with a microsoft and apple/BSD code base 

My NAIF SPICE  and SUSE leap build 

My edits and files i use for Celestia 

![](https://raw.githubusercontent.com/JohnVV/MyCelestiaBuild/master/celestia/splash.png)

Use this to build 

also edit the "celestia.pro" to your system settings 
--------
<code>
mkdir BUILD

cd BUILD

qmake-qt5 prefix=/usr ..

make -j4 

su

make install 
</code>


--------


-- very much still a work in progress 

02-21-18 
removed most of the unused microsoft and apple code loops and some of the gtk files 

still working on converting to 100% QT5 

still to do:
remove unused glut and gtk heades and related code 


updated to qt5

updatd to eigen 3.3.4 

updated to png 16

-- "cmodview" still NEEDS qmake-qt4 

.
