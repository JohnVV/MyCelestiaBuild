require "locale";

----------------------------------------------
-- Define the local compass image.
----------------------------------------------
compImageFilename = "../locale/"..lang.."/images/compass_"..lang..".png";
compassImage = celestia:loadtexture(compImageFilename);
if not(compassImage) then
    compImageFilename = "../images/compass.png";
    compassImage = celestia:loadtexture(compImageFilename);
end

----------------------------------------------
-- Define local functions
----------------------------------------------
local rotateCompass = function (x,y,w)
    -- Rotate the compass.
    x = x - (lb + compassW / 2);
    y = y - (bb + compassH / 2);
    local x2 = x * math.cos(w) - y * math.sin(w);
    local y2 = y * math.cos(w) + x * math.sin(w);
    -- A translation is also needed to make the compass rotate about its center.
    x2 = x2 + (lb + compassW / 2);
    y2 = y2 + (bb + compassH / 2);
    return x2, y2;
end

local drawCompass = function(angle)
    -- Draw the compass.
    local angle_rad = angle * degToRad;
    lb,bb,rb,tb = compassFrameBox:bounds();
    local xlb, ylb = rotateCompass(lb, bb, angle_rad);
    local xrb, yrb = rotateCompass(rb, bb, angle_rad);
    local xrt, yrt = rotateCompass(rb, tb, angle_rad);
    local xlt, ylt = rotateCompass(lb, tb, angle_rad);
    compassImage:bind();
    gl.Enable(gl.TEXTURE_2D);
    gl.Begin(gl.QUADS);
    gl.Color(1, 1, 1, 0.9 * alpha * opacity);
    gl.TexCoord(0, 1); gl.Vertex(xlb, ylb);
    gl.TexCoord(1, 1); gl.Vertex(xrb, yrb);
    gl.TexCoord(1, 0); gl.Vertex(xrt, yrt);
    gl.TexCoord(0, 0); gl.Vertex(xlt, ylt);
    gl.End();
    gl.Disable(gl.TEXTURE_2D);
end

local enableCompass = function(obj)
    local enable = false;
    if not empty(obj) then
        otype = obj:type();
        oname = obj:name()..' ';
         if otype == "spacecraft" then
            local ptype = obj:getinfo().parent:type();
            if ptype == "planet" or ptype == "moon" then
                enable = true;
            end
        elseif otype == "moon" then
            local ptype = obj:getinfo().parent:type();
            if ptype == "planet" then
                enable = true;
            end
        elseif otype == "planet" or oname == "Pluto " or otype == "location" then
            enable = true;
        end
    end
    return enable
end

----------------------------------------------
-- Set initial values
----------------------------------------------
width, height = celestia:getscreendimension();
compassFrameWidth, compassFrameHeight = boxWidth, 45;

cCompass = ctext;
compass_first_tick = true;

bgcolor = false;
displonglat = true;
switchable = false;

-- Get centerCompass initial value from 'config.lua'.
centerCompass = center_compass;

-- Get compass size from 'config.lua'.
compass_size = math.min(150, math.max(50, compass_size));
compassW, compassH = compass_size, compass_size;

retrograde_planets = {"Venus", "Uranus", "Pluto"}

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
compassBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

compassBox.Customdraw =
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cCompass);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("Compass"));
    end;

compassCheck = CXBox:new()
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
        :attach(compassBox, boxWidth - 40, 4, 29, 5)

compassCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if compass_first_tick and enable_compass then
            compassCheck.Action();
        end
        compass_first_tick = false;

        local obs = celestia:getobserver();
        refObj = obs:getframe():getrefobject();
        if not enableCompass(refObj) then
            disableCheckBox(compassCheck);
            cCompass = cchetextoff;
            compassFrame.Visible = false;
        else
            enableCheckBox(compassCheck);
            cCompass = ctext;
            compassFrame.Visible = (compassCheck.Text == "x");
        end
    end

compassCheck.Action = (function()
        return
            function()
                compassFrame.Visible = not(compassFrame.Visible);
                if compassFrame.Visible then
                    compassCheck.Text = "x";
                else
                    compassCheck.Text = "";
                    compassFrameBox.Visible = false;
                end
            end
        end) ();

compassFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({0.2, 0, 0, 0.3})
    :movable(false)
    :visible(false)
    :active(false)
    :attach(screenBox, width, height, 0, 0);

compassFrame.Customdraw =
    function(this)
        local obs = celestia:getobserver();
        refObj = obs:getframe():getrefobject();
        if not(empty(refObj)) then
            if refObj:type() == "location" or refObj:type() == "spacecraft" then
                refObj = refObj:getinfo().parent;
            end
            az, elev = celutil.get_az_elev (obs, refObj);
            long, lat = celutil.get_long_lat(obs, refObj);
        end
        longlatBox.Visible = true;
        if not(empty(refObj)) then
            if celutil.get_dist(obs, refObj) < 1.02 * refObj:radius() then
                -- Planetarium mode.
                modeButton.Visible = true;
                modeButton.Text = _("navigation mode");
                longlatBox.Active = true;
                compassFrameBox.Text = "^";
                if switchable == false then
                    displonglat = false;
                    switchable = true;
                end
                if alt_azimuthal_mode and math.abs(elev) < 88 then
                    -- Force Alt Azimuthal Mode.
                    celutil.force_up(obs, refObj);
                    if not(celestia:getaltazimuthmode()) then
                        celestia:setaltazimuthmode(true);
                        celestia:flash(_("Alt-azimuth mode enabled"));
                    end
                end
                -- Avoid bug when centering reference object in planetarium mode.
                if elev < -89.9 then
                    az = 0;
                end
                compass_angle = az;
                -- When located at a (Geographic) Pole, make the
                -- compass constantly point to the opposite Pole.
                if math.abs(lat) >= 89.995 then
                    compass_angle = math.abs(lat + 90);
                end
                -- Display the compass. We start displaying the compass on the second tick
                --  in order to hide a possible uggly resizing of the compass during the first tick.
                if not(compass_first_tick) then
                    compassFrameBox.Visible = true;
                    drawCompass(compass_angle);
                end
            else
                -- Navigation mode.
                compassFrameBox.Text = "";
                compassFrameBox.Visible = false;
                bgcolor = false;
                modeButton.Visible = true;
                modeButton.Text = _("planetarium mode");
                longlatBox.Active = false;
                displonglat = true;
                switchable = false;
            end
        end
        compassFrame:attach(screenBox, width-compassFrameWidth-2, compassBox.bb-compassFrameHeight,
                                                                            2, height-compassBox.bb);
    end;

compassFrameBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :textfont(titlefont)
    :textcolor({1, 1, 1, 0.2})
    :textpos("center")
    :movetext(0, -17)
    :text("^")
    :visible(false)
    :movable(false)
    :active(true)
    :attach(screenBox, width/2, height/2, width/2, height/2)

compassFrameBox.Customdraw =
    function(this)
        -- Don't display the compass under the toolbox if the screen height does not allow.
        if not(centerCompass) and height < toolBoxHeight+2 then
            centerCompass = true
        end
        if centerCompass then
            -- Display the compass at the bottom center of the screen.
            compassFrameBox:attach(screenBox, (width-compassW)/2, 10, (width-compassW)/2, height-compassH-10);
        else
            -- Display the compass under the toolbox.
            compassFrameBox:attach(screenBox, (width-(boxWidth+compassW)/2-2), compassBox.bb-compassH-45,
            (boxWidth-compassW)/2+2, height-compassBox.bb+45);
        end
    end;

compassFrameBox.Action = (function()
    return
        function()
            -- Switch the compass position between the bottom
            -- center of the screen and the bottom of the toolBox.
            centerCompass = not(centerCompass)
        end
    end) ();

longlatBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :movable(false)
    :active(true)
    :attach(compassFrame, 5, 4, 5, 25)

longlatBox.Customdraw =
    function(this)
        -- Switch display between longitude-latitude and azimuth-elevation.
        textlayout:setfont(normalfont);
        textlayout:setlinespacing(normalfont:getheight());
        textlayout:setfontcolor(ctext);
        local obs = celestia:getobserver();
        if displonglat then
            for k,name in pairs(retrograde_planets) do
                if refObj:name().." " == name.." " then
                    long = -long;
                    lat = -lat;
                end
            end
            if long >= 0 then
                long_str = format:deg(math.abs(long))..' '.._("E");
            else
                long_str = format:deg(math.abs(long))..' '.._("W");
            end
            if lat >= 0 then
                lat_str = format:deg(math.abs(lat))..' '.._("N");
            else
                lat_str = format:deg(math.abs(lat))..' '.._("S");
            end
            textlayout:setpos(this.lb+12, this.tb-12);
            textlayout:println(long_str);
            textlayout:setpos(this.lb+boxWidth / 2 + 4, this.tb-12);
            textlayout:println(lat_str);
        else
            az_str = _("Az:").." "..format:deg(az);
            elev_str = _("Elev:").." "..format:deg(elev);
            textlayout:setpos(this.lb+5, this.tb-12);
            textlayout:println(az_str);
            textlayout:setpos(this.lb+boxWidth / 2, this.tb-12);
            textlayout:println(elev_str);
        end
    end;

longlatBox.Action = (function()
    return
        function()
            displonglat = not(displonglat)
        end
    end) ();

modeButton = CXBox:new()
    :init(0, 0, 0, 0)
    :textfont(normalfont)
    :textpos("center")
    :movetext(0, 6)
    :text(_("planetarium mode"))
    --:textcolor({0.8, 0.8 , 0.9, 0.5})
    --:bordercolor({0.6, 0.6 , 0.6, 0.4})
    :textcolor(cbutextoff)
    :bordercolor(cbubordoff)
    :movable(false)
    :active(true)
    :attach(compassFrame, 8, 25, 8, 5)

modeButton.Action = (function()
    return
        function()
            local obs = celestia:getobserver();
            if modeButton.Text ==_("planetarium mode") then
                -- Switch to Planetarium Mode.
                obs:goto(refObj);
                obs:gotosurface(refObj);
            else
                -- Switch to Navigation Mode.
                celestia:select(refObj);
                obs:follow(refObj);
                local fov = obs:getfov();
                obs:gotodistance(refObj, 5.5 * refObj:radius() / (fov / 0.4688), 5)
            end
        end
    end) ();