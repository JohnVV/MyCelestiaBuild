# Celestia-SPICE.linux
My NAIF SPICE  and SUSE leap build 

My edits and files i use for Celestia 

![] (https://raw.githubusercontent.com/JohnVV/MyCelestiaBuild/master/celestia/splash.png)

Use this to build 

--------
<code>
mkdir BUILD

cd BUILD

qmake-qt4 ../
</code>

-------

-- OR use autotools --

currently i am having a gettext issue so...."--disable-nls"
------
<code>
autoreconf -v -i

./configure --prefix=/usr --with-lua --with-qt --with-cspice-dir=/YOUR_INSTALL_LOCATION/NGT/cspice --disable-nls

make 

su

make install 
</code>

--------


-- very much still a work in progress 

-- fixed cmodtools headers not found

-- turned on the qt4 splashscreen and using my splash image 

-- added inner solarsystem spice ssc files 

-- removed old kde3 code ( except for the translations in the *.po files)

.
