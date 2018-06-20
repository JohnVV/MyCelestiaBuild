-- Swedish translation of the Lua Edu Tools.
-- Anders Pamdal <anders@pamdal.se>
-- Localization revision: Mar 05, 2010

loc_str =
{

-- Lua_edu_tools
	["Lua Edu Tools enabled"] = "Lua Edu Tools aktiverat";
	["Lua Edu Tools disabled"] = "Lua Edu Tools inaktiverat";

-- Format
	Jan = "Jan";
	Feb = "Feb";
	Mar = "Mar";
	Apr = "Apr";
	May = "Maj";
	Jun = "Jun";
	Jul = "Jul";
	Aug = "Aug";
	Sep = "Sep";
	Oct = "Okt";
	Nov = "Nov";
	Dec = "Dec";

-- timeBox
	h = "t"; -- SI symbol för "timme"
	["Rate:"] = "Ratio :";
	["time stopped"] = "tid stoppad";
	["(paused)"] = "(pausad)";
	["Set Time"] = "Justera tid";
	["Current Time"] = "Aktuell tid";

-- lightBox
	["Ambient Light Level:"] = "Belysning :";

-- magnitudeBox
	["Magnitude limit:"] = "Ljusstyrkesgräns :";
	["AutoMag at 45°:"] = "AutoLjus vid 45° :";
	A = "A";

-- galaxyLightBox
	["Galaxy Light Gain:"] = "Galaxljusförstärkning:";

-- renderBox
	["Set Render Options"] = "Renderingsval";
	["Show:"] = "Visa :";
	["Guides:"] = "Guider:";
	["Orbits / Labels:"] = "Omloppsbanor / Etiketter :";
	Planets = "Planeter";
	Stars = "Stjärnor";
	Galaxies = "Galaxer";
	Nebulae = "Nebulosor";
	["Open Clusters"] = "Öppna kluster";
	Orbits = "Omloppsbanor";
	Markers = "Markeringar";
	Constellations = "Stjärnbilder";
	Boundaries = "Stjärnbildsgränser";
	["Night Maps"] = "Natttexturer";
	["Cloud Maps"] = "Molntexturer";
	Atmospheres = "Atmosfärer";
	["Comet Tails"] = "Kometsvansar";
	["Eclipse Shadows"] = "Förmörkelse skuggor";
	["Ring Shadows"] = "Ringskuggor";
	Automag = "Auto-Ljusstyrka";
	["Smooth Lines"] = "Mjuka linjer";
	Moons = "Månar";
	Asteroids = "Asteroider";
	Comets = "Kometer";
	Spacecraft = "Rymdfarkoster";
	["Constell. in Latin"] = "Stjärnbilder på latin";
	Locations = "Platser";
	["Star Style"] = "Stjärnstil";
	["Texture Resolution"] = "Texturupplösning";
	["Globulars"] = "Stjärnhopar";
	["Minor Moons"] = "Mindre månar";
	["Dwarf Planets"] = "Dvärgplaneter";
	["Cloud Shadows"] = "Molnskuggor";
	["Equatorial Grid"] = "Ekvatoriskt rutnät";
	["Horizontal Grid"] = "Horizontala rutnät";
	["Galactic Grid"] = "Galaktiska rutnät";
	["Ecliptic Grid"] = "Eliptiska rutnät";
	["Ecliptic"] = "Eliptisk";
	["Partial Trajectories"] = "Partiella banor";

-- obsModeBox
	--["Goto Sun"] = "Gå till sol";
	["Goto"] = "Gå till";
	["Follow"] = "Följ";
	["Sync Orbit"] = "Synk omlo.";
	["Track"] = "Spåra";
	["Follow "] = "Följ ";
	["Sync Orbit "] = "Synk omlo. ";
	["Track "] = "Spåra ";
	["Chase "] = "Jaga ";
	["Lock "] = "Lås ";
	["Free flight"] = "Friflygning";
	Sol = "Sol";
	["Milky Way"] = "Vintergatan";

-- SolarSytemBox
	["Solar System Browser"] = "Solsystemsutforskare";
	Star = "Stjärna";
	["Other bodies orbiting"] = "Andra kroppar i omloppsbana runt";
	["Bodies orbiting"] = "Kroppar i omloppsbana";

-- fovBox
	["FOV:"] = "FOV :";

-- addsBox
	["Set Addon Visibility"] = "Sätt tilläggsaktivering";
	["Addon Visibility:"] = "Tilläggsaktivering:";
	["Minimum Feature Size:"] = "Minsta storlek på funktion:";
	["Label Features"] = "Etiketter";
	["Asteroid Belt"] = "Asteroidbälte";
	["Dying Sun"] = "Döende sol";
	["Atmosphere Composition"] = "Atmosfärsammansättning";
	["Political Borders"] = "Politiska gränser";
	["Meteorite Impacts"] = "Meteorit kratrar";
	["Earth Volcanoes"] = "Vulkaner";
	["Earthquakes"] = "Jordbävningar";
	["Large Scale Universe"] = "Storskaligt Universum";
	["Galactic Center"] = "Galaktiskt Center";

-- infoBox
	["More Info"] = "Mer info";

-- measureBox
	Measure = "Mått";
	["Geocentric coordinates:"] = "Geocentriska koordinater:";
	["RA:"] = "RA :";
	["Dec:"] = "Dec :";
	["Distance to Earth:"] = "Avstånd till jorden :";
	ly = "lå";
	AU = "ua";
	km = "km";
	m = "m";

-- coordinatesBox
	Coordinates = "Coordinates";     -- ** TODO **
	["RA:"] = "RA :";
	["Dec:"] = "Dec :";
	--["Distance to Earth:"] = "Avstånd till jorden :";
	["Ecl. Long:"] = "Long écl. :";     -- ** TODO **
	["Ecl. Lat:"] = "Lat écl. :";     -- ** TODO **
	["Gal. Long:"] = "Long gal. :";     -- ** TODO **
	["Gal. Lat:"] = "Lat gal. :";     -- ** TODO **
	ly = "lå";
	AU = "ua";
	km = "km";
	m = "m";

-- distanceBox
	Distances = "Avstånd";

-- MagnificationBox
	Magnification = "Förstoring";
	["Planets Magnified"] = "Förstorade planeter";
	["Moons Magnified"] = "Förstorade månar";
	["Earth and Moon Magnified"] = "Förstorad jord och måne";
	["Magnification disabled"] = "Förstoring avaktiverad";

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
	["Virtual Pad"] = "Virtuell platta";

-- compassBox
	Compass = "Kompass";
	S = "S";
	W = "V";
	N = "N";
	E = "Ö";
	["Az:"] = "Az:";
	["Elev:"] = "Elev:";
	["planetarium mode"] = "planetariums läge";
	["navigation mode"] = "navigations läge";
	["Alt-azimuth mode enabled"] = "Läge Alt-Azimuthal aktivt";

}
