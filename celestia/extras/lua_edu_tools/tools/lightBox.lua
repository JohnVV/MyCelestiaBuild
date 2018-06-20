require "locale";

----------------------------------------------
-- Set initial values
----------------------------------------------
local lightLevel = celestia:getambient();

lightSliderFrameW = boxWidth - 16;
lightSliderBoxW = 12;
lightSliderMargin = 3;
lightPosMax = lightSliderFrameW-lightSliderBoxW-(2*lightSliderMargin);
lightPos = lightLevel*lightPosMax;

lightFirstTick = true;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
lightBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

lightBox.Customdraw =
    function(this)
        local lightLevel = celestia:getambient();
        textlayout:setpos(this.lb+7, this.tb-15);
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        lightLevel_str = string.format("%1.2f", lightLevel);
        textlayout:println(_("Ambient Light Level:")..' '..lightLevel_str);
    end;

lightSliderFrame = CXBox:new()
    --:bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(lightBox, 8, 8, 8, 24)
    :visible(true)

lightSliderFrame.Customdraw =
    function(this)
        light_lb = lightSliderFrame.lb;
        light_lb2 = lightSliderBox.lb;
        lightValue = math_round(light_lb2-light_lb-3)/lightPosMax;
        if lastLightValue ~= lightValue and not(lightFirstTick) then
            -- The slider has been moved; set the new Ambient Light value.
            lastLightValue = lightValue;
            celestia:setambient(lightValue);
        end
        lightFirstTick = false;
    end;

lightSliderFrame2 = CXBox:new()
    :bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(lightSliderFrame, 2, 4, 2, 4)
    :visible(true)

lightSliderBox = CXBox:new()
    :bordercolor(cslidebobord)
    :fillcolor(cslidebofill)
    :visible(true)
    :movable(true)
    :attach(lightSliderFrame, lightSliderMargin+lightPos, 0, lightSliderFrameW-lightSliderMargin-lightPos-lightSliderBoxW, 0);

lightSliderFrame2.Masked = lightSliderBox;

lightSliderBox.Customdraw =
    function(this)
        local lightLevel = celestia:getambient();
        if lastLightLevel ~= lightLevel then
            -- Ambient Light Level has been changed using the keyboard;
            -- set the new position of the slider.
            lastLightLevel = lightLevel;
            lightPos = math_round(lightLevel*lightPosMax);
            lightSliderBox:attach(lightSliderFrame, lightSliderMargin+lightPos, 0, lightSliderFrameW-lightSliderMargin-lightPos-lightSliderBoxW, 0);
        end
    end;