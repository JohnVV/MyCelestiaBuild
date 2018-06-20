require "locale";
require "closeButton";

----------------------------------------------
-- Load images.
----------------------------------------------
timeRevImage = celestia:loadtexture("../images/time_rev_button.png");
time1xImage = celestia:loadtexture("../images/time_1x_button.png");
timeDiv2Image = celestia:loadtexture("../images/time_div2_button.png");
timeDiv10Image = celestia:loadtexture("../images/time_div10_button.png");
timeMult2Image = celestia:loadtexture("../images/time_mult2_button.png");
timeMult10Image = celestia:loadtexture("../images/time_mult10_button.png");
timeCurImage = celestia:loadtexture("../images/time_cur_button.png");

----------------------------------------------
-- Define local functions
----------------------------------------------
local setDateColorsOff = function()
    daycolor = cbutextoff;
    monthcolor = cbutextoff;
    yearcolor = cbutextoff;
    hourcolor = cbutextoff;
    minutecolor = cbutextoff;
    secondcolor = cbutextoff;
    timezonecolor = cbutextoff;
end

local setCurrentTime = function()
    local UTCtime = os.date("!*t");
    celestia:settime(celestia:utctotdb(UTCtime.year, UTCtime.month, UTCtime.day, UTCtime.hour, UTCtime.min, UTCtime.sec));
end

local setTime = function()
    celestia:settime(celestia:utctotdb(date.year, date.month, date.day, date.hour, date.minute, date.seconds));
end

----------------------------------------------
-- Set initial values
----------------------------------------------
-- Define a limit value for timescale.
-- This shouldn't be necessary but timerate strangely
-- keeps on increasing when time reaches limit values...
limitTimerate = 1e15;

-- Define max/min values for time to avoid bugs with Julian days...
maxTime = 730486721060.00073; -- 2000000000 Jan 01 12:00:00 UTC
minTime = -730498278941.99951; -- -2000000000 Jan 01 12:00:00 UTC

setDateColorsOff();
daycolor = cbutexton;
toset = "day";

-- Get displayUTCtime value from 'config.lua'.
displayUTCtime = not(show_local_time);

-- Get timezone_cfg value from 'config.lua'.
timezone_cfg = time_zone;

timescale = celestia:gettimescale();
paused = celestia:ispaused();

setTimeFrameW, setTimeFrameH = 144, 70;
setTimescaleButtonW = (boxWidth - 16) / 7

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
timeBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 0, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

timeButtonFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 0, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(timeBox, 0, 0, 0, 51);

timeButtonFrame.Customdraw =
    function(this)
        timeButtonFrame:attach(timeBox, 0, 0, 0, 51);
    end;

timeFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({0, 1, 0, 1})
    --:fillcolor({.2,.2,.6,.2})
    :movable(false)
    :attach(timeBox, 0, 47, 0, 0);

timeFrame.Customdraw =
    function(this)
        local time = celestia:gettime();
        local timescale = celestia:gettimescale();
        -- Fix max/min time values.
        if time <= minTime then
            celestia:settime(minTime);
            celestia:settimescale(0);
        elseif time >= maxTime then
            celestia:settime(maxTime);
            celestia:settimescale(0);
        end
        -- Convert Celestia's internal TDB time to UTC date table.
        date = celestia:tdbtoutc(time);
        -- Get OS time in seconds from the UTC date table.
        local systime = os.time{year=date.year, month=date.month, day=date.day, hour=date.hour, min=date.minute, sec=date.seconds};
        if systime then
            -- Get the local date table from OS.
            local syslocdate  = os.date("*t", systime + 3600);
            -- Get the UTC date from OS.
            local sysUTCdate = os.date("!*t", systime + 3600);
            -- Compute the system locale Time Zone.
            local daydiff = syslocdate.day - sysUTCdate.day;
            local hourdiff;
            if daydiff == 0 then
                hourdiff = 0;
            elseif daydiff > 1 or daydiff == -1 then
                hourdiff = -24;
            else
                hourdiff = 24;
            end
            timezone = hourdiff + syslocdate.hour - sysUTCdate.hour + (syslocdate.min - sysUTCdate.min) / 60;
            -- HACK: Get the local date table from the 'modified' TDB time using Celestia's 'tdbtoutc' function.
            locdate = celestia:tdbtoutc(time + timezone/24);
        end
        -- Set Time Zone string
        if displayUTCtime or not(systime) then
            timezone_str = "UTC";
            day_str = math.abs(date.day); month_str = monthAbbr[math.abs(date.month)]; year_str = date.year;
            hour_str = format:twodigits(math.abs(date.hour)); min_str = format:twodigits(math.abs(date.minute));
            sec_str = format:twodigits(math.floor(math.abs(date.seconds)));
        elseif type(time_zone) == "number" then
            -- A Time Zone value has been set in config.lua.
            date_cfg = celestia:tdbtoutc(time + timezone_cfg/24)
            timezone_str = "GMT"..string.format("%+0.0f", math_sign(timezone_cfg) * math.floor(math.abs(timezone_cfg)));
            if math.floor(timezone_cfg) ~= timezone_cfg then
                -- Timezone is an non-integer number of hours.
                timezone_str = timezone_str.._("h")..(math.abs(timezone_cfg) - math.floor(math.abs(timezone_cfg))) * 60;
            end
            day_str = date_cfg.day; month_str = monthAbbr[date_cfg.month]; year_str = date_cfg.year;
            hour_str = format:twodigits(date_cfg.hour); min_str = format:twodigits(date_cfg.minute); sec_str = format:twodigits(math.floor(date_cfg.seconds));
        else
            -- Use system locale Time Zone.
            timezone_str = "GMT"..string.format("%+0.0f", math_sign(timezone) * math.floor(math.abs(timezone)));
            if math.floor(timezone) ~= timezone then
                -- Timezone is an non-integer number of hours.
                timezone_str = timezone_str.._("h")..(math.abs(timezone)-math.floor(math.abs(timezone)))*60;
            end
            day_str = locdate.day; month_str = monthAbbr[locdate.month]; year_str = locdate.year;
            hour_str = format:twodigits(locdate.hour); min_str = format:twodigits(locdate.minute); sec_str = format:twodigits(math.floor(locdate.seconds));
        end
        -- Set Date string. Use date format from the locale/lang/lang.lua file.
        if date_format == "year/month/day" then
            -- Big endian format.
            date_str = year_str..' '..month_str..' '..day_str;
        elseif date_format == "month/day/year" then
            -- Middle endian format.
            date_str = month_str..' '..day_str..' '..year_str;
        else
            -- Little endian format (default).
            date_str = day_str..' '..month_str..' '..year_str;
        end
        -- Set Time string.
        time_str = hour_str..':'..min_str..':'..sec_str;
        -- Set Timerate string.
        if celestia:ispaused() then
            -- Time is paused
            timescale_str = "";
            textlayout:setfontcolor(ctextalert);
            textlayout:setpos(this.lb+7+normalfont:getwidth(_("Rate:"))+5, this.tb-45);
            textlayout:println(_("(paused)"));
            textlayout:setfontcolor(ctext);
        elseif math.abs(timescale) <= 1e-15 then
            -- Time is stopped.
            timescale_str = _("time stopped");
        else
            timescale_str = string.format("%g", timescale).."x";
        end
        -- Display Date, Time, Timerate, Timezone.
        textlayout:setfont(normalfont);
        textlayout:setlinespacing(normalfont:getheight());
        textlayout:setfontcolor(ctext);
        textlayout:setpos(this.lb+7, this.tb-15);
        textlayout:println(date_str);
        textlayout:setpos(this.lb+7, this.tb-30);
        textlayout:println(time_str);
        textlayout:setpos(this.lb+58, this.tb-30);
        textlayout:println(timezone_str);
        --textlayout:println(_("JD :").. ' '..time);
        textlayout:setpos(this.lb+7, this.tb-45);
        textlayout:println(_("Rate:").." "..timescale_str);

        timeFrame:attach(timeBox, 0, 47, 0, 0);
    end;

timescaleButtonFrame = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    --:textfont(normalfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text(_("Current Time"))
    :movable(false)
    --:active(true)
    :attach(timeButtonFrame, 8, 28, 8, 4)

revTimeButton = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(timeRevImage)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text("<>")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2, 0, 6 * setTimescaleButtonW, 0)

revTimeButton.Action = (function()
    return
        function()
            celestia:settimescale(-celestia:gettimescale());
        end
    end) ();

divTimeBy10Button = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(timeDiv10Image)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text("/10")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2 + setTimescaleButtonW, 0, 5 * setTimescaleButtonW, 0)

divTimeBy10Button.Action = (function()
    return
        function()
            celestia:settimescale(celestia:gettimescale() / 10);
        end
    end) ();

divTimeBy2Button = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(timeDiv2Image)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text("/2")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2 + 2 * setTimescaleButtonW, 0, 4 * setTimescaleButtonW, 0)

divTimeBy2Button.Action = (function()
    return
        function()
            celestia:settimescale(celestia:gettimescale() / 2);
        end
    end) ();

realTimeButton = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(time1xImage)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text(">")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2 + 3 * setTimescaleButtonW, 0, 3 * setTimescaleButtonW, 0)

realTimeButton.Action = (function()
    return
        function()
            celestia:settimescale(1);
        end
    end) ();

multTimeBy2Button = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(timeMult2Image)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    :text("x2")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2 + 4 * setTimescaleButtonW, 0, 2 * setTimescaleButtonW, 0)

multTimeBy2Button.Action = (function()
    return
        function()
            celestia:settimescale(celestia:gettimescale() * 2);
            if celestia:gettimescale() >= limitTimerate then
                celestia:settimescale(limitTimerate);
            end
        end
    end) ();

multTimeBy10Button = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(timeMult10Image)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text("x10")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2 + 5 * setTimescaleButtonW, 0, setTimescaleButtonW, 0)

multTimeBy10Button.Action = (function()
    return
        function()
            celestia:settimescale(celestia:gettimescale() * 10);
            if celestia:gettimescale() >= limitTimerate then
                celestia:settimescale(limitTimerate);
            end
        end
    end) ();

currentTimeButton = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillimage(timeCurImage)
    --:textfont(smallfont)
    --:textcolor(cbutextoff)
    --:textpos("center")
    --:movetext(0, 6)
    --:text("x10")
    :visible(true)
    :active(true)
    :attach(timescaleButtonFrame, 2 + 6 * setTimescaleButtonW, 0, 3, 0)

currentTimeButton.Action = (function()
    return
        function()
            setCurrentTime();
        end
    end) ();

setTimeButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Set Time"))
    :movable(false)
    :active(true)
    :attach(timeButtonFrame, 8, 8, 8, 24)

setTimeButton.Action = (function()
    return
        function()
            setTimeFrame.Visible = not(setTimeFrame.Visible);
            if not(setTimeFrame.Visible) then
                setTimeButton.Bordercolor = cbubordoff;
                setTimeButton.Fillcolor = nil;
            else
                setTimeButton.Bordercolor = cbubordon;
                setTimeButton.Fillcolor = {cbubordon[1]*2/3, cbubordon[2]*2/3, cbubordon[3]*2/3, cbubordon[4]/2};
            end
        end
    end) ();

setTimeFrame = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :fillcolor(csetbofill)
    :visible(false)
    :active(false)
    :attach(timeBox, -setTimeFrameW, 98-setTimeFrameH-8, boxWidth - 1, 8)

setTimeFrame.Customdraw =
    function(this)
        -- We add the closeButton on the second tick
        -- when bounds are getting updated.
        if setTime_firstTickDone then
            if not(setTimeCloseButtonDone) then
                setTimeCloseButtonDone = true;
                makeCloseButton(setTimeCloseButton, setTimeFrame, setTimeButton);
            end
        else
            setTime_firstTickDone = true;
        end
    end;

dayBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 5, setTimeFrameH-16, 125, 0)

dayBox.Customdraw =
    function(this)
        textlayout:setfontcolor(daycolor);
        textlayout:printinbox(day_str, dayBox, 0, -2);
    end;

dayBox.Action = (function()
    return
        function()
            toset = "day";
            setDateColorsOff();
            daycolor = cbutexton;
        end
    end) ();
    
monthBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 20, setTimeFrameH-16, 97, 0)

monthBox.Customdraw =
    function(this)
        textlayout:setfontcolor(monthcolor);
        textlayout:printinbox(month_str, monthBox, 0, -2);
    end;

monthBox.Action = (function()
    return
        function()
            toset = "month";
            setDateColorsOff();
            monthcolor = cbutexton;
        end
    end) ();
    
yearBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :textfont(normalfont)
    :textcolor(yearcolor)
    :movetext(-3, 4)
    :text("")
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 48, setTimeFrameH-16, 40, 0)

yearBox.Customdraw =
    function(this)
        --textlayout:setfontcolor(yearcolor);
        --textlayout:printinbox(year_str, yearBox, -1, -2);
        yearBox.Textcolor = yearcolor;
        yearBox.Text = year_str;
    end;

yearBox.Action = (function()
    return
        function()
            toset = "year";
            setDateColorsOff();
            yearcolor = cbutexton;
        end
    end) ();

hourBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 5, setTimeFrameH-30, 121, 16)

hourBox.Customdraw =
    function(this)
        textlayout:setfontcolor(hourcolor);
        textlayout:printinbox(hour_str..":", hourBox, 0, -2);
    end;

hourBox.Action = (function()
    return
        function()
            toset = "hour";
            setDateColorsOff();
            hourcolor = cbutexton;
        end
    end) ();

minuteBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 24, setTimeFrameH-30, 102, 16)

minuteBox.Customdraw =
    function(this)
        textlayout:setfontcolor(minutecolor);
        textlayout:printinbox(min_str..":", minuteBox, 0, -2);
    end;

minuteBox.Action = (function()
    return
        function()
            toset = "minute";
            setDateColorsOff();
            minutecolor = cbutexton;
        end
    end) ();

secondBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 43, setTimeFrameH-30, 86, 16)

secondBox.Customdraw =
    function(this)
        textlayout:setfontcolor(secondcolor);
        textlayout:printinbox(sec_str, secondBox, 0, -2);
    end;

secondBox.Action = (function()
    return
        function()
            toset = "seconds";
            setDateColorsOff();
            secondcolor = cbutexton;
        end
    end) ();

timeZoneBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :visible(true)
    :active(true)
    :attach(setTimeFrame, 64, setTimeFrameH-30, 15, 16)

timeZoneBox.Customdraw =
    function(this)
        textlayout:setfontcolor(timezonecolor);
        local dx = (timeZoneBox:size()-normalfont:getwidth(timezone_str))/2;
        textlayout:printinbox(timezone_str, timeZoneBox, -dx, -2);
    end;

timeZoneBox.Action = (function()
    return
        function()
            toset = "";
            displayUTCtime = not(displayUTCtime);
            setDateColorsOff();
            timezonecolor = cbutexton;
        end
    end) ();

jdBox = CXBox:new()
    --:bordercolor({0.2, 0.2 , 0.6, 0.6})
    :textfont(normalfont)
    :textcolor({cbutextoff[1], cbutextoff[2], cbutextoff[3], cbutextoff[4]*0.6})
    :movetext(0, 6)
    :text("")
    :visible(true)
    :attach(setTimeFrame, 2, setTimeFrameH-50, 5, 36)

jdBox.Customdraw =
    function(this)
        local jdUTCtime = celestia:tojulianday(date.year, date.month, date.day, date.hour, date.minute, date.seconds);
        jdBox.Text = _("JD:")..string.format(" %0.5f", jdUTCtime);
    end;

setTimePreviousButton = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillcolor(cslidebofill)
    :textfont(smallfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 8)
    :text("<")
    :attach(setTimeFrame, setTimeFrameW-15-20, 2, 20, setTimeFrameH-2-12)
    :visible(true)
    :active(true)

setTimePreviousButton.Action = (function()
    return
        function()
            date[toset] = date[toset]-1;
            setTime();
        end
    end) ();

setTimeNextButton = CXBox:new()
    --:bordercolor(cbubordoff)
    :fillcolor(cslidebofill)
    :textfont(smallfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 8)
    :text(">")
    :attach(setTimeFrame, setTimeFrameW-15-3, 2, 3, setTimeFrameH-2-12)
    :visible(true)
    :active(true)

setTimeNextButton.Action = (function()
    return
        function()
            date[toset] = date[toset]+1;
            setTime();
        end
    end) ();