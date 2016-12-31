# Celestia-SPICE.linux
My NAIF SPICE  and SUSE leap build 

My edits and files i use for Celestia 

Use this to build 

<code>
mkdir BUILD

cd BUILD

qmake-qt4 ../
</code>

-- OR --

<code>
autoreconf -v -i

./configure --prefix=/usr --with-lua --with-qt --with-cspice-dir=/YOUR_INSTALL_LOCATION/NGT/cspice

make 

su

make install 
</code>


-- very much still a work in progress 

-- fixed cmodtools headers not found

-- turned on the qt4 splashscreen and using my splash image 
