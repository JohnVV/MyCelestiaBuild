require "locale";

----------------------------------------------
-- Set initial values
----------------------------------------------
yRatio = 722/height;

fovSliderFrameW = boxWidth - 36;
fovSliderBoxW = 12;

fovMidPos = (fovSliderFrameW - fovSliderBoxW) / 2;

-- Set max/min values for zoom_speed.
zoom_speed = math.min(10, math.max(1, zoom_speed));

zoomToRad = 0.223832847;
fovCoeff = 2 / 3 * math.pi * zoomToRad ;
fov = celestia:getobserver():getfov();
zoom = fovCoeff / (yRatio * fov);
zoomFactor = 1e3 * 5 / zoom_speed;
zoomPos = 0;

-- Use the full range of FOV from 120° down to 3.6".
fovMin, fovMax = 0.001 * degToRad, 120 * degToRad;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
fovBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :visible(true)
    :attach(screenBox, width, height, 0, 0);

fovBox.Customdraw =
    function(this)
        obs = celestia:getobserver();
        fov = obs:getfov();
        yRatio = 722 / height;

        -- We use a simplified function to get Zoom from FOV; the function used in Celestiacore.cpp
        -- can't be reproduced here because there is no way to get certain variables from the core code.
        -- A tiny difference between the standard and the Lua values of Zoom may be noticed.
        zoom = fovCoeff / (yRatio * fov);

        textlayout:setpos(this.lb+7, this.tb-15);
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        textlayout:println(_("FOV:")..' '..format:raddms(fov)..' '..string.format("(%1.2fx)", zoom));

    end;

fovSliderFrame = CXBox:new()
    --:bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :visible(true)
    :attach(fovBox, 28, 9, 8, 23)

fovSliderFrame2 = CXBox:new()
    :bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(fovSliderFrame, 2, 4, 2, 4)
    :visible(true)

fovSliderBox = CXBox:new()
    :bordercolor(cslidebobord)
    :fillcolor(cslidebofill)
    :visible(true)
    :movable(true)
    :attach(fovSliderFrame, fovMidPos, 0, fovMidPos, 0)

fovSliderFrame2.Masked = fovSliderBox;

fovSliderBox.Customdraw =
    function(this)
        local obs = celestia:getobserver();
        fov = obs:getfov();
        if this.Move then
            local fov_lb = fovSliderFrame.lb;
            local fov_lb2 = fovSliderBox.lb;
            zoomPos = math.floor(fov_lb2 - fov_lb - fovMidPos);
            -- The slider has been moved; set the new FOV value.
            zoom = zoom * (1 + zoomPos / zoomFactor);
            fov = fovCoeff / (zoom * yRatio);
            if fov < fovMin then
                fov = fovMin;
            elseif fov > fovMax then
                fov = fovMax
            end
            obs:setfov(fov);
        else
            fovSliderBox:attach(fovSliderFrame, fovMidPos, 0, fovMidPos, 0)
        end
    end;

resetFovButton = CXBox:new()
    :bordercolor(cbubordoff)
    :textfont(smallfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 8)
    :text("1x")
    :visible(true)
    :active(true)
    :attach(fovBox, 10, 8, boxWidth - 24, 22)

resetFovButton.Action = (function()
    return
        function()
            fov = fovCoeff / yRatio;
            obs:setfov(fov);
        end
    end) ();