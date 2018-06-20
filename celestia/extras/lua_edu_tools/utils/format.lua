require "locale";

----------------------------------------------
-- Define some useful global values
----------------------------------------------
KM_PER_LY = 9460730472580.8;
KM_PER_AU = 149597870.7;
KM_PER_MLY = 9460730.4725808;
MLY_PER_KM = 1e6 / KM_PER_LY;

SPEED_OF_LIGHT = 299792.458; -- km / s
G = 6.67428e-20;    -- km³ / (kg • s²)

MASS_OF_EARTH = 5.9736e24; -- kg
MASS_OF_JUPITER = 1.8986e27; -- kg
MASS_OF_SOL = 1.9891e30; -- kg

PI = math.pi;
degToRad = math.pi / 180;
INF = math.huge;

monthAbbr = {
    _("Jan"),
    _("Feb"),
    _("Mar"),
    _("Apr"),
    _("May"),
    _("Jun"),
    _("Jul"),
    _("Aug"),
    _("Sep"),
    _("Oct"),
    _("Nov"),
    _("Dec")
};

----------------------------------------------
-- Define some useful global functions
----------------------------------------------
format = {};

format.km =
    function(this,km)
        local sign, value, units
        if not (type(km) == "number") then return km end;
        if km < 0 then sign = -1 else sign = 1 end;
        km = math.abs(km);
        if km > 1000000000000 then
            value = km/KM_PER_LY
            units = _("ly");
        elseif km >= 100000000 then 
            value = km/KM_PER_AU;
            units = _("AU");
        else
            value = km
            units = _("km");
        end;
        return string.format("%.2f",sign*value).." "..units;
    end

format.mly =
    function(this,mly)
        if  not (type(mly) == "number")  then
            return "?" ;
        end;
        return format:km(mly*KM_PER_LY/1e6);
    end

format.pos =
    function(this,p)
        if not p then return "nil pos" end;
        return "[ " .. format:mly(p.x) .. "  ,  "..format:mly(p.y) .."  ,  ".. format:mly(p.z).." ]";
    end 

format.deg =
    function(this, deg)
        if math.abs(deg)  < 5e-3 or math.abs(deg -360.0) < 5e-3 then
            deg = 0;
        end
        return string.format("%4.2f°", deg);
    end

format.degdms =
    function(this,deg)
        local    a = math.abs(deg);
          local    d = math.floor(a);
        local    r = (a-d)*60;
        local    m = math.floor(r);
        local    s = (r-m)*60;
        if deg < 0 then d = -d end;
        --return string.format("%0.0f %02.0f' %04.2f'' (%0.3f)",d,m,s,deg);
        return string.format("%0.0f° %02.0f' %2.0f''",d,m,s);
    end

format.deghms =
    function(this,deg)
        local    a = math.abs(deg/15);
          local    d = math.floor(a);
        local    r = (a-d)*60;
        local    m = math.floor(r);
        local    s = (r-m)*60;
        --if deg < 0 then d = -d end;
        return string.format("%0.0fh %02.0fm %2.0fs",d,m,s);
    end

format.raddms =
    function(this,rad)
    local deg = rad/degToRad;
    return format:degdms(deg);
    end

format.fracpercent =
    function(this,f)
    return string.format("%0.2f%%",f*100);
    end

format.twodigits =
    function(this,f)
    return string.format("%02.0f",f);
    end

math_round = function(d)
    return math.floor(d + 0.5);
end;

math_sign = function(d)
    if d == 0 then
        return 0;
    else
        return d/math.abs(d);
    end
end;