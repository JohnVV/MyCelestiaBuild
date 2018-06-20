require "locale";

----------------------------------------------
-- Define local function
----------------------------------------------
local getObsMode = function(o)
    local obsCoordSys = o:getframe():getcoordinatesystem();
    local obj = o:getframe():getrefobject();
    return obsCoordSys, obj;
end

local getTrackedObjName = function()
    if not (empty(trackedObj)) then
        trackedObjName = getlocalname(trackedObj);
    else
        trackedObjName = nil;
    end
    return trackedObjName;
end

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
obsModeBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

obsModeBox.Customdraw =
    function(this)
        -- Display the observer Frame of reference.
        local obs = celestia:getobserver();
        local obsCoordSys, obj = getObsMode(obs);
        if not(empty(obj)) then
            objname = getlocalname(obj);
            if obsCoordSys == "ecliptic" then
                obsMode = _("Follow ")..objname;
            elseif obsCoordSys == "planetographic" or obsCoordSys == "bodyfixed" then
                obsMode = _("Sync Orbit ")..objname;
            elseif obsCoordSys == "chase" then
                obsMode = _("Chase ")..objname;
            elseif obsCoordSys == "lock" then
                obsMode = _("Lock ")..objname..' -> '..getlocalname(obs:getframe():gettargetobject());
            else
                obsMode = _("Free flight");
            end
        else
            obsMode = _("Free flight");
        end
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        if trackedObjName then
            textlayout:setpos(this.lb+7, this.tb - 14);
            textlayout:println(_("Track ")..trackedObjName);
        end
        textlayout:setpos(this.lb+7, this.tb - 29);
        textlayout:println(obsMode);
    end;

--[[gotoSunButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Goto Sun"))
    :movable(false)
    :active(true)
    :attach(obsModeBox, 8, 90, 8, 30)

gotoSunButton.Action = (function()
    return
        function()
            local obs = celestia:getobserver();
            local sun = celestia:find("Sol");
            celestia:select(sun);
            obs:follow(sun);
            obs:goto(sun);
        end
    end) ();]]

gotoSelButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Goto"))
    :movable(false)
    :active(true)
    :attach(obsModeBox, 8, 27, (boxWidth +4) / 2, 35)

gotoSelButton.Action = (function()
    return
        function()
            local obs = celestia:getobserver();
            local sel = celestia:getselection();
            if not(empty(sel)) then
                obs:follow(sel);
                obs:goto(sel);
            end
        end
    end) ();

followButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Follow"))
    :movable(false)
    :active(true)
    :attach(obsModeBox, (boxWidth +4) / 2, 27, 8, 35)

followButton.Action = (function()
    return
        function()
            local obs = celestia:getobserver();
            local sel = celestia:getselection();
            if not(empty(sel)) then
                obs:follow(sel);
            end
        end
    end) ();

syncOrbitButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Sync Orbit"))
    :movable(false)
    :active(true)
    :attach(obsModeBox, 8, 7, (boxWidth +4) / 2, 55)

syncOrbitButton.Action = (function()
    return
        function()
            local obs = celestia:getobserver();
            local sel = celestia:getselection();
            if selection then
                obs:synchronous(sel);
            end
        end
    end) ();

trackButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Track"))
    :movable(false)
    :active(true)
    :attach(obsModeBox, (boxWidth +4) / 2, 7, 8, 55)

trackButton.Customdraw =
    function(this)
        local obs = celestia:getobserver();
        trackedObj = obs:gettrackedobject();
        trackedObjName = getTrackedObjName();
        if not(empty(trackedObj)) then
            trackButton.Bordercolor = cbubordon;
            trackButton.Fillcolor = {cbubordon[1]*2/3, cbubordon[2]*2/3, cbubordon[3]*2/3, cbubordon[4]/2};
        else
            trackButton.Bordercolor = cbubordoff;
            trackButton.Fillcolor = nil;
        end
    end;

trackButton.Action = (function()
    return
        function()
            local obs = celestia:getobserver();
            local sel = celestia:getselection();
            if not(empty(trackedObj)) or (empty(trackedObj) and empty(sel)) then
                -- Stop tracking the current tracked object.
                obs:track(nil);
            else
                -- Track the current selection.
                obs:track(sel);
            end
        end
    end) ();