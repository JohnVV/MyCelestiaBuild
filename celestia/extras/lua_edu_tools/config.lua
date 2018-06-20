-------------------------------------------------------------------------------------------------------
--                     Lua Edu Tools Configuration File
--
-- This file contains configuration parameters read by the 'Lua Edu Tools' each time
-- they are run. You can change each one of them according to your specific needs.
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- Define whether the 'Lua Edu Tools' are enabled or not when Celestia starts.
-------------------------------------------------------------------------------------------------------
show_lua_edu_tools = true

-------------------------------------------------------------------------------------------------------
-- Define the general opacity of the 'Lua Edu Tools' Graphical Interface.
-- Can take values between 0 (= transparent) and 1 (= opaque).
-------------------------------------------------------------------------------------------------------
opacity = 1

-------------------------------------------------------------------------------------------------------
-- Define colors of elements of the 'Lua Edu Tools' Graphical Interface
-- such as text messages, active buttons, sliders, ...
-- Colors are defined using {Red, Green, Blue, Alpha} color code where
-- Red, Green, Blue and Alpha are decimal values between 0 and 1.
-------------------------------------------------------------------------------------------------------
cbutextoff =    {0.8, 0.9, 0.9, 0.8}    -- unactivated button text color
cbutexton =    {0.8, 0, 0, 0.6}    -- activated button text color
cbubordoff =    {0.2, 0.4 , 0.4, 0.6}    -- unactivated button border color
cbubordon =    {0.6, 0, 0, 0.4}    -- activated button border color
ctext =     {1, 1, 1, 0.9}    -- main text color
ctextalert =    {1, 0, 0, 0.7}    -- text color for alert message
ctextinfo =     {1, 1, 1, 0.9}    -- info text color
csetbofill =    {0.05, 0.1 , 0.1, 0.9}    -- setting box filling color
cslidefrbord =    {0.8, 0.9, 0.9, 0.5}    -- slider frame border color
cslidebobord =    {0.3, 0.5 , 0.5, 0.9}    -- slider box border color
cslidebofill =    {0.2, 0.4, 0.4, 0.2}    -- slider box filling color
cscrollfill =    {0.1, 0.3, 0.3, 0.2}    -- scrollbar filling color
cclotext =    {0.4, 0.6 , 0.6, 0.9}    -- close button text color
cchetextoff =    {1, 1, 1, 0.25}    -- unavailable check-box text color
cdistmark =    {0.5, 0.5, 0, 0.9}    -- distance marker color

-------------------------------------------------------------------------------------------------------
-- Define the set of elements (or boxes) that are included in the Tool Box.
-- If you want to remove an element, just add a comment mark '--' before its name.
-- The elements are displayed on screen in the same order as they're listed in 'toolset'. You can change
-- the place of all elements in 'toolset', except 'compassBox' that must remain at the end of the list.
-------------------------------------------------------------------------------------------------------
toolset =
    {
        "timeBox",
        "lightBox",
        "magnitudeBox",
        "galaxyLightBox",
        "renderBox",
        "obsModeBox",
        "solarSystemBox",
        "fovBox",
        "addsBox",
        "infoBox",
        "coordinatesBox",
        "distanceBox",
        "magnificationBox",
        "HRBox",
        "KeplerParamBox",
        --"virtualPadBox",
        "compassBox",
    }

-------------------------------------------------------------------------------------------------------
-- Define whether the features are enabled or not when Celestia starts.
-------------------------------------------------------------------------------------------------------
enable_info = false
enable_coordinates = false
enable_magnification = false
enable_HR = false
enable_Kepler_param = false
enable_virtual_pad = false
enable_compass = false

-------------------------------------------------------------------------------------------------------
-- Define the state of the distance check-box when Celestia starts.
-- Can take the following values:
--         0: distance markers are disabled;
--         1: display square distance markers only;
--         2: display circle distance markers only;
--        3: display both square and circle distance markers;
-------------------------------------------------------------------------------------------------------
distance_state = 0

-------------------------------------------------------------------------------------------------------
-- Define the language of the 'Lua Edu Tools' Graphical Interface.
-- On Windows and Linux, the system locale's language is automatically detected
-- when language is set to "system_default".
-- On Mac, you can set your language by replacing "system_default" with
-- your language code possibly followed by "_" (underscore) and your country code.
-- The lists of codes for languages and countries are available here :
-- http://www.gnu.org/software/gettext/manual/gettext.html#Language-Codes
-- So far, available languages are "de" (German), "en" (English), "fr" (French),
--  "it" (Italian), "ko" (Korean), "nl" (Dutch), "ru" (Russian), "sv" (Swedish).
-------------------------------------------------------------------------------------------------------
language = "system_default"

-------------------------------------------------------------------------------------------------------
-- Define the date format.
-- You can choose among "country_default", "day/month/year", "month/day/year", and "year/month/day".
-------------------------------------------------------------------------------------------------------
date_format = "country_default"

-------------------------------------------------------------------------------------------------------
-- Define the Time Zone.
-- On all platforms, the system locale's Time Zone is automatically detected when
-- time_zone is set to "system_default". In this case, Time will automatically switch
-- to Daylight saving time (DST) at the appropriate date and time.
-- You can set your own value for time_zone by replacing "system_default" with an (unquoted)
-- integer or decimal number. In this case, you will have to manually set the new value to switch
-- to Daylight saving time.
-------------------------------------------------------------------------------------------------------
time_zone = "system_default"

-------------------------------------------------------------------------------------------------------
-- Define whether local Time or UTC Time is displayed by default.
-------------------------------------------------------------------------------------------------------
show_local_time = true

-------------------------------------------------------------------------------------------------------
-- Define the travelling duration (in seconds) of the Custom Goto command, accessible by [Shift]+[G].
-------------------------------------------------------------------------------------------------------
custom_goto_duration = 10

-------------------------------------------------------------------------------------------------------
-- Define objects to magnify when the magnification box is checked.
-- Objects to magnify can be:
--         "planets": magnify all the planets in our solar system;
--         "moons": magnify all the moons in our solar system;
--        "asteroids": magnify all the asteroids in our solar system;
--        "comets": magnify all the comets in our solar system;
--         "earth_moon": magnify the Earth and the Moon.
-------------------------------------------------------------------------------------------------------
magnified_objects = "planets"

-------------------------------------------------------------------------------------------------------
-- Define the different magnification coefficients.
-------------------------------------------------------------------------------------------------------
planets_magnification = 2000
moons_magnification = 100
asteroids_magnification = 200000
comets_magnification = 2000
earth_moon_magnification = 30

-------------------------------------------------------------------------------------------------------
-- Define the default position of compass on screen.
-- If center_compass is set to 'true', compass will be displayed at the bottom center of the screen.
-- If center_compass is set to 'false', compass will be displayed under the toolBox (if the screen height allows).
-------------------------------------------------------------------------------------------------------
center_compass = true

-------------------------------------------------------------------------------------------------------
-- Define the size of compass (can take values between 50 and 150).
-------------------------------------------------------------------------------------------------------
compass_size = 80

-------------------------------------------------------------------------------------------------------
-- Define whether Alt Azimuthal mode is automatically enabled or not when in Planetarium Mode.
-- If alt_azimuthal_mode is set to 'true', disabling it with CTRL+F while the Lua Tools are running
-- won't be possible (forced mode).
-------------------------------------------------------------------------------------------------------
alt_azimuthal_mode = true

-------------------------------------------------------------------------------------------------------
-- Define the zooming speed of the FoV slider (can take values between 1 and 10).
-------------------------------------------------------------------------------------------------------
zoom_speed = 5

-------------------------------------------------------------------------------------------------------
-- Define the size of virtual pad (can take values between 50 and 120).
-------------------------------------------------------------------------------------------------------
virtual_pad_size = 60

-------------------------------------------------------------------------------------------------------
-- Define whether the virtual pad pitch is reversed or not.
-------------------------------------------------------------------------------------------------------
reverse_pad_pitch = true

-------------------------------------------------------------------------------------------------------
-- Define the rotation speed of virtual pad (can take values between 1 and 10).
-------------------------------------------------------------------------------------------------------
virtual_pad_speed = 4

-------------------------------------------------------------------------------------------------------
-- Define the default position of virtual pad on screen.
-- If center_virtual_pad is set to 'true', virtual will be displayed at the bottom center of the screen.
-- If center_virtual_pad is set to 'false', virtual will be displayed under the toolBox (if the screen height allows).
-- If compass is enabled, the position of virtual pad is determined according to the position of compass.
-------------------------------------------------------------------------------------------------------
center_virtual_pad = false

-------------------------------------------------------------------------------------------------------
-- Define the number of lines displayed in the Addon Visivility list.
-------------------------------------------------------------------------------------------------------
addon_list_nlines = 4

-------------------------------------------------------------------------------------------------------
-- Define the list of elements that are included in the render setting window.
-- To remove an element, just add a comment mark '--' before its name.
-- The name of elements shouldn't be modified. This would break the function associated
-- to the corresponding check-box.
-- Elements which belong both to orbitclass and labelclass should keep the same range
-- and state in these two lists.
-------------------------------------------------------------------------------------------------------
renderclass =
    {
        "Galaxies",
        "Globulars",
        "Open Clusters",
        "Nebulae",
        "",    -- Group Separation Mark
        "Stars",
        "Planets",
        "",    -- Group Separation Mark
        "Atmospheres",
        "Cloud Maps",
        "Cloud Shadows",
        "Ring Shadows",
        "Eclipse Shadows",
        "Night Maps",
        "Comet Tails",
    }

guideclass =
    {
        "Orbits",
        --"Partial Trajectories",
        "Markers",
        "",    -- Group Separation Mark
        "Equatorial Grid",
        "Horizontal Grid",
        "Galactic Grid",
        "Ecliptic Grid",
        "Ecliptic",
        "",    -- Group Separation Mark
        "Constellations",
        "Boundaries",
        "",    -- Group Separation Mark
        "Smooth Lines",
        --"Automag",
    }

orbitclass =
    {
        "Star",
        "Planet",
        "Dwarf Planet",
        "Moon",
        "Minor Moon",
        "Asteroid",
        "Comet",
        "Spacecraft",
    }

labelclass =
    {
        "Stars",
        "Planets",
        "Dwarf Planets",
        "Moons",
        "Minor Moons",
        "Asteroids",
        "Comets",
        "Spacecraft",
        "",    -- Group Separation Mark
        "Galaxies",
        "Globulars",
        "Open Clusters",
        "Nebulae",
        "",    -- Group Separation Mark
        "Constellations",
        "Constell. in Latin",
        --"Locations",
    }

-------------------------------------------------------------------------------------------------------
-- Define the list of elements that are included in the 'Addon Visibility' setting window.
-- To remove an element, just add a comment mark '--' before its name.
-------------------------------------------------------------------------------------------------------
adds =
    {
        "Asteroid_Belt",
        "Large_Scale_Universe",
        "Galactic_Center",
        "Dying_Sun",
        "Atmosphere_Composition",
        "Political_Borders",
        "Meteorite_Impacts",
        "Earth_Volcanoes",
        "Earthquakes",
    }