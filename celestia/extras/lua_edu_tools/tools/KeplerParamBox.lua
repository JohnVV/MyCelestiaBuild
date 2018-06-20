require "locale";

----------------------------------------------
-- Define local functions
----------------------------------------------
local formatNum = function(num, ndigits, units)
    if type(num) ~= "number" or num == INF then return "--" end;
    if num < 0 then sign = -1 else sign = 1 end;
    local lnum = 1e4;
    local pow = 0;
    local absnum = math.abs(num);
    if absnum < 1e-4 then
        num_str = string.format("%0."..ndigits.."f %s", absnum, units);
    elseif absnum <= 1 / lnum then
        while absnum < 1 do
            absnum = absnum * 10;
            pow = pow - 1;
        end
        num_str = string.format("%0."..ndigits.."f e%0.0f %s", sign * absnum, pow, units);
    elseif absnum <= 1 then
        num_str = string.format("%0.2g %s", num, units);
    elseif absnum >= lnum then
        while absnum >= 10 do
            absnum = absnum / 10;
            pow = pow + 1;
        end
        num_str = string.format("%0."..ndigits.."f e%0.0f %s", sign * absnum, pow, units);
    else
        num_str = string.format("%0."..ndigits.."f %s", num, units);
    end
    return num_str;
end

local formatKm = function(km, ndigits)
    if not km then return "--" end;
    local sign, value, units;
    if km < 0 then sign = -1 else sign = 1 end;
    km = math.abs(km);
    if km > 1e12 then
        value = km / KM_PER_LY;
        units = _("ly");
    elseif km >= 1e7 then 
        value = km / KM_PER_AU;
        units = _("AU");
    else
        value = km;
        units = _("km");
    end;
    str = formatNum(sign * value, ndigits, units);
    return str;
end

local formatKg = function(kg, ndigits)
    if not kg then return "--" end;
    local sign, value, units;
    local mstr = "";
    if kg < 0 then sign = -1 else sign = 1 end;
    kg = math.abs(kg);
    if kg > 0.1 * MASS_OF_SOL then
        value = kg / MASS_OF_SOL;
        units = _("MSun");
        mstr = formatNum(sign * value, ndigits, units);
    elseif kg > 0.9 * MASS_OF_JUPITER then
        value = kg / MASS_OF_JUPITER;
        units = _("MJupiter");
        mstr = formatNum(sign * value, ndigits, units);
    elseif kg >= 0.1 * MASS_OF_EARTH then 
        value = kg / MASS_OF_EARTH;
        units = _("MEarth");
        mstr = formatNum(sign * value, ndigits, units);
    end
    return mstr;
end

local formatDay = function(day, ndigits)
    if not day then return "--" end;
    local sign, value, units;
    if day < 0 then sign = -1 else sign = 1 end;
    day = math.abs(day);
    if day > 365.25 then
        value = day / 365.25;
        units = _("years");
        if value < 2 then
            units = _("year");
        end
    elseif day <= 1 then 
        value = day * 24;
        units = _("h");
    else
        value = day;
        units = _("days");
    end;
    str = formatNum(sign * value, ndigits, units);
    return str;
end

local getSemiMajorAxis = function(r, v, T)
    local u = (v * T) / (2*PI*r);
    local F = (1 + 54 * u^2 + 6 * u * math.sqrt(3 + 81 * u^2)) ^ (1 / 3);
    local a = (r / 6) * (1 + F + (1 / F));
    return a;
end

local getMass = function(T, a)
    local M = (4 * PI^2 * a^3) / (G * T^2);
    return M;
end

local getExcentricity = function(T, a, r, v, vrad)
    local l = r * math.sqrt(v^2 - vrad^2);
    local e = math.sqrt(1 - ((l * T) / (2 * PI * a^2))^2);
    return e;
end

local getTemperature = function(obj)
    local radtemp;
    local parent = obj;
    while parent:type() ~= "star" do
        parent = parent:getinfo().parent
    end
    if parent:type() == "star" then
        local objpos = obj:getposition();
        local parentpos = parent:getposition();
        local r = objpos:distanceto(parentpos);
        local Rstar = parent:radius();
        local Tstar = parent:getinfo().temperature;
        radtemp = Tstar * math.sqrt(Rstar / (2 * r)) - 273.15;
    end
    return radtemp;
end

-- Speed functions
-- from Toti's OrbitalSpeeds.celx script
local tspeed = function(p0, p1, dt)
   -- tangential speed in km/s
   return (p1 - p0):length() * KM_PER_MLY / dt;
end 

local aspeed = function(p0, p1, dt)
   -- angular speed in rad/s
   return math.acos( (p0 * p1) / ( p0:length() * p1:length() ) ) / dt;
end 

local rspeed = function(p0, p1, dt)
   -- radial speed in km/s
   return (p1:length() - p0:length()) * KM_PER_MLY  / dt;
end 

local getKeplerParamCandidate = function(obj)
    local candidate = nil;
    local objtype = obj:type();
    local objname = obj:name();
    if not empty(obj) and (objtype == "asteroid" or objtype == "comet" or objtype == "spacecraft" or objtype == "location" or
    objtype == "planet" or objtype == "dwarfplanet" or objtype == "moon" or objtype == "minormoon") then
        for k, exceptname in pairs(except2_name_t) do
            if objname == exceptname then
                return nil;
            end
        end
        if objtype == "location" then
            return obj:getinfo().parent;
        end
        local startdate = obj:getinfo().lifespanStart;
        local enddate = obj:getinfo().lifespanEnd;
        local t = celestia:gettime();
        if t > startdate and t < enddate then
            local objpos = obj:getposition();
            local parent = obj:getinfo().parent;
            local parenttype = parent:type();
            local parentradius = parent:radius();
            local parentpos = parent:getposition();
            local dsurf = objpos:distanceto(parentpos) - parentradius;
            if objtype == "spacecraft" and dsurf < 10 and parenttype ~= "spacecraft" then
                candidate = parent;
            else
                candidate = obj;
            end
        end
    end
    if not candidate then
        for k, bname in pairs(barycenter_name_t) do
            if objname == bname then
                candidate = obj;
            end
        end
    end
    return candidate;
end

local getObjectTypeName = function(objtype, objradius)
    local typename = "";
    if objtype == "asteroid" then
        typename = _("Asteroid");
    elseif objtype == "comet" then
        typename = _("Comet");
    elseif objtype == "spacecraft" then
        typename = _("Spacecraft");
    elseif objtype == "planet" then
        if objradius < 15000 then
            typename = _("Telluric Planet");
        else
            typename = _("Gas Giant");
        end
    elseif objtype == "dwarfplanet" then
        typename = _("Dwarf Planet");
    elseif objtype == "moon" then
        typename = _("Moon");
    elseif objtype == "minormoon" then
        typename = _("Minor Moon");
    elseif objtype == "invisible" then
        typename = _("Barycenter");
    end
    return typename;
end

----------------------------------------------
-- Set initial values
----------------------------------------------
local newwidth, newheight;
local KeplerParamFrameWidth, KeplerParamFrameHeight = 230, 300;

local KPFrameBGColor = csetbofill;
local KPFrameTitleColor = ctext;
local KPFrameTextColor = cbutextoff ;

local cKeplerParam = ctext;
local Kepler_param_first_tick = true;
local display_Kepler_param = false;

local dt_s = 1; -- time interval (seconds) used to compute velocities;
local dt_d = dt_s / 86400;

local earth = celestia:find("Sol/Earth");
local earthradius = earth:radius();

local Kepler_Param_obj;
local Kepler_Param_objname;

-- List of valid objects for which orbital parameters won't be displayed:
except1_name_t = { "Patriarche 6" };

-- List of valid objects for which no parameter will be displayed (window disabled):
except2_name_t =  { "Freedom 7", "Liberty Bell 7" };

-- List of barycenters for which orbital parameters will be displayed:
barycenter_name_t = { "Pluto-Charon" };

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
KeplerParamBox = CXBox:new()
    :init(0, 0, 0, 0)
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

KeplerParamBox.Customdraw =
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cKeplerParam);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("Kepler Param."));
    end;

KeplerParamCheck = CXBox:new()
        :init(0, 0, 0, 0)
        :bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(smallfont)
        :textcolor(cbutextoff)
        :textpos("center")
        :movetext(0, 10)
        :text("")
        :movable(false)
        :active(true)
        :attach(KeplerParamBox, boxWidth - 40, 4, 29, 5)

KeplerParamCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if Kepler_param_first_tick and enable_Kepler_param then
            KeplerParamCheck.Action();
            display_Kepler_param = true;
        end
        Kepler_param_first_tick = false;

        if selection then
            if newselection then
                local sel = celestia:getselection();
                Kepler_param_obj = getKeplerParamCandidate(sel) 
                if not Kepler_param_obj then
                    disableCheckBox(KeplerParamCheck);
                    cKeplerParam = cchetextoff;
                    if KeplerParamFrame.Visible then
                        KeplerParamFrame.Visible = false;
                    end
                else
                    enableCheckBox(KeplerParamCheck);
                    cKeplerParam = ctext;
                    if display_Kepler_param and not KeplerParamFrame.Visible then
                        KeplerParamFrame.Visible = true;
                    end
                end
            end
        else
            disableCheckBox(KeplerParamCheck);
            cKeplerParam = cchetextoff;
            if KeplerParamFrame.Visible then
                KeplerParamFrame.Visible = false;
            end
        end
    end

KeplerParamCheck.Action = (function()
        return
            function()
                display_Kepler_param = not display_Kepler_param;
                if display_Kepler_param then
                    KeplerParamFrame.Visible = true;
                    KeplerParamCheck.Text = "x";
                else
                    KeplerParamFrame.Visible = false;
                    KeplerParamCheck.Text = "";
                end
            end
        end) ();

KeplerParamFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :fillcolor(KPFrameBGColor)
    :movable(true)
    :clickable(false)
    :visible(false)
    :attach(screenBox, 2, 80, width - KeplerParamFrameWidth - 2, height - KeplerParamFrameHeight - 80)

KeplerParamFrame.Customdraw =
    function(this)
        local sel = celestia:getselection();
        if not empty(sel) then
            Kepler_Param_objname = Kepler_param_obj:name()
            local objpos = Kepler_param_obj:getposition();
            local objradius = Kepler_param_obj:radius();
            local T_d = Kepler_param_obj:getinfo().orbitPeriod;
            local T_s = T_d * 86400;
            local parent;
            if Kepler_Param_objname == "Pluto" or Kepler_Param_objname == "Charon"
              or Kepler_Param_objname == "Nix" or Kepler_Param_objname == "Hydra" then
                parent = celestia:find("Sol/Pluto-Charon");
            elseif Kepler_Param_objname == "Orcus" or Kepler_Param_objname == "Vanth" then
                parent = celestia:find("Sol/Orcus-Vanth");
            else
                parent = Kepler_param_obj:getinfo().parent;
            end
            local parentradius = parent:radius();
            local parentpos = parent:getposition();
            local parentname = parent:localname();
            local r = objpos:distanceto(parentpos);
            local surfdist = r - parentradius - objradius;

            local earthpos = earth:getposition();
            local earthdist = 0.5 * (objpos:distanceto(earthpos) - earthradius - objradius
                                + math.abs(objpos:distanceto(earthpos) - earthradius - objradius));

            local r1 = parentpos - objpos; 
            local t1 = celestia:gettime();
            local t0 = t1 - dt_d; 
            local r0  = parent:getposition(t0) - Kepler_param_obj:getposition(t0);
            local v = tspeed (r0, r1, dt_s);
            local w = aspeed (r0, r1, dt_s);
            local vrad = rspeed(r0, r1, dt_s);

            local a = getSemiMajorAxis(r, v, T_s);
            local M = getMass(T_s, a);
            local e = getExcentricity(T_s, a, r, v, vrad);
            local aphelion = a * (1 + e);
            local perihelion = a * (1 - e);

            local radtemp = getTemperature(Kepler_param_obj);

            local startdate = Kepler_param_obj:getinfo().lifespanStart;
            local UTCstart = celestia:tdbtoutc(startdate);
            local enddate = Kepler_param_obj:getinfo().lifespanEnd;
            local UTCend = celestia:tdbtoutc(enddate);

            local objtype = Kepler_param_obj:type();
            if objtype == "spacecraft" then
                if T_d > 10 then
                    M = nil;
                    a = nil;
                    e = nil;
                    aphelion = nil;
                    perihelion = nil;
                end
                if surfdist < 0.4 then
                    M = nil;
                    a = nil;
                    T_d = nil;
                    e = nil;
                    aphelion = nil;
                    perihelion = nil;
                end
            end

            local parenttype = parent:type();
            if parenttype == "spacecraft" or parenttype == "invisible" then
                M = nil;
            end

            for k, exceptname in pairs(except1_name_t) do
                if Kepler_Param_objname == exceptname then
                    M = nil;
                    a = nil;
                    T_d = nil;
                    e = nil;
                    aphelion = nil;
                    perihelion = nil;
                end
            end

            textlayout:setfont(normalfont);
            textlayout:setlinespacing(normalfont:getheight() + 2);
            textlayout:setfontcolor(KPFrameTitleColor);

            textlayout:printinbox(_("Keplerian parameters").." - "..Kepler_param_obj:localname(), this, 0, -KeplerParamFrameHeight / 2 + 15);

            textlayout:setpos(this.lb+10, this.tb-45);
            textlayout:setfontcolor(KPFrameTextColor);

            textlayout:println(_("Object Type: ")..getObjectTypeName(objtype, objradius));
            
            if objtype == "spacecraft" then
                local startdate_str = "--";
                local enddate_str = "--";
                if math.abs(startdate) ~= INF then
                    startdate_str = string.format("%0.0f", UTCstart.day).." "..monthAbbr[UTCstart.month].." "..string.format("%0.0f", UTCstart.year);
                end
                if math.abs(enddate) ~= INF then
                    enddate_str = string.format("%0.0f", UTCend.day).." "..monthAbbr[UTCend.month].." "..string.format("%0.0f", UTCend.year);
                end
                textlayout:println(_("Start / End: ")..startdate_str.." / "..enddate_str);
            else
               textlayout:println("");
            end

            textlayout:println(_("Distance to Earth: ")..formatKm(earthdist, 2));
            textlayout:println(_("Central Body: ")..parentname.."");
            textlayout:println(_("Distance to Central Body: ")..formatKm(surfdist, 2));
            textlayout:println(_("Central Mass: ")..formatNum(M, 2, _("kg")));
            if formatKg(M, 0) ~= "" then
                textlayout:movex(normalfont:getwidth(_("Central Mass: ")));
                textlayout:println(formatKg(M, 0));
            end
            textlayout:println(_("Instantaneous Velocity: ")..formatNum(v, 2, _("km/s")));
            textlayout:println(_("Radial Velocity: ")..formatNum(vrad, 2, _("km/s")));
            textlayout:println(_("Aphelion: ")..formatKm(aphelion, 2));
            textlayout:println(_("Perihelion: ")..formatKm(perihelion, 2));
            textlayout:println(_("Semi Major Axis: ")..formatKm(a, 2));
            textlayout:println(_("Orbital Period: ")..formatDay(T_d, 2));
            textlayout:println(_("Excentricity: ")..formatNum(e, 2, ""));

            textlayout:println("");
            textlayout:println(_("Radiation Temperature: ")..formatNum(radtemp, 0, _("°C")));
        end

        if newwidth ~= width or newheight ~= height then
            newwidth, newheight = width, height;
            KeplerParamFrame:attach(screenBox, 2, 80, width - KeplerParamFrameWidth - 2, height - KeplerParamFrameHeight - 80)
        end
    end;
