require "locale";

----------------------------------------------
-- Set initial values
----------------------------------------------
coordinatesFrameWidth, coordinatesFrameHeight = 110, 120;

cCoordinates = ctext;
coordinates_first_tick = true;

default_color = {0.7, 0.7, 1.0, 0.9};
equatorial_color = {0.63, 0.63, 0.85, 0.9};
ecliptic_color = {0.85, 0.63, 0.85, 0.9};
galactic_color = {0.85, 0.85, 0.63, 0.9};

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
coordinatesBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

coordinatesBox.Customdraw =
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cCoordinates);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("Coordinates"));
    end;

coordinatesCheck = CXBox:new()
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
        :attach(coordinatesBox, boxWidth - 40, 4, 29, 5)

coordinatesCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if coordinates_first_tick and enable_coordinates then
            coordinatesCheck.Action();
        end
        coordinates_first_tick = false;

        if selection then
            if newselection then
                -- Get Distance to Earth, RA, and Dec.
                local sel = celestia:getselection();
                local dist_to_earth = celutil.get_dist_to_earth(sel);
                if dist_to_earth < 0 then
                    disableCheckBox(coordinatesCheck);
                    cCoordinates = cchetextoff;
                else
                    enableCheckBox(coordinatesCheck);
                    cCoordinates = ctext;
                end
            end
        else
            disableCheckBox(coordinatesCheck);
            cCoordinates = cchetextoff;
        end
    end

coordinatesCheck.Action = (function()
        return
            function()
                coordinatesFrame.Visible = not(coordinatesFrame.Visible);
                if coordinatesFrame.Visible then
                    coordinatesCheck.Text = "x";
                else
                    coordinatesCheck.Text = "";
                end
            end
        end) ();

coordinatesFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:fillcolor({.2,.2,.6,.4})
    --:bordercolor({1,0,0,1})
    :movable(false)
    :clickable(false)
    :visible(false)
    :attach(screenBox, 0, height-coordinatesFrameHeight-200, width-coordinatesFrameWidth, 200)

coordinatesFrame.Customdraw =
    function(this)
        if selection then
            local sel = celestia:getselection();
            local obs = celestia:getobserver();

            local dist_to_earth = celutil.get_dist_to_earth(sel);
            if dist_to_earth >= 0 then
                -- Equatorial Coordinates (Ra, Dec).
                local ra,dec = celutil.get_ra_dec(sel);
                ra_str = format:deghms(ra);
                dec_str = format:degdms(dec);

                -- Ecliptic Coordinates (Ecliptic Long, Ecliptic Lat).
                local ecliptic_long, ecliptic_lat = celutil.get_ecliptic_long_lat(sel);
                ecliptic_long_str = format:deg(ecliptic_long);
                ecliptic_lat_str = format:deg(ecliptic_lat);

                -- Galactic Coordinates (Galactic Long, Galactic Lat).
                local galactic_long, galactic_lat = celutil.get_galactic_long_lat(sel);
                galactic_long_str = format:deg(galactic_long);
                galactic_lat_str = format:deg(galactic_lat);

                textlayout:setfont(normalfont);
                textlayout:setlinespacing(normalfont:getheight() + 1);

                textlayout:setpos(this.lb, this.tb-10);

                if celestia:getrenderflags().equatorialgrid then
                    textlayout:setfontcolor(equatorial_color);
                else
                    textlayout:setfontcolor(default_color);
                end
                textlayout:println(_("RA:")..' '..ra_str);
                textlayout:println(_("Dec:")..' '..dec_str);

                textlayout:println("");

                if celestia:getrenderflags().eclipticgrid then
                    textlayout:setfontcolor(ecliptic_color);
                else
                    textlayout:setfontcolor(default_color);
                end
                textlayout:println(_("Ecl. Long:")..' '..ecliptic_long_str);
                textlayout:println(_("Ecl. Lat:")..' '..ecliptic_lat_str);

                textlayout:println("");

                if celestia:getrenderflags().galacticgrid then
                    textlayout:setfontcolor(galactic_color);
                else
                    textlayout:setfontcolor(default_color);
                end
                textlayout:println(_("Gal. Long:")..' '..galactic_long_str);
                textlayout:println(_("Gal. Lat:")..' '..galactic_lat_str);

            end
        end
        coordinatesFrame:attach(screenBox, 0, height-coordinatesFrameHeight-200, width-coordinatesFrameWidth, 200);
    end;