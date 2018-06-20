-- Russian translation of the Lua Edu Tools.
-- Sergey Leonov <leserg@ua.fm>
-- Localization revision: Mar 05, 2010

loc_str =
{

-- Lua_edu_tools
	["Lua Edu Tools enabled"] = "Lua Edu Tools включена";
	["Lua Edu Tools disabled"] = "Lua Edu Tools отключена";

-- Format
	Jan = "янв";
	Feb = "фев";
	Mar = "мар";
	Apr = "апр";
	May = "май";
	Jun = "июн";
	Jul = "июл";
	Aug = "авг";
	Sep = "сен";
	Oct = "окт";
	Nov = "ноя";
	Dec = "дек";

-- timeBox
	h = "ч"; -- SI symbol for "hour"
	["Rate:"] = "Множитель:";
	["time stopped"] = "время остановлено";
	["(paused)"] = "(пауза)";
	["Set Time"] = "Установка времени";
	["Current Time"] = "Текущее время";

-- lightBox
	["Ambient Light Level:"] = "Рассеянный свет:";

-- magnitudeBox
	["Magnitude limit:"] = "Предел величины:";
	["AutoMag at 45°:"] = "Автовеличина при 45°:";
	A = "A"; 	-- AutoMag Button

-- galaxyLightBox
	["Galaxy Light Gain:"] = "Свет галактик:";

-- renderBox
	["Set Render Options"] = "Настройки просмотра";
	["Show:"] = "Показывать :";
	["Guides:"] = "Путеводитель :";
	["Orbits / Labels:"] = "Орбиты / Названия :";
	Planets = "Планеты";
	Stars = "Звезды";
	Galaxies = "Галактики";
	Nebulae = "Туманности";
	["Open Clusters"] = "Рассеянные скопления";
	Orbits = "Орбиты";
	Markers = "Метки";
	Constellations = "Созвездия";
	Boundaries = "Границы созвездий";
	["Night Maps"] = "Свет ночной стороны";
	["Cloud Maps"] = "Облачный покров";
	Atmospheres = "Атмосферу";
	["Comet Tails"] = "Хвосты комет";
	["Eclipse Shadows"] = "Тени затмений";
	["Ring Shadows"] = "Тени на кольцах";
	Automag = "Автовеличина";
	["Smooth Lines"] = "Сглаживание";
	Moons = "Спутники";
	Asteroids = "Астероиды";
	Comets = "Кометы";
	Spacecraft = "Космич. корабл.";
	["Constell. in Latin"] = "Созвездия на латинице";
	Locations = "Местоположения";
	["Star Style"] = "Стиль звезд";
	["Texture Resolution"] = "Разрешение текстур";
	["Globulars"] = "Шаровые скопления";
	["Minor Moons"] = "Малые луны";
	["Dwarf Planets"] = "Малые планеты";
	["Cloud Shadows"] = "Тени облаков";
	["Equatorial Grid"] = "Экваториальная сетка";
	["Horizontal Grid"] = "Горизонтальная сетка";
	["Galactic Grid"] = "Галактическая сетка";
	["Ecliptic Grid"] = "Эклиптическая сетка";
	["Ecliptic"] = "Эклиптика";
	["Partial Trajectories"] = "Детали траекторий";

-- obsModeBox
	--["Goto Sun"] = "Идти к Солнцу";
	["Goto"] = "Перейти";
	["Follow"] = "Наблюдение";
	["Sync Orbit"] = "Синх. вращ.";
	["Track"] = "Слежение";
	["Follow "] = "Наблюдение: ";
	["Sync Orbit "] = "Синх. вращ.: ";
	["Track "] = "Слежение: ";
	["Chase "] = "Сопровождение: ";
	["Lock "] = "Захват: ";
	["Free flight"] = "Свободный полет";
	Sol = "Солнце";
	["Milky Way"] = "Млечный путь";

-- SolarSytemBox
	["Solar System Browser"] = "Каталог Солнечной системы";
	Star = "Звезда";
	["Other bodies orbiting"] = "Другие объекты";
	["Bodies orbiting"] = "Орбитальные объекты";

-- fovBox
	["FOV:"] = "FOV:";

-- addsBox
	["Set Addon Visibility"] = "Модули расширений";
	["Addon Visibility:"] = "Расширения :";
	["Minimum Feature Size:"] = "Мин. размер местоположений:";
	["Label Features"] = "Показывать названия";
	["Asteroid Belt"] = "Пояс астероидов";
	["Dying Sun"] = "Умирание Солнца";
	["Atmosphere Composition"] = "Состав атмосферы";
	["Political Borders"] = "Границы государств";
	["Meteorite Impacts"] = "Падения метеоритов";
	["Earth Volcanoes"] = "Вулканы Земли";
	["Earthquakes"] = "Землетрясения";
	["Large Scale Universe"] = "Модель Вселенной";
	["Galactic Center"] = "Центр Галактики";

-- infoBox
	["More Info"] = "Справка";

-- coordinatesBox
	Coordinates = "Coordinates";     -- ** TODO **
	["RA:"] = "Прямое восхождение:";
	["Dec:"] = "Склонение:";
	--["Distance to Earth:"] = "Расстояние до Земли:";
	["Ecl. Long:"] = "Long écl. :";     -- ** TODO **
	["Ecl. Lat:"] = "Lat écl. :";     -- ** TODO **
	["Gal. Long:"] = "Long gal. :";     -- ** TODO **
	["Gal. Lat:"] = "Lat gal. :";     -- ** TODO **
	ly = "св.л.";
	AU = "а.е.";
	km = "км";
	m = "м";

-- distanceBox
	Distances = "Расстояния";

-- MagnificationBox
	Magnification = "Увеличение";
	["Planets Magnified"] = "Увеличение планет";
	["Moons Magnified"] = "Увеличение спутников";
	["Earth and Moon Magnified"] = "Увеличение Земли и Луны";
	["Magnification disabled"] = "Увеличение отключено";

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
	["Virtual Pad"] = "Управление";

-- compassBox
	Compass = "Компас";
	S = "Ю";
	W = "З";
	N = "С";
	E = "В";
	["Az:"] = "Аз.:";
	["Elev:"] = "Скл.:";
	["planetarium mode"] = "Планетарий";
	["navigation mode"] = "Навигация";
	["Alt-azimuth mode enabled"] = "Включен режим Высота-Азимут";

}