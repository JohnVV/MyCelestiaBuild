require "locale";

----------------------------------------------
-- Define local functions
----------------------------------------------
local isAutoMagOn = function()
    autoMagOn = celestia:getrenderflags().automag;
    return autoMagOn;
end

local getMagSliderPos = function(magLevel, autoMagOn)
    if autoMagOn then
        magSliderPos = (magLevel-autoMagLevelMin)*magPosMax/(autoMagLevelMax-autoMagLevelMin);
    else
        magSliderPos = (magLevel-magLevelMin)*magPosMax/(magLevelMax-magLevelMin);
    end
    return magSliderPos;
end

----------------------------------------------
-- Set initial values
----------------------------------------------
magLevel = celestia:getfaintestvisible();
autoMagOn = isAutoMagOn();
magSliderFrameW = boxWidth - 36;
magSliderBoxW = 12;
magSliderMargin = 3;
magLevelMin = 1;
magLevelMax = 15;
autoMagLevelMin = 6;
autoMagLevelMax = 12;
magPosMax = magSliderFrameW-magSliderBoxW-(2*magSliderMargin);
magPos = getMagSliderPos(magLevel, autoMagOn);
magFirstTick = true;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
magnitudeBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

magnitudeBox.Customdraw =
    function(this)
        local magLevel = celestia:getfaintestvisible();
        textlayout:setpos(this.lb+7, this.tb-15);
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        magLevel_str = string.format("%1.2f", magLevel);
        autoMagOn = isAutoMagOn();
        if lastAutoMagOn ~= autoMagOn then
            lastAutoMagOn = autoMagOn;
            magFirstTick = true;
        end
        if autoMagOn then
            textlayout:println(_("AutoMag at 45°:")..' '..magLevel_str);
        else
            textlayout:println(_("Magnitude limit:")..' '..magLevel_str);
        end
    end;

magSliderFrame = CXBox:new()
    --:bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(magnitudeBox, 28, 9, 8, 23)
    :visible(true)

magSliderFrame.Customdraw =
    function(this)
        mag_lb = magSliderFrame.lb;
        mag_lb2 = magSliderBox.lb;
        if autoMagOn then
            magValue = (mag_lb2-mag_lb-magSliderMargin)*(autoMagLevelMax-autoMagLevelMin)/magPosMax + autoMagLevelMin;
        else
            magValue = (mag_lb2-mag_lb-magSliderMargin)*(magLevelMax-magLevelMin)/magPosMax + magLevelMin;
        end
        if lastMagValue ~= magValue and not(magFirstTick) then
            -- The slider has been moved; set the new Magnitude limit/AutoMag at 45° value.
            lastMagValue = magValue;
            celestia:setfaintestvisible(magValue);
        end
        magFirstTick = false;
    end;

magSliderFrame2 = CXBox:new()
    :bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(magSliderFrame, 2, 4, 2, 4)
    :visible(true)

magSliderBox = CXBox:new()
    :bordercolor(cslidebobord)
    :fillcolor(cslidebofill)
    :visible(true)
    :movable(true)
    :attach(magSliderFrame, magSliderMargin+magPos, 0, magSliderFrameW-magSliderMargin-magPos-magSliderBoxW, 0);

magSliderFrame2.Masked = magSliderBox;

magSliderBox.Customdraw =
    function(this)
        local magLevel = celestia:getfaintestvisible();
        if lastMagLevel ~= magLevel then
            -- Magnitude limit/AutoMag at 45° has been changed using the keyboard;
            -- set the new position of the slider.
            lastMagLevel = magLevel;
            magPos = getMagSliderPos(magLevel, autoMagOn);
            magSliderBox:attach(magSliderFrame, magSliderMargin+magPos, 0, magSliderFrameW-magSliderMargin-magPos-magSliderBoxW, 0);
        end
    end;

autoMagButton = CXBox:new()
    :bordercolor(cbubordoff)
    :textfont(smallfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 8)
    :text(_("A"))
    :visible(true)
    :active(true)
    :attach(magnitudeBox, 11, 8, boxWidth - 24, 22)

autoMagButton.Action = (function()
    return
        function()
            if isAutoMagOn() then
                celestia:setrenderflags{automag = false};
            else
                celestia:setrenderflags{automag = true};
            end
        end
    end) ();