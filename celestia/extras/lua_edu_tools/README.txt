********************************************************
*	LUA EDU 1.2 TOOLS FOR CELESTIA 1.6
*	(c) 2009
*	Vincent Giangiulio <vince.gian@free.fr>
*	Hank Ramsey
********************************************************

--------------------------------------------------------
WHAT ARE THE LUA EDU TOOLS ?
--------------------------------------------------------
The 'Lua Edu Tools' is an addon for Celestia 1.6 that provides :
- A Graphical Interface that simplifies access to the main commands in order to allow students
and non-confirmed users to run Celestia in complete autonomy. 
- New features that are not available in Celestia 1.6: compass, InfoText/Image, distance markers, etc... 

The Graphical Interface includes the following components:
  > Simulation Date and Time in the system locale format, Timescale slider, Time/Date setting option;
  > Ambient Light slider;
  > Magnitude slider;
  > Galaxy Light Gain slider;
  > Render Options setting option;
  > Navigation buttons: Go to Sun; Go to Selection; Follow Selection; Sync Orbit; Track Selection;
  > Solar System browser which classifies objects according to their type (planets, moons, asteroids, ...);
  > FOV slider;
  > Addon Visibility setting option;
  > Information Text overlay (infoText), and Image overlay with diaporama (infoImage);
  > Celestial Coordinates : Equatorial, Ecliptic and Galactic;
  > Distance markers:
     - distance square-markers are displayed in the observer's plane and centered on screen;
     - distance circle-markers are displayed in the ecliptic plane and centered on the current selection;
  > Magnification option for an educational visualization of our Solar System (objects in magnified size);
  > Hertzsprung-Russell Diagram;
  > Keplerian parameters (dynamically computed);
  > Virtual Pad for an easy control of pitch and yaw motion.
  > Compass: (you can click on the compass to change its position on screen)
     - Planetarium/Navigation mode buttons;
     - Longitude/Latitude or Azimuth/Elevation (click to switch);

The 'Custom Goto' command, accessible by [Shift]+[G], moves the camera to the current selection
and makes it fit the screen. The travelling duration of the 'Custom Goto' command can be set in the
configuration file (cf section: 'HOW TO CUSTOMIZE THE LUA EDU TOOLS ?').

--------------------------------------------------------
HOW TO INSTALL THE LUA EDU TOOLS ?
--------------------------------------------------------
1- Unzip and paste the 'lua_edu_tools' folder in your 'extras' folder.
2- Paste the 'luahookinit.lua' file in your Celestia root folder.
3- Add this line to your celestia.cfg file :
	Configuration
	{
	LuaHook "luahookinit.lua" # <-- Line to add
	...

The Lua Edu Tools 1.2 are for use with Celestia 1.6:
http://www.shatters.net/celestia/download.html

--------------------------------------------------------
HOW TO USE THE LUA EDU TOOLS ?
--------------------------------------------------------
- Once the Lua Edu Tools are installed, the Graphical Interface is automatically displayed
  each time you run Celestia.
- You can enable/disable the Lua Edu Tools either by clicking on the right hand side of the
	toolbox or by pressing [Shift]+[i].
- All the standard features of Celestia, like the keyboard controls, remain active even
  when the Graphical Interface is on.

--------------------------------------------------------
HOW TO CUSTOMIZE THE LUA EDU TOOLS ?
--------------------------------------------------------
- The Lua Edu Tools are easily customizable via the 'config.lua file'. There you can define
  your own set of elements that you want to include in the Tool Box, and choose whether
  the Lua Edu Tools are displayed or not each time Celestia starts. You can also set your
  own parameters such as the language, the time zone, the colors of elements of the Graphical
  Interface, the default position of the compass...
  The 'config.lua' file can be edited using a simple text editor (Notepad, ...).

- The Lua Edu Tools are already available in several languages: "de" (German), "en" (English),
  "fr" (French), "it" (Italian), "ko" (Korean), "nl" (Dutch), "ru" (Russian), "sv" (Swedish).
  On Windows and Linux, the system locale language ('lang') is automatically detected.
  On Mac, you can set your local language by editing the 'language' entry in the 'config.lua' file.
  A translated version of this readme.txt file can be found in each 'lang' folder
  present in the 'locale' folder.

- To add your own Information text, edit the 'infos/infoText.lua' file, or the
  'locale/lang/infoText_lang.lua' file that corresponds to your language.
  > Simply add the following line(s) for each object:
	   Name_of_object = [[ infoText ]];
  Note: Use ["Name of object"] if the name contains any spaces.

- To add your own Information images, edit the 'infos/infoImage.lua' file.
  Several image files can be used for the same object (diaporama).
  > Simply add the following lines for each object:
	   Name_of_object = { "image_filename_1"; "image_filename_2"; ... }
  Note: Use ["Name of object"] if the name contains spaces.
  Then, place your image files into the 'images' folder.

- You can display your own set of stars in the Hertzsprung-Russell Diagram.  
  The files containing the list of star names should be placed in the infos/' folder
  and named as 'HR_stars_1.lua', 'HR_stars_2.lua', ...
  You can use the existing 'HR_stars_1.lua' file as an example.

- You can include your own addon to the 'Addon Visibility' option. To do so, you need to create a
  Lua file on the same model as the 'adds/Political_Borders/Political_Borders.lua' file, and place
  it in the 'adds' folder. Then, just add the name of your Lua file into the 'adds' list in 'config.lua'.
  The name displayed in the 'Addon Visibility' window will be the same as the name of your Lua file,
  except that underscores '_' will be replaced by spaces ' '.
  The Lua file contains a table which can include the following values:
    >  objects = { string:object1path, string:object2path, ... }
    Defines the list of objects whose visibility will be enabled/disabled.
    >	labelcolor = {number:red, number:green, number:blue, number:alpha}
    Defines the color of the addon labels. The name of the addon will be then displayed using
    this same color in the 'Addon Visibility' window.
    >	locationtype = string:location_type
    Defines the type of location that will be enabled/disabled simultaneously with the objects visibility.
    List of all location types: http://en.wikibooks.org/wiki/Celestia/SSC_File#Type_.22string.22
    >	script = string:scriptfilename
    Defines the filename of the script that is run whenever the addon is enabled via the checkbox.
    The script path is relative to the addon's directory.

--------------------------------------------------------
CONTRIBUTING TO THE INTERNATIONALIZATION OF THE LUA EDU TOOLS:
--------------------------------------------------------
- You can translate the Lua Edu Tools in your own language (lang) by creating the following files:
  > 'locale/lang/lang.lua'
  > 'locale/lang/infoText_lang.lua'
  > 'locale/lang/images/compass_lang.png'
  You can use the 'locale/fr/fr.lua', 'locale/fr/infoText_fr.lua', and 'locale/fr/images/compass_fr.png' files
  as examples. A 'compass.psd file' containing all the layers is provided in the 'images' folder.
  Please, don't forget to translate this 'readme.txt' file too.
  Then, please send your translated files to <vince.gian@free.fr> so that they can be included into the
  official release of the Lua Edu Tools. Thanks !

Note: You can edit any of the .lua files using your favorite text editor (Notepad, ...).
         You can use Notepad2 if you need to add text with accentuated characters,
         or characters from Russian, Green, Cyrillic, ... alphabets:
          1- Download Notepad2 at: http://www.flos-freeware.ch/notepad2.html
          2- Open the .lua file within Notepad2: File > Open...
          3- Choose UTF-8 encoding: File > Encoding > UTF-8
          4- Edit the file by adding your own text, and save it: File > Save

--------------------------------------------------------
CREDITS:
--------------------------------------------------------
- The Lua Edu Tools can be freely used/copied/modified/distributed for non-commercial activities.
  Please keep a copy of the original version of this 'readme.txt' file within your 'lua_edu_tools' folder.

- You must contact the author <vince.gian@free.fr> if you want to use the original or a modified version
  of the Lua Edu Tools for any commercial activity.

- All images except compass.png and compass_lang.png are courtesy of NASA [www.nasa.gov]

- Thanks to all the translators for their contribution on the internationalization of the Lua Edu Tools:
	DE: Ulrich Dickmann aka Adirondack <celestia-deutsch@gmx.net>
	KO: Seung-Bum Lee <blcktgr73@gmail.com>
	RU: Sergey Leonov <leserg@ua.fm>
	SV: Anders Pamdal <anders@pamdal.se>

-	Special thanks to Martin (Cham) and ElChristou for their help and precious contribution to this project.
	Thanks to Massimo (Fenerit), and all testers for their very helpful reports.
	Big thanks to Ken (Jedi) for his contribution on the coding of the distance circle markers.

@+
Vincent