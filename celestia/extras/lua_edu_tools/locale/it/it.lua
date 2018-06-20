-- Italian translation of the Lua Edu Tools.
-- Massimo (Fenerit) <fenerit@interfree.it>
-- Localization revision: Mar 05, 2010

loc_str =
{

-- Lua_edu_tools
	["Lua Edu Tools enabled"] = "Lua Edu Tools abilitati";
	["Lua Edu Tools disabled"] = "Lua Edu Tools disabilitati";

-- Format
	Jan = "Gen";
	Feb = "Feb";
	Mar = "Mar";
	Apr = "Apr";
	May = "Mag";
	Jun = "Giu";
	Jul = "Lug";
	Aug = "Ago";
	Sep = "Set";
	Oct = "Ott";
	Nov = "Nov";
	Dec = "Dic";

-- timeBox
	h = "h"; -- SI symbol for "hour"
	["Rate:"] = "Tasso:";
	["time stopped"] = "Tempo fermato";
	["(paused)"] = "(in pausa)";
	["Set Time"] = "Imposta il tempo";
	["Current Time"] = "Tempo corrente";

-- lightBox
	["Ambient Light Level:"] = "Luce ambientale:";

-- magnitudeBox
	["Magnitude limit:"] = "Limite magnitudine:";
	["AutoMag at 45°:"] = "AutoMag a 45°:";
	A = "A"; 	-- AutoMag Button

-- galaxyLightBox
	["Galaxy Light Gain:"] = "Visibilità galassie:";

-- renderBox
	["Set Render Options"] = "Opzioni";
	["Show:"] = "Mostra:";
	["Guides:"] = "Guide:";
	["Orbits / Labels:"] = "Orbite / Nomi:";
	Galaxies = "Galassie";
	["Globulars"] = "Ammassi globulari";
	["Open Clusters"] = "Ammassi aperti";
	Nebulae = "Nebulose";
	Stars = "Stelle";
	Planets = "Pianeti";
	Atmospheres = "Atmosfere";
	["Cloud Maps"] = "Nubi";
	["Cloud Shadows"] = "Ombre delle nubi";
	["Ring Shadows"] = "Ombre degli anelli";
	["Eclipse Shadows"] = "Ombre delle eclissi";
	["Night Maps"] = "Luci notturne";
	["Comet Tails"] = "Code delle comete";
	Orbits = "Orbite";
	["Partial Trajectories"] = "Traiettorie parziali";
	Markers = "Marcatori";
	Constellations = "Costellazioni";
	Boundaries = "Confini delle costellazioni";
	["Equatorial Grid"] = "Griglia equatoriale";
	["Horizontal Grid"] = "Griglia orizzontale";
	["Galactic Grid"] = "Griglia galattica";
	["Ecliptic Grid"] = "Griglia dell'eclittica";
	["Ecliptic"] = "Eclittica";
	["Smooth Lines"] = "Linee smussate";
	Automag = "Magnitudine Autom.";
	["Dwarf Planets"] = "Pianeti nani";
	Moons = "Lune";
	["Minor Moons"] = "Lune minori";
	Asteroids = "Asteroidi";
	Comets = "Comete";
	Spacecraft = "Veicoli spaziali";
	["Constell. in Latin"] = "Costellazioni in Latino";
	Locations = "Luoghi";
	["Star Style"] = "Stile delle stelle";
	["Texture Resolution"] = "Risoluzione mappe";

-- obsModeBox
	--["Goto Sun"] = "Vai al Sole";
	["Goto"] = "Vai a:";
	["Follow"] = "Segui";
	["Sync Orbit"] = "Sinc. orbita";
	["Track"] = "Traccia";
	["Follow "] = "Segui ";
	["Chase"] = "Insegui";
	["Lock"] = "Blocca";	
	["Free flight"] = "Volo libero";
	Sol = "Sole";
	["Milky Way"] = "Via Lattea";

-- SolarSytemBox
	["Solar System Browser"] = "Navigatore del Sist. Sol.";
	Star = "Stella";
	["Other bodies orbiting"] = "Altri corpi orbitanti il";
	["Bodies orbiting"] = "Corpi orbitanti";

-- fovBox
	["FOV:"] = "CdV :";

-- addsBox
	["Set Addon Visibility"] = "Mostra gli Add-ons";
	["Addon Visibility:"] = "Lista degli Add-ons:";
	["Minimum Feature Size:"] = "Dimensione minima delle etichette:";
	["Label Features"] = "Etichette";
	["Asteroid Belt"] = "Cintura degli asteroidi";
	["Dying Sun"] = "Morte del Sole";
	["Atmosphere Composition"] = "Composizioni atmosferiche";
	["Political Borders"] = "Confini politici";
	["Meteorite Impacts"] = "Impatti dei meteoriti";
	["Earth Volcanoes"] = "Vulcani terrestri";
	["Earthquakes"] = "Terremoti";
	["Large Scale Universe"] = "La struttura dell'universo";
	["Galactic Center"] = "Centro della galassia"; 

-- infoBox
	["More Info"] = "Ulteriori inf.";

-- coordinatesBox
	Coordinates = "Coordinates";     -- ** TODO **
	["RA:"] = "RA :";
	["Dec:"] = "Dec :";
	--["Distance to Earth:"] = "Distanza dalla Terra:";
	["Ecl. Long:"] = "Long écl. :";     -- ** TODO **
	["Ecl. Lat:"] = "Lat écl. :";     -- ** TODO **
	["Gal. Long:"] = "Long gal. :";     -- ** TODO **
	["Gal. Lat:"] = "Lat gal. :";     -- ** TODO **
	ly = "al";
	AU = "ua";
	km = "km";
	m = "m";

-- distanceBox
	Distances = "Distanze";

-- MagnificationBox
	Magnification = "Ingrandisci";
	["Planets Magnified"] = "Ingrandimento pianeti";
	["Moons Magnified"] = "Ingrandimento lune";
	["Earth and Moon Magnified"] = "Ingrandimento Terra e Luna";
	["Magnification disabled"] = "Ingrandimento disabilitato";

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
	["Virtual Pad"] = "Pad Virtuale";

-- compassBox
	Compass = "Bussola";
	S = "S";
	W = "O";
	N = "N";
	E = "E";
	["Az:"] = "Az.:";
	["Elev:"] = "Elev.:";
	["planetarium mode"] = "Modo planetarium";
	["navigation mode"] = "Modo navigazione";
	["Alt-azimuth mode enabled"] = "Modo Alt-Azimutale attivato";

}