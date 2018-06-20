-- Nederlandse vertaling van de Lua Edu Tools.
-- Marco Klunder <marco.klunder@hccnet.nl>
-- Localisatie revisie: Mar 05, 2010

loc_str =
{

-- Lua_edu_tools
	["Lua Edu Tools enabled"] = "Lua Edu Tools ingeschakeld";
	["Lua Edu Tools disabled"] = "Lua Edu Tools uitgeschakeld";

-- Format
	Jan = "jan";
	Feb = "feb";
	Mar = "mrt";
	Apr = "apr";
	May = "mei";
	Jun = "jun";
	Jul = "jul";
	Aug = "aug";
	Sep = "sep";
	Oct = "okt";
	Nov = "nov";
	Dec = "dec";

-- timeBox
	h = "h"; -- SI symbool voor "uur"
	["Rate:"] = "Ratio:";
	["time stopped"] = "tijd gestopt";
	["(paused)"] = "(pauze)";
	["Set Time"] = "Tijd instellen";
	["Current Time"] = "Huidige Tijd";

-- lightBox
	["Ambient Light Level:"] = "Omgevingslicht:";

-- magnitudeBox
	["Magnitude limit:"] = "Helderheid limiet:";
	["AutoMag at 45°:"] = "Helderheid limiet bij 45°:";
	A = "A"; 	-- AutoMag Knop

-- galaxyLightBox
	["Galaxy Light Gain:"] = "Lichtsterkte Sterrenstelsels:";

-- renderBox
	["Set Render Options"] = "Weergave Opties";
	["Show:"] = "Toon:";
	["Guides:"] = "Hulplijnen:";
	["Orbits / Labels:"] = "Omloopbanen / Labels:";
	Planets = "Planeten";
	Stars = "Sterren";
	Galaxies = "Sterrenstelsels";
	Nebulae = "Nevels";
	["Open Clusters"] = "Open Sterrenhopen";
	Orbits = "Omloopbanen";
	Markers = "Markeringen";
	Constellations = "Sterrenbeelden";
	Boundaries = "Sterrenbeeld grenzen";
	["Night Maps"] = "Lichten aan nachtzijde";
	["Cloud Maps"] = "Wolken";
	Atmospheres = "Atmosferen";
	["Comet Tails"] = "Komeetstaarten";
	["Eclipse Shadows"] = "Eclipsschaduwen";
	["Ring Shadows"] = "Ringschaduwen";
	Automag = "Auto schijnbare helderheid";
	["Smooth Lines"] = "Anti-aliasing";
	Moons = "Manen";
	Asteroids = "Asteroiden";
	Comets = "Kometen";
	Spacecraft = "Ruimtevaartuigen";
	["Constell. in Latin"] = "Sterrenbeelden in Latijn";
	Locations = "Lokaties";
	["Star Style"] = "Sterrenstijl";
	["Texture Resolution"] = "Textuur resolutie";
	["Globulars"] = "Bolvormige Sterrenhopen";
	["Minor Moons"] = "Kleine Manen";
	["Dwarf Planets"] = "Dwergplaneten";
	["Cloud Shadows"] = "Wolkenschaduwen";
	["Equatorial Grid"] = "Hemellijk Raster";
	["Horizontal Grid"] = "Horizontaal Raster";
	["Galactic Grid"] = "Galactisch Raster";
	["Ecliptic Grid"] = "Zonneweg Raster";
	["Ecliptic"] = "Ecliptica";
	["Partial Trajectories"] = "Gedeeltelijke Banen";

-- obsModeBox
	--["Goto Sun"] = "Ga naar de Zon";
	["Goto"] = "Ga naar";
	["Follow"] = "Achtervolgen";
	["Sync Orbit"] = "Synchr. baan";
	["Track"] = "Volgen";
	["Follow "] = "Achtervolgen ";
	["Sync Orbit "] = "Synchrone omloopbaan ";
	["Track "] = "Volgen ";
	["Chase "] = "Opjagen ";
	["Lock "] = "Vastzetten ";
	["Free flight"] = "Vrije vlucht";
	Sol = "Zon";
	["Milky Way"] = "Melkweg";

-- SolarSytemBox
	["Solar System Browser"] = "Zonnestelsel Browser";
	Star = "Ster";
	["Other bodies orbiting"] = "Andere lichamen in een omloopbaan met";
	["Bodies orbiting"] = "Lichamen in een omloopbaan met";

-- fovBox
	["FOV:"] = "Zichtbaar veld:";

-- addsBox
	["Set Addon Visibility"] = "Addon Weergave";
	["Addon Visibility:"] = "Addon Weergave:";
	["Minimum Feature Size:"] = "Minimale Feature Grootte:";
	["Label Features"] = "Label Features";
	["Asteroid Belt"] = "Asteroiden Gordel";
	["Dying Sun"] = "Stervende Zon";
	["Atmosphere Composition"] = "Samenstelling Atmosfeer";
	["Political Borders"] = "Politieke Grenzen";
	["Meteorite Impacts"] = "Meteoriet Inslagen";
	["Earth Volcanoes"] = "Vulkanen op Aarde";
	["Earthquakes"] = "Aardbevingen";
	["Large Scale Universe"] = "Structuur van het Universum";
	["Galactic Center"] = "Midden van de Melkweg";

-- infoBox
	["More Info"] = "Meer Info";

-- coordinatesBox
	Coordinates = "Coordinates";     -- ** TODO **
	["RA:"] = "Rechte Klimming:";
	["Dec:"] = "Declinatie:";
	--["Distance to Earth:"] = "Afstand tot de Aarde:";
	["Ecl. Long:"] = "Long écl. :";     -- ** TODO **
	["Ecl. Lat:"] = "Lat écl. :";     -- ** TODO **
	["Gal. Long:"] = "Long gal. :";     -- ** TODO **
	["Gal. Lat:"] = "Lat gal. :";     -- ** TODO **
	ly = "LJ";
	AU = "AE";
	km = "km";
	m = "m";

-- distanceBox
	Distances = "Afstanden";

-- MagnificationBox
	Magnification = "Uitvergroting";
	["Planets Magnified"] = "Planeten uitvergroot";
	["Moons Magnified"] = "Manen uitvergroot";
	["Earth and Moon Magnified"] = "Aarde en Maan uitvergroot";
	["Magnification disabled"] = "Uitvergroting uitgeschakeld";

-- HRBox     -- ** TODO **
	["Hertzsprung-Russell Diagram"] = "Hertzsprung-Russell Diagram";
	["HR Diagram"] = "HR Diagram";
	["The selected object is a stellar barycenter."] = "The selected object is a stellar barycenter.";
	["The selected star is out of frame."] = "The selected star is out of frame.";
	["Reference stars"] = "Reference stars";
	["Nearest stars from Sun (d < 25 ly)"] = "Nearest stars from Sun (d < 25 ly)";
	["Stars with exoplanets"] = "Stars with exoplanets";
	["Visible stars from Earth (app mag < 5)"] = "Visible stars from Earth (app mag < 5)";
	["Lum."] = "Lum.";
	["Abs. Mag."] = "Abs. Mag.";
	["Temp. (K)"] = "Temp. (K)";

-- KeplerParamBox     -- ** TODO **
	["Kepler Param."] = "Kepler Param.";
	MSun = "MSun";
	MJupiter = "MJupiter";
	MEarth = "MEarth";
	kg = "kg";
	years = "years";
	year = "year";
	days = "days";
	["km/s"] = "km/s";
	Asteroid = "Asteroid";
	Comet = "Comet";
	Spacecraft = "Spacecraft";
	["Telluric Planet"] = "Telluric Planet";
	["Gas Giant"] = "Gas Giant";
	["Dwarf Planet"] = "Dwarf Planet";
	Moon = "Moon";
	["Minor Moon"] = "Minor Moon";
	["Barycenter"] = "Barycenter";
	["Keplerian parameters"] = "Keplerian parameters";
	["Object Type: "] = "Object Type: ";
	["Start / End: "] = "Start / End: ";
	["Distance to Earth: "] = "Distance to Earth: ";
	["Central Body: "] = "Central Body: ";
	["Distance to Central Body: "] = "Distance to Central Body: ";
	["Central Mass: "] = "Central Mass: ";
	["Instantaneous Velocity: "] = "Instantaneous Velocity: ";
	["Radial Velocity: "] = "Radial Velocity: ";
	["Aphelion: "] = "Aphelion: ";
	["Perihelion: "] = "Perihelion: ";
	["Semi Major Axis: "] = "Semi Major Axis: ";
	["Orbital Period: "] = "Orbital Period: ";
	["Excentricity: "] = "Excentricity: ";
	["Radiation Temperature: "] = "Radiation Temperature: ";
	["°C"] = "°C";

-- virtualPadBox
	["Virtual Pad"] = "Virtuele Joystick";

-- compassBox
	Compass = "Kompas";
	S = "Z";
	W = "W";
	N = "N";
	E = "O";
	["Az:"] = "Azi:";
	["Elev:"] = "Hoogte:";
	["planetarium mode"] = "Planetarium modus";
	["navigation mode"] = "Navigatie modus";
	["Alt-azimuth mode enabled"] = "Hoogte-Azimut modus ingeschakeld";

}