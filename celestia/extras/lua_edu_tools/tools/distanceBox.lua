require "locale";

----------------------------------------------
-- Define local functions
----------------------------------------------
local ndigits = function(number)
    -- Return the number of digits in a number.
    local ndigits = 0
    while number >= 1 do
        ndigits = ndigits + 1;
        number = number/10;
    end
    return ndigits;
end

local crossProduct = function(v1, v2)
    -- Return the Vector Cross Product of two vectors.
    local vcpx = v1.y * v2.z - v1.z * v2.y;
    local vcpy = v2.x * v1.z - v1.x * v2.z;
    local vcpz = v1.x * v2.y - v1.y * v2.x;
    local vcp = celestia:newvector(vcpx, vcpy, vcpz);
    return vcp;
end

local setDistLabelStr = function(k)
    local distlabel_str = "";
    if k <= 2 then
        distlabel_str = string.format("%g", math.pow(10, k));
    else
     distlabel_str = "10^"..k;
    end
    return distlabel_str;
end

local setDistMarkerAlpha = function(marker_size_pix)
    local distMarkerAlpha = 0.9;
    if marker_size_pix < 100 then
        distMarkerAlpha = 0.9 * marker_size_pix / 100;
    end
    return distMarkerAlpha;
end

local findNewAngle = function(r, larger)
    local sel = celestia:getselection();
    local obs = celestia:getobserver();

    local o = (KM_PER_LY/1e6) * (obs:getposition() - sel:getposition());
    local d = o:length();
    local tangent_angle = math.asin(sel:radius()/d);
    local a = math.pi - tangent_angle - math.asin(d*math.sin(tangent_angle)/r);
    
    local angle1 = (2*math.asin(d*math.cos(a)/math.sqrt(o.x*o.x + o.z*o.z))-(math.abs(o.x)/o.x)*math.pi+2*(math.atan(o.z/o.x)))/2;
    local angle2 = -1*(2*math.asin(d*math.cos(a)/math.sqrt(o.x*o.x + o.z*o.z))+(math.abs(o.x)/o.x)*math.pi-2*(math.atan(o.z/o.x)+math.pi))/2;

    if larger then
        return angle1;
    else
        return angle2;
    end
end

-- Draw distance square-markers in the observer's plane (centered on screen).
local drawDistMarkerInObsPlane = function(marker_size)
    local sel = celestia:getselection();
    local obs = celestia:getobserver();

    local distFov = obs:getfov();
    local distFovRatio = math.tan(distFovCoeff/2)/math.tan(distFov/2);

    local obs_direction = (celutil.rotation_transform(celestia:newvector(0,0,-1),obs:getorientation())):normalize();
    local obs_sel = (KM_PER_LY/1e6) * (sel:getposition() - obs:getposition());
    local dist_to_sel = celutil.get_dist(obs, sel);

    local obs_sel_angle = math.atan(marker_size/dist_to_sel);
    local a = 2*height*distFovRatio*math.tan(obs_sel_angle);
    local centerX, centerY = width/2, height/2;
    
    -- Draw distance square markers
    gl.Vertex(centerX-a, centerY-a);
    gl.Vertex(centerX-a, centerY+a);
    gl.Vertex(centerX+a, centerY+a);
    gl.Vertex(centerX+a, centerY-a);

    -- Set distance label position.
    distLabelXPos, distLabelYPos = centerX + a + 5, centerY+a+5;
end

-- Draw distance circle-markers in the ecliptic plane (centered on the current selection).
-- TODO: Optimize the rendering of distance circle-markers using the symmetry of ellipse.
local drawDistMarkerInEclipticPlane = function(marker_size)
    local sel = celestia:getselection();
    local sel_pos  = sel:getposition();
    local obs = celestia:getobserver(); 
    local obs_sel_vect = (KM_PER_LY/1e6) * (sel:getposition() - obs:getposition());
    local obs_direction = (celutil.rotation_transform(celestia:newvector(0, 0, -1), obs:getorientation())):normalize();
    local obs_side = (celutil.rotation_transform(celestia:newvector(1, 0, 0), obs:getorientation())):normalize();
    local obs_up = (celutil.rotation_transform(celestia:newvector(0, 1, 0), obs:getorientation())):normalize();
    local sel_radius = sel:radius();
    local dist_to_sel = celutil.get_dist(obs,sel);
    local sel_app_angle = math.asin(sel_radius/dist_to_sel);

    local distFov = obs:getfov();
    local distFovRatio = math.tan(distFovCoeff/2)/math.tan(distFov/2);

    local last_angle =  math.pi;
    local last_horizontal_angle = math.pi;

    local centerX, centerY = width/2, height/2;

    local infront_sel = false;
    local repeat_infront = false;
    
    local uframe = celestia:newframe("universal");
    local pos0 = celestia:newposition(0,0,0);
    angle_step = 360 / distance_marker_sample_points;

    for angle = -180, 180, angle_step do
        vectorX = marker_size * math.cos(angle * degToRad);
        vectorY = 0;
        vectorZ = marker_size * math.sin(angle * degToRad);
        vector = uframe:from(celestia:newposition(vectorX, vectorY, vectorZ)) - pos0;
        vertex = (obs_sel_vect + vector):normalize();
        obs_sel_angle = math.acos(vertex * obs_direction);
        projection = crossProduct(obs_direction, crossProduct(vertex, obs_direction)):normalize();

        horizontal_angle = math.acos(projection * obs_side);
        if math.acos(projection * obs_up) > math.pi/2 then
            horizontal_angle = -horizontal_angle;
        end
        if obs_sel_angle > math.pi/2 then
            obs_sel_angle = math.pi/2;
        end

        infront_sel = math.acos(vertex * (obs_sel_vect:normalize())) < sel_app_angle and (obs_sel_vect + vector):length() > obs_sel_vect:length();

        --if angle == -180 then
            --repeat_infront = infront_sel;
        --end

        if infront_sel ~= repeat_infront then
            new_angle = findNewAngle(marker_size, repeat_infront);

            vectorX = marker_size * math.cos(new_angle);
            vectorY = 0;
            vectorZ = marker_size * math.sin(new_angle);

            vector = uframe:from(celestia:newposition(vectorX, vectorY, vectorZ)) - celestia:newposition(0,0,0);
            vertex = (obs_sel_vect + vector):normalize();
            new_obs_sel_angle = math.acos(vertex * obs_direction);
            projection = crossProduct(obs_direction, crossProduct(vertex, obs_direction)):normalize();

            new_horizontal_angle = math.acos(projection * obs_side);
            if math.acos(projection * obs_up) > math.pi/2 then
                new_horizontal_angle = -new_horizontal_angle;
            end
            if new_obs_sel_angle > math.pi/2 then
                new_obs_sel_angle = math.pi/2;
            end

            if repeat_infront then
                last_angle = new_obs_sel_angle;
                last_horizontal_angle = new_horizontal_angle;
            else
                obs_sel_angle = new_obs_sel_angle;
                horizontal_angle = new_horizontal_angle;
            end

            repeat_infront = not(repeat_infront);
            infront_sel = false;
        end

        if last_angle < math.pi and not(infront_sel) then
            local a = 2 * height * distFovRatio * math.tan(obs_sel_angle);
            local b = 2 * height * distFovRatio * math.tan(last_angle);
            local x1 = a * math.cos(horizontal_angle);
            local y1 = a * math.sin(horizontal_angle);
            local x2 = b * math.cos(last_horizontal_angle);
            local y2 = b * math.sin(last_horizontal_angle);

            gl.Vertex(centerX + x1,    centerY + y1);
            gl.Vertex(centerX + x2,    centerY + y2);

            --if angle >= 180 - angle_step then
                distLabelXPos = centerX + x1 + 5;
                distLabelYPos = centerY + y1 + 5;
            --end
        else
                distLabelXPos = nil;
                distLabelYPos = nil;
        end

        last_angle = obs_sel_angle;
        last_horizontal_angle = horizontal_angle;
    end
end

-- Draw distance markers.
local drawDistanceMarker = function(marker_size, unit_str, k)
    local obs = celestia:getobserver();
    local distFov = obs:getfov();
    local pix_size = 2 * math.tan(distFov / 2) / height;
    local sel = celestia:getselection();
    local dist_to_sel = celutil.get_dist(obs, sel);

    local marker_size_pix = marker_size / (dist_to_sel * pix_size);
    if marker_size_pix > 10 and marker_size_pix < (6 * height) then
        distMarkerAlpha[k] = setDistMarkerAlpha(marker_size_pix);
        distMarkerColor = {cdistmark[1], cdistmark[2], cdistmark[3], cdistmark[4] * distMarkerAlpha[k]}

        if celestia:getrenderflags().smoothlines then
            enableSmoothLines();
        end

        if (distance_marker_mode == "ecliptic" or distance_marker_mode == "both") and (k < 5 or unit_str ~= "ly") then
            gl.Color(distMarkerColor[1], distMarkerColor[2], distMarkerColor[3], distMarkerColor[4] * alpha * opacity);
            gl.Disable(gl.TEXTURE_2D);
            gl.Begin(gl.LINES);
            drawDistMarkerInEclipticPlane(marker_size);
            gl.End();

            if distLabelXPos and distLabelYPos then
                distlabel_str = setDistLabelStr(k);
                textlayout:setfont(normalfont);
                textlayout:setfontcolor(distMarkerColor);
                textlayout:setpos(distLabelXPos, distLabelYPos);
                if k <= 2 then
                    textlayout:println(string.format("%g", math.pow(10, k))..' '.._(unit_str));
                else
                    textlayout:println("10 "..'  '.._(unit_str));
                    textlayout:setfont(smallfont);
                    textlayout:setpos(distLabelXPos + 14, distLabelYPos + 8);
                    textlayout:println(k);
                end
            end
        end

        if distance_marker_mode == "observer" or distance_marker_mode == "both" then
            gl.Color(distMarkerColor[1], distMarkerColor[2], distMarkerColor[3], distMarkerColor[4] * alpha * opacity);
            gl.Disable(gl.TEXTURE_2D);
            gl.Begin(gl.LINE_LOOP);
            drawDistMarkerInObsPlane(marker_size);
            gl.End();

            if distLabelXPos and distLabelYPos then
                distlabel_str = setDistLabelStr(k);
                textlayout:setfont(normalfont);
                textlayout:setfontcolor(distMarkerColor);
                textlayout:setpos(distLabelXPos, distLabelYPos);
                if k <= 2 then
                    textlayout:println(string.format("%g", math.pow(10, k))..' '.._(unit_str));
                else
                    textlayout:println("10 "..'  '.._(unit_str));
                    textlayout:setfont(smallfont);
                    textlayout:setpos(distLabelXPos + 14, distLabelYPos + 8);
                    textlayout:println(k);
                end
            end
        end

        if celestia:getrenderflags().smoothlines then
            disableSmoothLines();
        end

    end
end

----------------------------------------------
-- Set initial values
----------------------------------------------
cDistance = ctext;
distance_first_tick = true;

-- Set the distance markers sample points.
distance_marker_sample_points = 90;

distMarkerAlpha = {};

local distZoomToRad = 0.234;
distFovCoeff = 2/3*math.pi*distZoomToRad ;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
distanceBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

distanceBox.Customdraw =
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cDistance);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("Distances"));
    end;

distanceCheck = CXBox:new()
        :init(0, 0, 0, 0)
        :bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(smallfont)
        :textcolor(cbutextoff)
        :textpos("center")
        :movetext(0, 9)
        :text("")
        :movable(false)
        :active(true)
        :attach(distanceBox, boxWidth - 40, 4, 29, 5)

distanceCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if distance_first_tick then
            if distance_state == 1 then
                distanceCheck.Text = "";
            elseif distance_state == 2 then
                distanceCheck.Text = "1";
            elseif distance_state == 3 then
                distanceCheck.Text = "2";
            else
                distanceCheck.Text = "3";
            end
            distanceCheck.Action();
        end
        distance_first_tick = false;

        -- Get number of views.
        local tobs = celestia:getobservers()
        local nobs = table.getn(tobs)
        if nobs > 1 then
            -- Disable distance markers in multiple views layout.
            disableCheckBox(distanceCheck);
            cDistance = cchetextoff;
            distanceFrame.Visible = false;
        else
            enableCheckBox(distanceCheck);
            cDistance = ctext;
            if distanceCheck.Text ~= "" then
                distanceFrame.Visible = true;
            end
        end
    end

distanceCheck.Action = (function()
        return
            function()
                if distanceCheck.Text == "" then
                    distanceFrame.Visible = true;
                    distanceCheck.Text = "1";
                    distance_marker_mode = "observer";
                elseif distanceCheck.Text == "1" then
                    distanceCheck.Text = "2";
                    distance_marker_mode = "ecliptic";
                elseif distanceCheck.Text == "2" then
                    distanceCheck.Text = "3";
                    distance_marker_mode = "both"
                elseif distanceCheck.Text == "3"  then
                    distanceFrame.Visible = false;
                    distanceCheck.Text = "";
                end
            end
        end) ();

distanceFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:fillcolor({.2,.2,.6,.4})
    --:bordercolor({1,0,0,1})
    :active(false)
    :movable(false)
    :clickable(true)
    :visible(false)
    :attach(screenBox, 0, 0, width, height)

distanceFrame.Customdraw =
    function(this)
        local sel = celestia:getselection();
        local sel_radius = sel:radius();

        for k = ndigits(sel_radius * 1e3), 2 do
            -- Set the size of the "m" distance markers in pixel.
            local m_size = math.pow(10, k) * 1e-3;
            -- Draw the "m" distance markers.
            drawDistanceMarker(m_size, "m", k)
        end

        for k = ndigits(sel_radius), 8 do
            -- Set the size of the "km" distance markers in pixel.
            local km_size = math.pow(10, k);
            -- Draw the "km" distance markers.
            drawDistanceMarker(km_size, "km", k)
        end

        for k = ndigits(sel_radius / KM_PER_AU), 3 do
            -- Set the size of the "AU" distance markers in pixel.
            local au_size = math.pow(10, k) * KM_PER_AU;
            -- Draw the "AU" distance markers.
            drawDistanceMarker(au_size, "AU", k)
        end

        for k = ndigits(sel_radius / KM_PER_LY), 9 do
            -- Set the size of the "ly" distance markers in pixel.
            local ly_size = math.pow(10, k) * KM_PER_LY;
            -- Draw the "ly" distance markers.
            drawDistanceMarker(ly_size, "ly", k)
        end

        -- Keep the size of distanceFrame null. Otherwise, active buttons
        -- wouldn't work when distanceFrame is drawn in front of them.
        distanceFrame:attach(screenBox, 0, 0, width, height)
    end;