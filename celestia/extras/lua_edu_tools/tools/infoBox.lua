require "locale";
require "infoImage";

----------------------------------------------
-- Load images.
----------------------------------------------
local infoButton1 = celestia:loadtexture("../images/button1.png");
local infoButton2 = celestia:loadtexture("../images/button2.png");

----------------------------------------------
-- Define local functions
----------------------------------------------
local setInfoScrollbarVisibility = function(nLines)
    if nLines > nLinesMax then
        infoScrollbarFrame.Visible = true;
    else
        infoScrollbarFrame.Visible = false;
    end
end

local getTextWidth = function(text)
    local lineWidthMax = 0;
    for textline in string.gfind(text,"([^\n]*)\n") do
        local lineWidth = normalfont:getwidth(textline)
        if lineWidth > lineWidthMax then
            lineWidthMax = lineWidth;
        end
    end
    local textWidth = math.ceil(lineWidthMax);
    return textWidth;
end

local getImageSize = function(image)
    local iWidth = image:getwidth();
    local iHeight = image:getheight();
    if iWidth > 512 or iHeight > 512 then
        if iWidth >= iHeight then
            iHeight = iHeight * 512 / iWidth;
            iWidth = 512;
        else
            iWidth = iWidth * 512 / iHeight;
            iHeight = 512;
        end
    end
    return iWidth, iHeight;
end

local setInfoButtonVisibility = function(imageIndexMax)
    if imageIndexMax > 1 then
        infoPreviousButton.Visible = true;
        infoNextButton.Visible = true;
    else
        infoPreviousButton.Visible = false;
        infoNextButton.Visible = false;
    end
end

local getImageIndexMax = function(selname)
    iMax = 0;
    if infoImage[selname] then
        iMax = table.getn(infoImage[selname]);
    end
    return iMax
end

----------------------------------------------
-- Set initial values
----------------------------------------------
infoTextFrameWidth, infoTextFrameHeight = 350, 455;
infoScrollbarFrameW, infoScrollbarFrameH = 9, 425;

cInfo = ctext;

seltextline = {};
nLines = 0;
nLinesMax = 32;
infoScroll = 0;
infoScrollCoeff = 10;
infoScrollbarBoxH = 0;

image = {};
for objname, v in pairs(infoImage) do
    image[objname] = {};
end

imageWidth, imageHeight = 256, 256;

imdx, imdy = 0, 0;
-- Move up image if obsModeBox is disabled.
if not(obsModeBox) then
    imdy = 50;
end

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
infoBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

infoBox.Customdraw =
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(cInfo);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("More Info"));
    end;

infoCheck = CXBox:new()
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
        :attach(infoBox, boxWidth - 40, 4, 29, 5)

infoCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if not info_firstTickDone then
            info_firstTickDone = true;
            if enable_info then
                infoCheck.Action();
            end
        end

        local sel = celestia:getselection();
        if selection then
            if newselection then
                if infoText[sel:name()] or getImageIndexMax(sel:name()) ~= 0 then
                    enableCheckBox(infoCheck);
                    cInfo = ctext;
                else
                    disableCheckBox(infoCheck);
                    cInfo = cchetextoff;
                end
            end
        else
            disableCheckBox(infoCheck);
            cInfo = cchetextoff;
        end
    end

infoCheck.Action = (function()
    return
        function()
            selname = nil;
            imageIndex = 1;
            infoTextFrame.Visible = not(infoTextFrame.Visible);
            infoImageFrame.Visible = not(infoImageFrame.Visible);
            if infoTextFrame.Visible or infoImageFrame.Visible then
                infoCheck.Text = "x";
            else
                infoCheck.Text = "";
            end
        end
    end) ();

infoTextFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    --:fillcolor(csetbofill)
    :movable(false)
    :clickable(true)
    :visible(false)
    :attach(screenBox, 0, 30, width-infoTextFrameWidth, height-infoTextFrameHeight-30);

infoTextFrame.Customdraw =
    function(this)
        local sel = celestia:getselection();
        if selection then
            if newselection then
                seltext = infoText[selname];
                if seltext then
                    if string.find(seltext, "\n") then
                        -- Split the text into lines.
                        if string.sub(seltext, -1) ~= "\n" then
                            seltext = seltext.."\n";
                        end;
                        seltext, nLines = string.gsub(seltext, "\n", "\n");
                    end
                    setInfoScrollbarVisibility(nLines);
                    infoTextFrameWidth = getTextWidth(seltext)+30;
                    infoTextFrameH = infoTextFrameHeight;
                else
                    infoScrollbarFrame.Visible = false;
                    infoTextFrameWidth = 0;
                    infoTextFrameH = 0;
                    if getImageIndexMax(sel:name()) == 0 then
                        disableCheckBox(infoCheck);
                    end
                end
                resetInfoScrollPos = true;
                infoScroll = 0;
            else
                resetInfoScrollPos = false;
            end
            if seltext then
                lineCount = 0;
                -- Display info Text.
                textlayout:setfont(normalfont);
                textlayout:setpos(this.lb+5, this.tb-15);
                textlayout:setlinespacing(normalfont:getheight());
                textlayout:setfontcolor(ctextinfo);
                for seltextline in string.gfind(seltext,"([^\n]*)\n") do
                    if lineCount >= infoScroll and lineCount < nLinesMax+infoScroll then
                        textlayout:println(seltextline);
                    end
                    lineCount = lineCount+1;
                end
            end
        else
            disableCheckBox(infoCheck);
            if infoScrollbarFrame.Visible then
                infoScrollbarFrame.Visible = false;
            end
            infoTextFrameWidth = 0;
            infoTextFrameH = 0;
        end
        infoTextFrame:attach(screenBox, 0, 30, width-infoTextFrameWidth, height-infoTextFrameH-30);
    end;

infoScrollbarFrame = CXBox:new()
    --:bordercolor(cbubordoff)
    --:fillcolor({1, 0, 0, 1})
    :visible(true)
    :attach(infoTextFrame, infoTextFrameWidth-infoScrollbarFrameW-3, 10, 3, infoTextFrameHeight-10-infoScrollbarFrameH);

infoScrollbarFrame.Customdraw =
    function(this)
        -- We add the scrollButton on the second tick
        -- when bounds are getting updated.
        if infoScroll_firstTickDone then
            if not(infoScrollButtonDone) then
                infoScrollButtonDone = true;
                makeScrollButton(infoScrollUpButton, infoScrollDownButton, infoScrollbarFrame);
            end
        else
            infoScroll_firstTickDone = true;
        end

        local lb3,bb3,rb3,tb3 =infoScrollbarFrame:bounds();
        local lb4,bb4,rb4,tb4 = infoScrollbarBox:bounds();
        infoScroll = math_round((tb3-tb4-3)/infoScrollCoeff);
        infoScrollbarFrame:attach(infoTextFrame, infoTextFrameWidth-infoScrollbarFrameW-3, 10, 3, infoTextFrameHeight-10-infoScrollbarFrameH);
    end

infoScrollbarBox = CXBox:new()
    :bordercolor(cbubordoff)
    :fillcolor(cscrollfill)
    :visible(true)
    :movable(true)
    :attach(infoScrollbarFrame, 0, (nLines-nLinesMax)*infoScrollCoeff, 0, 3)

infoScrollbarBox.Customdraw =
    function(this)
        if resetInfoScrollPos then
            if nLines < 100 then
                infoScrollCoeff = 10
            elseif nLines < 1000 then
                infoScrollCoeff = 85*math.log(nLines)/(nLines-nLinesMax)
            else
                infoScrollCoeff = 200/(nLines-nLinesMax)
            end
            infoScrollbarBoxH = infoScrollbarFrameH-6-(nLines-nLinesMax)*infoScrollCoeff;
            infoScrollbarBox:attach(infoScrollbarFrame, 0, infoScrollbarFrameH-infoScrollbarBoxH-3, 0, 3)
        end
    end

infoImageFrame = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor({0.9, 0.9, 0.9, 0.25})
    :movable(false)
    :active(false)
    :visible(false)
    :attach(screenBox, width-imageWidth-2, 0, 2, height-imageHeight)

infoImageFrame.Customdraw =
    function(this)
        local sel = celestia:getselection();
        if selection then
            if newselection then
                selname = sel:name();
                imageIndex = 1;
                imageIndexMax = getImageIndexMax(sel:name());
                setInfoButtonVisibility(imageIndexMax);
                if imageIndexMax > 0 then
                    displayimage = true;
                else
                    displayimage = false;
                end
            end
        else
            displayimage = false;
        end
        if displayimage then
            -- Move image out of the toolbar if there's no room.
            if virtualPadBox and padFrame.Visible and not(centerPad) then
                padHeight = padFrameH;
            else
                padHeight = 0;
            end
            if imageHeight > height - toolBoxHeight - padHeight then
                    imdx = boxWidth + 4;
                else
                    imdx = 0;
            end
            -- Load and display image.
            if not image[selname][imageIndex] then
                image[selname][imageIndex] = celestia:loadtexture(infoImage[selname][imageIndex]);
            end
            if image[selname][imageIndex] then
                infoImageFrame:fillimage(image[selname][imageIndex]);
                imageWidth, imageHeight = getImageSize(image[selname][imageIndex]);
                infoImageFrame:attach(screenBox, width-imageWidth-2-imdx, 0+imdy, 2+imdx, height-imageHeight-imdy);
                infoPreviousButton:attach(infoImageFrame, 0, 0, imageWidth - 40, imageHeight - 40);
                infoNextButton:attach(infoImageFrame, imageWidth - 40, 0, 0, imageHeight - 40);
            end
        else
            if infoPreviousButton.Visible then
                infoPreviousButton.Visible = false;
                infoNextButton.Visible = false;
            end
            if infoImageFrame.Fillimage then
                infoImageFrame.Fillimage = nil;
            end
            infoImageFrame:attach(screenBox, width, 0, 0, height);
        end
    end;

infoPreviousButton = CXBox:new()
    :init(0,0,0,0)
    --:bordercolor(cbubordoff)
    :fillimage(infoButton1)
    :movable(false)
    :active(true)
    :visible(true)
    :attach(infoImageFrame, 0, 0, imageWidth - 40, imageHeight - 40)

infoPreviousButton.Action = (function()
    return
        function()
            imageIndex = imageIndex - 1;
            if not(infoImage[selname][imageIndex]) then
                imageIndex = imageIndexMax;
            end
        end
    end) ();

infoNextButton = CXBox:new()
    :init(0,0,0,0)
    --:bordercolor(cbubordoff)
    :fillimage(infoButton2)
    :movable(false)
    :active(true)
    :visible(true)
    :attach(infoImageFrame, imageWidth - 40, 0, 0, imageHeight - 40)

infoNextButton.Action = (function()
    return
        function()
            imageIndex = imageIndex + 1;
            if not(infoImage[selname][imageIndex]) then
                imageIndex = 1;
            end
        end
    end) ();
