require "locale";

----------------------------------------------
-- Define local functions
----------------------------------------------
local getRadius = function(obj_t)
    local radius_t = {};
    for k, obj in pairs(obj_t) do
        radius_t[k] = obj:radius();
    end
    return radius_t;
end 

local getSolChildrenFromType = function(magType)
    local magChildren = {};
    local allChildren = magSol:getchildren();
    for k, child in pairs(allChildren) do
        if child:type() == magType then
            magChildren[k] = child;
        end
    end
    return magChildren;
end

local getSolsysMoons = function()
    local magMoons = {};
    local magPlanets = getSolChildrenFromType("planet");
    for k, planet in pairs(magPlanets) do
        local magPlanetChildren = planet:getchildren();
        for i, child in pairs(magPlanetChildren) do
            if child:type() == "moon" then
                magMoons[k*10 + i] = child;
            end
        end
    end
    return magMoons;
end

local toggleMagnification = function(magnify)
    magRadius = getRadius(magObjects)
    if magnify then
        -- Magnify objects (increase the size of objects).
        for k, magObj in pairs(magObjects) do
            magObj:setradius(magRadius[k] * magCoeff)
            celestia:print(magStr..string.format(" %gx", magCoeff), 3)
        end
        -- Move the observer outside of the selected object.
        if selection then
            local obs = celestia:getobserver();
            local sel = celestia:getselection();
            local mag_distfromsel = celutil.get_dist(obs, sel);
            local mag_sel_radius = sel:radius();
            if mag_distfromsel < mag_sel_radius then
                local fov = obs:getfov();
                obs:gotodistance(sel, 5.5 * sel:radius() / (fov / 0.4688), 0.01)
            end
        end
    else
        -- Bring objects back to their original size.
        for k, magObj in pairs(magObjects) do
            magObj:setradius(magRadius[k] / magCoeff)
            celestia:print(_("Magnification disabled"), 3)
        end
    end
end

----------------------------------------------
-- Set initial values
----------------------------------------------
cMagnification = ctext;
magnification_first_tick = true;

magSol = celestia:find("Sol");
magEarth = celestia:find("Sol/Earth");
magMoon = celestia:find("Sol/Earth/Moon");

-- Get magnification elements from 'config.lua'.
if magnified_objects == "planets" then
    magObjects = getSolChildrenFromType("planet");
    magCoeff = planets_magnification;
    magStr = _("Planets Magnified");
elseif magnified_objects == "asteroids" then
    magObjects = getSolChildrenFromType("asteroid");
    magCoeff = asteroids_magnification;
    magStr = _("Asteroids Magnified");
elseif magnified_objects == "comets" then
    magObjects = getSolChildrenFromType("comet");
    magCoeff = comets_magnification;
    magStr = _("Comets Magnified");
elseif magnified_objects == "moons" then
    magObjects = getSolsysMoons();
    magCoeff = moons_magnification;
    magStr = _("Moons Magnified")
elseif magnified_objects == "earth_moon" then
    magObjects = {magEarth, magMoon};
    magCoeff = earth_moon_magnification;
    magStr = _("Earth and Moon Magnified")
end

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
magnificationBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

magnificationBox.Customdraw =
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cMagnification);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("Magnification"));
    end;

magnificationCheck = CXBox:new()
        :init(0, 0, 0, 0)
        :bordercolor(cbubordoff)
        :textfont(smallfont)
        :textcolor(cbutextoff)
        :textpos("center")
        :movetext(0, 10)
        :text("")
        :movable(false)
        :active(true)
        :attach(magnificationBox, boxWidth - 40, 4, 29, 5)

magnificationCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if magnification_first_tick and enable_magnification then
            magnificationCheck.Action();
        end
        magnification_first_tick = false;
    end

magnificationCheck.Action = (function()
        return
            function()
                magnify = not(magnify);
                toggleMagnification(magnify);
                if magnify then
                    magnificationCheck.Text = "x";
                    -- Disable atmospheres in magnification mode to avoid
                    -- flickering issue with OpenGL 2.0 render path.
                    atm_flag = celestia:getrenderflags()["atmospheres"];
                    celestia:setrenderflags{atmospheres = false}
                else
                    magnificationCheck.Text = "";
                    -- Set atmospheres renderflag back to its initial state.
                    celestia:setrenderflags{atmospheres = atm_flag};
                end
            end
        end) ();
