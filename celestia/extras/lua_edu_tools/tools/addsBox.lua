require "locale";
require "closeButton";
require "scrollButton";

----------------------------------------------
-- Define local functions
----------------------------------------------
--[[local getLuaEduToolsPath =
    function()
        local pathes = package.path;
        local c1 = string.find(pathes, "lua_edu_tools");
        local path1 = string.sub(pathes, 1, c1 - 1);
        local revpath1 = string.reverse(path1);
        local c2 = string.find(revpath1, ";");
        local revpath2 = string.sub(revpath1, 1, c2 - 1);
        local path = string.reverse(revpath2);
        return path;
    end]]

local setCheckBoxText = function(box, flag)
    if flag then
        box.Text = "x";
    else
        box.Text = "";
    end
end

local setAddCheckBoxText = function(box, k, flag)
    if flag then
        box[k].Text = "x";
    else
        box[k].Text = "";
    end
end

local makeAddBox = function(k, v, leftOffset, color)
    addBox[k] = CXBox:new()
        :init(0, 0, 0, 0)
        --:bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(normalfont)
        :textcolor(color)
        :movetext(0, 8)
        :text(_(v))
        :movable(false)
        :attach(addsFrame, leftOffset+15, addsFrameHeight-25-(20*k), addsFrameWidth-leftOffset-100, 14+(20*k))
end

local makeAddCheckBox = function(k, leftOffset)
    addCheckBox[k] = CXBox:new()
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
        :attach(addsFrame, leftOffset, addsFrameHeight-25-(20*k), addsFrameWidth-leftOffset-11, 14+(20*k))
end

----------------------------------------------
-- Set initial values
----------------------------------------------
locLabelBoxWidth, locLabelBoxHeight = 100, 20;
featureSizeBoxWidth, featureSizeBoxHeight = 146, 43;

-- Set the height of the Adds window.
local nadds = table.getn(adds);
nAddsLinesMax = math.max(4, math.min(addon_list_nlines, nadds));
addsFrameWidth, addsFrameHeight = 250, 110 + (20 * nAddsLinesMax);
addsScrollbarFrameW, addsScrollbarFrameH = 9, addsFrameHeight  - 110 - 20;

nAddsLines = nadds;
addsScroll = 0;
addsScrollCoeff = 6;
addsScrollbarBoxH = 0;

local minFeatureSize = celestia:getminfeaturesize();

featureSizeSliderFrameW = 130;
featureSizeSliderBoxW = 12;
featureSizeSliderMargin = 3;
featureSizePosMax = featureSizeSliderFrameW - featureSizeSliderBoxW - (2 * featureSizeSliderMargin);
featureSizePos = math.ceil(minFeatureSize / 100 * featureSizePosMax);

addLeftOffset = 20;

addBox = {};
addCheckBox = {};
addVisible = {};
addLabelColor = {};

-- Disable all Location types.
local obs = celestia:getobserver();
local locFlags = obs:getlocationflags();
for k, v in pairs(locFlags) do
    locFlags[k] = false;
    obs:setlocationflags(locFlags);
end

-- Enable Location labels.
celestia:setlabelflags{locations = true}

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
addsBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

setAddsButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Set Addon Visibility"))
    :movable(false)
    :active(true)
    :attach(addsBox, 8, 4, 8, 3)

setAddsButton.Action = (function()
    return
        function()
            addsFrame.Visible = not(addsFrame.Visible);
            if addsFrame.Visible then
                addsFrame:orderfront();
                setAddsButton.Bordercolor = cbubordon;
                setAddsButton.Fillcolor = {cbubordon[1]*2/3, cbubordon[2]*2/3, cbubordon[3]*2/3, cbubordon[4]/2};
            else
                setAddsButton.Bordercolor = cbubordoff;
                setAddsButton.Fillcolor = nil;
            end
        end
    end) ();

addsFrame = CXBox:new()
    :init(0, 0, 0, 0)
    :fillcolor(csetbofill)
    --:bordercolor(cbubordoff)
    :movable(false)
    :visible(false)
    :attach(screenBox, (width-addsFrameWidth)/2, height-addsFrameHeight-2, (width-addsFrameWidth)/2, 2);

addsFrame.Customdraw =
    function(this)
        -- We start displaying the text on the second tick in order to
        -- hide a possible uggly resizing of the box during the first tick.
        if adds_firstTickDone then
            textlayout:setfont(normalfont);
            textlayout:setfontcolor(ctext);
            textlayout:setpos(this.lb+addLeftOffset, this.tb-20);
            textlayout:println(_("Addon Visibility:"));

            if not(addsCloseButtonDone) then
                addsCloseButtonDone = true;
                makeCloseButton(addsCloseButton, addsFrame, setAddsButton);
            end
        else
            adds_firstTickDone = true;
        end
        addsFrame:attach(screenBox, (width-addsFrameWidth)/2, height-addsFrameHeight-2, (width-addsFrameWidth)/2, 2);
    end;

for k, v in ipairs(adds) do

    if pcall( function() require (v) end ) then
        require(v)

        addLabelColor[k] = cbutextoff;
        if _G[v].labelcolor then
            addLabelColor[k] = _G[v].labelcolor;
        end

        makeAddBox(k, string.gsub(v, "_", " "), addLeftOffset, addLabelColor[k]);
        makeAddCheckBox(k, addLeftOffset);

        local vv, kk = v, k;

        if _G[v].objects then
            addVisible[k] = celestia:find(_G[v].objects[1]):visible();
        else
            addVisible[k] = false;
        end

        addBox[k].Visible = k <= nAddsLinesMax;
        addCheckBox[k].Visible = k <= nAddsLinesMax;

        addCheckBox[k].Customdraw =
            function(this)
                setAddCheckBoxText(addCheckBox, kk, addVisible[k + addsScroll]);
                addBox[k].Text = _(string.gsub(adds[k + addsScroll], "_", " "));
                addBox[k].Textcolor = addLabelColor[k + addsScroll];
            end

            addCheckBox[k].Action = (function()
                return
                    function()
                        local vAddsScroll = adds[k + addsScroll];
                        addVisible[k + addsScroll] = not(addVisible[k + addsScroll]);
                        if _G[vAddsScroll].objects then
                            for n, obj in pairs(_G[vAddsScroll].objects) do
                                local addObj = celestia:find(obj);
                                addObj:setvisible(not addObj:visible());
                            end
                        end

                        if _G[vAddsScroll].locationtypes then
                            for n, loctype in pairs(_G[vAddsScroll].locationtypes) do
                                addLocType = string.lower(loctype);
                                local obs = celestia:getobserver();
                                local locFlags = obs:getlocationflags();
                                if locFlags[addLocType] ~= addVisible[k + addsScroll] then
                                    locFlags[addLocType] = addVisible[k + addsScroll];
                                    obs:setlocationflags(locFlags);
                                end
                            end
                        end

                        if _G[vAddsScroll].script then
                            local scriptfile = "../adds/"..vAddsScroll.."/".._G[vAddsScroll].script;
                            celestia:runscript(scriptfile);
                            if _G[vAddsScroll].objects then
                                addVisible[k + addsScroll] = celestia:find(_G[vAddsScroll].objects[1]):visible();
                                setAddCheckBoxText(addCheckBox, kk, addVisible[k + addsScroll]);
                            end
                        end
                    end
                end) ();

    end

end

addsScrollbarFrame = CXBox:new()
    --:bordercolor(cbubordoff)
    --:fillcolor({1, 0, 0, 1})
    :visible(nAddsLines > nAddsLinesMax)
    :attach(addsFrame, addsFrameWidth-addsScrollbarFrameW-3, addsFrameHeight-40-addsScrollbarFrameH, 3, 40);

addsScrollbarFrame.Customdraw =
    function(this)
        -- We add the scrollButton on the second tick
        -- when bounds are getting updated.
        if addsScroll_firstTickDone then
            if not(addsScrollButtonDone) then
                addsScrollButtonDone = true;
                makeScrollButton(addsScrollUpButton, addsScrollDownButton, addsScrollbarFrame);
            end
        else
            addsScroll_firstTickDone = true;
        end

        local lb3,bb3,rb3,tb3 =addsScrollbarFrame:bounds();
        local lb4,bb4,rb4,tb4 = addsScrollbarBox:bounds();
        addsScroll = math_round((tb3-tb4-3)/addsScrollCoeff);
        addsScrollbarFrame:attach(addsFrame, addsFrameWidth-addsScrollbarFrameW-3, addsFrameHeight-40-addsScrollbarFrameH, 3, 40);
    end

addsScrollbarBox = CXBox:new()
    :bordercolor(cbubordoff)
    :fillcolor(cscrollfill)
    :visible(true)
    :movable(true)
    :attach(addsScrollbarFrame, 0, (nAddsLines-nAddsLinesMax)*addsScrollCoeff, 0, 3)

featureSizeBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(addsFrame, addLeftOffset-7, 25, 
                addsFrameWidth-featureSizeBoxWidth-addLeftOffset+7, addsFrameHeight-featureSizeBoxHeight-25);

featureSizeBox.Customdraw =
    function(this)
        local minFeatureSize = celestia:getminfeaturesize();
        textlayout:setpos(this.lb+7, this.tb-15);
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        minFeatureSize_str = string.format("%1.0f", math.floor(minFeatureSize));
        textlayout:println(_("Minimum Feature Size:")..' '..minFeatureSize_str);
    end;

featureSizeSliderFrame = CXBox:new()
    --:bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(featureSizeBox, 8, 8, 8, 24)
    :visible(true)

featureSizeSliderFrame.Customdraw =
    function(this)
        featureSize_lb = featureSizeSliderFrame.lb;
        featureSize_lb2 = featureSizeSliderBox.lb;
        featureSizeValue = 100 * math_round(featureSize_lb2 - featureSize_lb - 3) / featureSizePosMax;
        if featureSizeValue < 1 then
            featureSizeValue = 1;
        end
        if lastFeatureSizeValue ~= featureSizeValue and not(featureSizeFirstTick) then
            -- The slider has been moved; set the new Minimum Feature Size value.
            lastFeatureSizeValue = featureSizeValue;
            celestia:setminfeaturesize(featureSizeValue);
        end
        featureSizeFirstTick = false;
    end;

featureSizeSliderFrame2 = CXBox:new()
    :bordercolor(cslidefrbord)
    --:fillcolor({.2,.2,.6,.1})
    :attach(featureSizeSliderFrame, 2, 4, 2, 4)
    :visible(true)

featureSizeSliderBox = CXBox:new()
    :bordercolor(cslidebobord)
    :fillcolor(cslidebofill)
    :visible(true)
    :movable(true)
    :attach(featureSizeSliderFrame, featureSizeSliderMargin+featureSizePos, 0, 
                featureSizeSliderFrameW-featureSizeSliderMargin-featureSizePos-featureSizeSliderBoxW, 0);

featureSizeSliderFrame2.Masked = featureSizeSliderBox;

featureSizeSliderBox.Customdraw =
    function(this)
        local minFeatureSize = celestia:getminfeaturesize();
        if lastMinFeatureSize ~= minFeatureSize then
            -- Minimum Feature Size has been changed;
            -- set the new position of the slider.
            lastMinFeatureSize = minFeatureSize;
            featureSizePos = math_round(minFeatureSize / 100 * featureSizePosMax);
            featureSizeSliderBox:attach(featureSizeSliderFrame, featureSizeSliderMargin+featureSizePos, 0, 
                                                        featureSizeSliderFrameW-featureSizeSliderMargin-featureSizePos-featureSizeSliderBoxW, 0);
        end
    end;

locLabelBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(ctext)
    :movetext(18, 3)
    :text(_("Label Features"))
    :movable(false)
    :attach(addsFrame, addLeftOffset-2, 10, 
                addsFrameWidth-locLabelBoxWidth-addLeftOffset+2, addsFrameHeight-locLabelBoxHeight-10);

locLabelCheckBox = CXBox:new()
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
        :attach(locLabelBox, 2, 4, 87, 5)

setCheckBoxText(locLabelCheckBox, celestia:getlabelflags().locations)

locLabelBox.Customdraw =
    function(this)
        if locLabelFlag ~= celestia:getlabelflags().locations then
            locLabelFlag = celestia:getlabelflags().locations;
            setCheckBoxText(locLabelCheckBox, locLabelFlag)
        end
    end;

locLabelCheckBox.Action = (function()
        return
            function()
                local labelFlagTable = celestia:getlabelflags();
                labelFlagTable.locations = not(labelFlagTable.locations)
                celestia:setlabelflags(labelFlagTable);
            end
        end) ();
