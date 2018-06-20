require "locale";

----------------------------------------------
-- Load images.
----------------------------------------------


local HRImage = celestia:loadtexture("../images/HR.png");
local HRButton1 = celestia:loadtexture("../images/button1.png");
local HRButton2 = celestia:loadtexture("../images/button2.png");

--[[HRImageFilename = "../locale/"..lang.."/images/HR_"..lang..".png";
HRImage = celestia:loadtexture(HRImageFilename);
if not HRImage then
    HRImageFilename = "../images/HR.png";
    HRImage = celestia:loadtexture(HRImageFilename);
end]]

----------------------------------------------
-- Define local functions
----------------------------------------------
local drawHRMarker = function(x, y, co, s)
    gl.Disable(gl.TEXTURE_2D);
    gl.Begin(gl.QUADS);
    gl.Color(co[1], co[2], co[3], co[4] * alpha * opacity);
    local r = s / 2;
    local i, d = math.modf(r);
    if d == 0.5 then
        x = x + 0.5;
        y = y - 0.5;
    end
    gl.Vertex(x+r, y-r);
    gl.Vertex(x+r, y+r);
    gl.Vertex(x-r, y+r);
    gl.Vertex(x-r, y-r);
    gl.End();
end

local getHRColor = function(dx)
    local white_coef = 0.00608508;
    local lambda = (2^(white_coef * dx) - 2^(white_coef * 66.5)) / (2^(white_coef * 430) - 2^(white_coef * 66.5));
    local red = 2 * lambda;
    local green = 4 * (1 - lambda) * lambda;
    local blue = 2 * (1 - lambda);
    return {red, green, blue, 1}
end

local getHRCandidate = function(obj)
    local candidate = nil;
    local objtype = obj:type();
    local objspectral = obj:spectraltype();
    if objtype == "star" and objspectral ~= "X" then
        candidate = obj;
     end
    return candidate;
end

local getHRValues = function(HR_t)
    local HR_x_t = {};
    local HR_y_t = {};
    local HR_co_t = {};
    for k, starname in pairs(HR_t) do
        star = celestia:find(starname);
        star_info_t = star:getinfo();
        star_temp = star_info_t.temperature;
        star_abs_mag = star_info_t.absoluteMagnitude;
        if star_temp and star_abs_mag then
            HR_x_t[k] = math.floor(446 - 95 * (math.log(star_temp / 2500) / math.log(2)));
            HR_y_t[k] = math.floor(316 - 12 * star_abs_mag);
            HR_co_t[k] = getHRColor(HR_x_t[k]);
        end
    end
    return HR_x_t, HR_y_t, HR_co_t;
end

local withinFrame = function(dx, dy)
    return dx > 67 and dx < 446 and dy > 66 and dy < 446;
end

----------------------------------------------
-- Set initial values
----------------------------------------------
local newwidth, newheight;
local HRFrameWidth, HRFrameHeight = 512, 512;

local cHR = ctext;
local HR_first_tick = true;
local display_HR = false;
local HR_star_tables_loaded = false;
local HR_step = 1;

local HR_obj;

HR_stars_t = {};
HR_Title = {};
HR_LabelOn = {};
HR_PointSize = {};

local HR_x = {};
local HR_y = {};
local HR_co = {};

local buildHRStarTable = function()
    local HR_iter = 1;
    local HR_iter_done = false;
    repeat
        HR_stars_t[HR_iter] = {};
        HR_x[HR_iter] = {};
        HR_y[HR_iter] = {};
        HR_co[HR_iter] = {};
        if pcall( function() require ("HR_stars_"..HR_iter) end ) then
            HR_x[HR_iter], HR_y[HR_iter], HR_co[HR_iter] = getHRValues(HR_stars_t[HR_iter]);
            if not HR_Title[HR_iter] then
                HR_Title[HR_iter] = "";
            end
            if not HR_PointSize[HR_iter] then
                HR_PointSize[HR_iter] = 2;
            end
            HR_step_max = HR_iter;
            celestia:log("Loading HR star table "..HR_iter)
        else
            HR_iter_done = true;
        end
        HR_iter = HR_iter + 1
    until HR_iter_done == true;
end

local HR_x_obj;
local HR_y_obj;
local HR_co_obj;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
HRBox = CXBox:new()
    --:bordercolor(cbubordoff)
    :init(0, 0, 0, 0)
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

HRBox.Customdraw = function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cHR);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("HR Diagram"));
    end;

HRCheck = CXBox:new()
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
        :attach(HRBox, boxWidth - 40, 4, 29, 5)

HRCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if HR_first_tick and enable_HR then
            HRCheck.Action();
            display_HR = true;
        end
        HR_first_tick = false;

        if selection then
            if newselection then
                HR_step = 1;
                HR_x_obj = nil;
                HR_y_obj = nil;
                HR_co_obj = nil;
                local sel = celestia:getselection();
                HR_obj = getHRCandidate(sel)
                if not HR_obj then
                    disableCheckBox(HRCheck);
                    cHR = cchetextoff;
                    if HRFrame.Visible then
                        HRFrame.Visible = false;
                    end
                else
                    enableCheckBox(HRCheck);
                    cHR = ctext;
                    if display_HR and not HRFrame.Visible then
                        HRFrame.Visible = true;
                    end
                end
            end
        else
            disableCheckBox(HRCheck);
            cHR = cchetextoff;
            if HRFrame.Visible then
                HRFrame.Visible = false;
            end
        end
    end

HRCheck.Action = (function()
        return
            function()
                display_HR = not display_HR;
                if display_HR then
                    HRFrame.Visible = true;
                    HRCheck.Text = "x";
                else
                    HRFrame.Visible = false;
                    HRCheck.Text = "";
                end
            end
        end) ();

HRFrame = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor({0.9, 0.9, 0.9, 0.25})
    :fillimage(HRImage)
    :textfont(titlefont)
    :textcolor({0.8, 0.8, 0.8, 0.9})
    :textpos("center")
    :movetext(0, -10)
    :text(_("Hertzsprung-Russell Diagram"))
    :movable(true)
    :clickable(false)
    :visible(false)
    :attach(screenBox, (width-HRFrameWidth)/2, height-HRFrameHeight-2, (width-HRFrameWidth)/2, 2)

HRFrame.Customdraw = function(this)
        if not HR_star_tables_loaded then
            HR_star_tables_loaded = true;
            buildHRStarTable();
        end
        if HR_obj then
            if not HR_x_obj then
                local temp = HR_obj:getinfo().temperature;
                local abs_mag = HR_obj:getinfo().absoluteMagnitude;
                HR_x_obj = math.floor(446 - 95 * (math.log( temp / 2500) / math.log(2)));
                HR_y_obj = math.floor(316 - 12 * abs_mag);
                HR_co_obj = getHRColor(HR_x_obj);
            end

            if HR_x[HR_step][1] then
                local psize = math.ceil(HR_PointSize[HR_step]);
                for k, dx in pairs(HR_x[HR_step]) do
                    local dy = HR_y[HR_step][k];
                    local co = HR_co[HR_step][k];
                    if withinFrame(dx, dy) then
                        drawHRMarker(this.lb + dx, this.bb + dy, co, psize);
                        if HR_LabelOn[HR_step] then
                            textlayout:setfont(normalfont);
                            textlayout:setpos(this.lb + dx + 5, this.bb + dy);
                            textlayout:setfontcolor(co);
                            textlayout:println(HR_stars_t[HR_step][k]);
                        end
                    end
                end
                textlayout:setfont(normalfont);
                textlayout:setpos(this.lb+75, this.bb+77);
                textlayout:setfontcolor({0.8, 0.8, 0.8, 0.9});
                textlayout:println(_(HR_Title[HR_step]).." ["..#HR_stars_t[HR_step]..']');
            end

            if HR_obj:spectraltype() == "Bary" then
                textlayout:setfont(normalfont);
                textlayout:setpos(this.lb+75, this.bb+92);
                textlayout:setfontcolor({1, 0.5, 0.5, 0.8});
                textlayout:println(_("The selected object is a stellar barycenter."));
            elseif not withinFrame(HR_x_obj, HR_y_obj) then
                textlayout:setfont(normalfont);
                textlayout:setpos(this.lb+75, this.bb+92);
                textlayout:setfontcolor({1, 0.5, 0.5, 0.8});
                textlayout:println(_("The selected star is out of frame."));
            else
                drawHRMarker(this.lb + HR_x_obj, this.bb + HR_y_obj, {0, 0.7, 0, 1}, 8);
                drawHRMarker(this.lb + HR_x_obj, this.bb + HR_y_obj, {0, 0, 0, 1}, 6);
                drawHRMarker(this.lb + HR_x_obj, this.bb + HR_y_obj, HR_co_obj, 4);
            end
        end

                textlayout:setfont(normalfont);
                textlayout:setpos(this.lb+20, this.tb-55);
                textlayout:setfontcolor(ctext);
                textlayout:println(_("Lum."));
                textlayout:setpos(this.rb-60, this.tb-55);
                textlayout:println(_("Abs. Mag."));
                textlayout:setpos(this.rb-58, this.bb+50);
                textlayout:printinbox(_("Temp. (K)"), this, 0, 225);

        if newwidth ~= width or newheight ~= height then
            newwidth, newheight = width, height;
            HRFrame:attach(screenBox, (width-HRFrameWidth)/2, height-HRFrameHeight-2, (width-HRFrameWidth)/2, 2)
        end
    end;

HRPreviousButton = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({0.9, 0.7, 0.7, 1})
    :fillimage(HRButton1)
    :movable(false)
    :active(true)
    :clickable(false)
    :visible(true)
    :attach(HRFrame, 0, 0, HRFrameWidth - 40, HRFrameHeight - 40)

HRPreviousButton.Action = (function()
        return
            function()
                if HR_step > 1 then
                    HR_step = HR_step - 1;
                end
            end
        end) ();

HRNextButton = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({0.9, 0.7, 0.7, 1})
    :fillimage(HRButton2)
    :movable(false)
    :active(true)
    :clickable(false)
    :visible(true)
    :attach(HRFrame, HRFrameWidth - 40, 0, 0, HRFrameHeight - 40)

HRNextButton.Action = (function()
        return
            function()
                HR_step = HR_step + 1;
                if HR_step > HR_step_max then
                    HR_step = 1;
                end
            end
        end) ();
