-- Korean translation of the Lua Edu Tools.
-- Seung-Bum Lee <blcktgr73@gmail.com>
-- Localization revision: Mar 05, 2010

loc_str =
{

-- Lua_edu_tools
	["Lua Edu Tools enabled"] = "Lua Edu Tools 활성화";
	["Lua Edu Tools disabled"] = "Lua Edu Tools 비활성화";

-- Format
	Jan = "1";
	Feb = "2";
	Mar = "3";
	Apr = "4";
	May = "5";
	Jun = "6";
	Jul = "7";
	Aug = "8";
	Sep = "9";
	Oct = "10";
	Nov = "11";
	Dec = "12";

-- timeBox
	h = "h"; -- SI symbol for "hour"
	["Rate:"] = "비율 :";
	["time stopped"] = "시간 정지";
	["(paused)"] = "(멈춤)";
	["Set Time"] = "시간 설정";
	["Current Time"] = "현재 시각";

-- lightBox
	["Ambient Light Level:"] = "주변 빛의 세기: ";

-- magnitudeBox
	["Magnitude limit:"] = "한계등급:";
	["AutoMag at 45°:"] = "45° 한계등급:";
	A = "A"; 	-- AutoMag Button

-- galaxyLightBox
	["Galaxy Light Gain:"] = "은하계 광도 이익 :";

-- renderBox
	["Set Render Options"] = "표시 옵션 설정";
	["Show:"] = "보기 :";
	["Guides:"] = "가이드 :";
	["Orbits / Labels:"] = "궤도 / 이름:";
	Galaxies = "은하";
	["Globulars"] = "구상성단";
	["Open Clusters"] = "산개성단";
	Nebulae = "성운";
	Stars = "항성";
	Planets = "행성";
	Atmospheres = "대기";
	["Cloud Maps"] = "구름맵";
	["Cloud Shadows"] = "구름 그림자";
	["Ring Shadows"] = "고리 그림자";
	["Eclipse Shadows"] = "식 그림자";
	["Night Maps"] = "야간맵";
	["Comet Tails"] = "혜성 꼬리";
	Orbits = "궤도";
	["Partial Trajectories"] = "부분 궤적";
	Markers = "마커";
	Constellations = "별자리";
	Boundaries = "경계";
	["Equatorial Grid"] = "적도 그리드";
	["Horizontal Grid"] = "수평 그리드";
	["Galactic Grid"] = "은하 그리드";
	["Ecliptic Grid"] = "황도 그리드";
	["Ecliptic"] = "황도";
	["Smooth Lines"] = "부드러운 궤도선";
	Automag = "Automag";
	Moons = "위성";
	["Dwarf Planets"] = "왜소행성";
	["Minor Moons"] = "소 위성";
	Asteroids = "소행성";
	Comets = "혜성";
	Spacecraft = "우주선"; -- should be '우주선'
	["Constell. in Latin"] = "라틴어 별자리명";
	Locations = "지명";
	["Star Style"] = "항성표시";
	["Texture Resolution"] = "해상도";

-- obsModeBox
	--["Goto Sun"] = "태양으로 이동";
	["Goto"] = "이동";
	["Follow"] = "추적";
	["Sync Orbit"] = "자전 동기";
	["Track"] = "중앙 유지";
	["Follow "] = "추적: ";
	["Sync Orbit "] = "자전 동기: ";
	["Track "] = "중앙 유지: ";
	["Chase"] = "공전 동기";
	["Lock"] = "참조 동기";	
	["Free flight"] = "자유 비행";
	Sol = "태양";
	["Milky Way"] = "은하수";

-- SolarSytemBox
	["Solar System Browser"] = "태양계 브라우저";
	Star = "항성";
	["Other bodies orbiting"] = "전체 공전 천체-";
	["Bodies orbiting"] = "공전 천체-";

-- fovBox
	["FOV:"] = "시야각:";

-- addsBox
	["Set Addon Visibility"] = "애드온 적용 설정";
	["Addon Visibility:"] = "애드온 적용:";
	["Minimum Feature Size:"] = "최소표시:";
	["Label Features"] = "지명 보기";
	["Asteroid Belt"] = "소행성대";
	["Dying Sun"] = "죽어가는 태양";
	["Atmosphere Composition"] = "대기 구성";
	["Political Borders"] = "국경 표시";
	["Meteorite Impacts"] = "운석 충돌 위치 표시";
	["Earth Volcanoes"] = "지구 화산 위치 표시";
	["Earthquakes"] = "지진 발생지 표시";
	["Large Scale Universe"] = "거대 우주";
	["Galactic Center"] = "은하 중심";

-- infoBox
	["More Info"] = "상세 정보";

-- coordinatesBox: Refer http://katnani.egloos.com/671918 and http://www.setisigns.net/219
	Coordinates = "Coordinates";     -- ** TODO **
	["RA:"] = "경도:"; -- RightAscention
	["Dec:"] = "위도:"; -- Declination
	--["Distance to Earth:"] = "지구까지 거리:";
	["Ecl. Long:"] = "Long écl. :";     -- ** TODO **
	["Ecl. Lat:"] = "Lat écl. :";     -- ** TODO **
	["Gal. Long:"] = "Long gal. :";     -- ** TODO **
	["Gal. Lat:"] = "Lat gal. :";     -- ** TODO **
	ly = "광년";
	AU = "AU";
	km = "km";
	m = "m";

-- distanceBox
	Distances = "거리";

-- MagnificationBox
	Magnification = "확대";
	["Planets Magnified"] = "행성 확대";
	["Moons Magnified"] = "달 확대";
	["Earth and Moon Magnified"] = "지구와 달 확대";
	["Magnification disabled"] = "확대 비활성화";

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
	["Virtual Pad"] = "버추얼 패드";

-- compassBox
	Compass = "나침반";
	S = "S";
	W = "W";
	N = "N";
	E = "E";
	["Az:"] = "방위각";
	["Elev:"] = "고도각";
	["planetarium mode"] = "플라네타륨 모드";
	["navigation mode"] = "네비게이션 모드";
	["Alt-azimuth mode enabled"] = "고도각·방위각 모드 활성화";

}