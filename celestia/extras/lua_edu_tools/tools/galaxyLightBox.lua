require "locale";

----------------------------------------------
-- Set initial values
----------------------------------------------
local galaxyLightLevel = celestia:getgalaxylightgain();
galaxyLightSliderFrameW = boxWidth - 16;
galaxyLightSliderBoxW = 12;
galaxyLightSliderMargin = 3;

galaxyLightPosMax = galaxyLightSliderFrameW-galaxyLightSliderBoxW-(2*galaxyLightSliderMargin);
galaxyLightPos = galaxyLightLevel*galaxyLightPosMax;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
galaxyLightBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

galaxyLightBox.Customdraw =
    function(this)
        local galaxyLightLevel = celestia:getgalaxylightgain();
        textlayout:setpos(this.lb+7, this.tb-15);
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        galaxyLightLevel_str = string.format("%i%%", galaxyLightLevel*100);
        textlayout:println(_("Galaxy Light Gain:")..' '..galaxyLightLevel_str);
    end;

galaxyLightSliderFrame = CXBox:new()
    --:bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(galaxyLightBox, 8, 9, 8, 23)
    :visible(true)

galaxyLightSliderFrame.Customdraw =
    function(this)
        mag_lb = galaxyLightSliderFrame.lb;
        mag_lb2 = galaxyLightSliderBox.lb;
        galaxyLightValue = math_round((mag_lb2-mag_lb-galaxyLightSliderMargin)*100/galaxyLightPosMax)/100;
        if lastGalaxyLightValue ~= galaxyLightValue then
            -- The slider has been moved; set the new Galaxy Light gain value.
            lastGalaxyLightValue = galaxyLightValue;
            celestia:setgalaxylightgain(galaxyLightValue);
        end
    end;

galaxyLightSliderFrame2 = CXBox:new()
    :bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(galaxyLightSliderFrame, 2, 4, 2, 4)
    :visible(true)

galaxyLightSliderBox = CXBox:new()
    :bordercolor(cslidebobord)
    :fillcolor(cslidebofill)
    :visible(true)
    :movable(true)
    :attach(galaxyLightSliderFrame, galaxyLightSliderMargin+galaxyLightPos, 0,
                        galaxyLightSliderFrameW-galaxyLightSliderMargin-galaxyLightPos-galaxyLightSliderBoxW, 0);

galaxyLightSliderFrame2.Masked = galaxyLightSliderBox;

galaxyLightSliderBox.Customdraw =
    function(this)
        local galaxyLightLevel = celestia:getgalaxylightgain();
        if lastGalaxyLightLevel ~= galaxyLightLevel then
            -- Galaxy Light gain has been changed using the keyboard;
            -- set the new position of the slider.
            lastGalaxyLightLevel = galaxyLightLevel;
            galaxyLightPos = galaxyLightLevel * galaxyLightPosMax;
            galaxyLightSliderBox:attach(galaxyLightSliderFrame, galaxyLightSliderMargin+galaxyLightPos, 0,
                                                                                            galaxyLightSliderFrameW-galaxyLightSliderMargin-galaxyLightPos-galaxyLightSliderBoxW, 0);
        end
    end;