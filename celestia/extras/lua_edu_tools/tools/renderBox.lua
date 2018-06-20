require "locale";
require "closeButton";

----------------------------------------------
-- Define local functions
----------------------------------------------
local setLabelElementName = function(str)
    if str == "Constell. in Latin" then
        strl = "i18nconstellations";
    else
        strl = string.lower(string.gsub(str, " ", ""));
    end
    return strl;
end

local setRenderElementName = function(str)
    strr = string.lower(string.gsub(str, " ", ""));
    return strr;
end

local setOrbitElementName = function(str)
    strr = string.gsub(str, " ", "");
    return strr;
end

local setCheckBoxText = function(box, k, flag)
    if flag then
        box[k].Text = "x";
    else
        box[k].Text = "";
    end
end

local makeClassBox = function(classBox, k, v, leftOffset)
    classBox = CXBox:new()
        :init(0, 0, 0, 0)
        --:bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(normalfont)
        :textcolor(cbutextoff)
        :movetext(0, 8)
        :text(_(v))
        :movable(false)
        :attach(renderFrame, leftOffset+15, renderFrameHeight-25-(20*k), renderFrameWidth-leftOffset-100, 14+(20*k))
end

local makeCheckBox = function(checkBox, k, leftOffset)
    checkBox[k] = CXBox:new()
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
        :attach(renderFrame, leftOffset, renderFrameHeight-25-(20*k), renderFrameWidth-leftOffset-11, 14+(20*k))
end

local setStarStyleRadioButtonText = function(s)
    if s == "point" then
        starStyleCheckBox.Text = "1";
    elseif s == "fuzzy" then
        starStyleCheckBox.Text = "2";
    elseif s == "disc" then
        starStyleCheckBox.Text = "3";
    end
end

----------------------------------------------
-- Set initial values
----------------------------------------------
-- Set the height of the Render Options window.
local nrender = table.getn(renderclass);
local nguide = table.getn(guideclass);
local norbit = table.getn(orbitclass);
local nlabel = table.getn(labelclass);
local nmax = math.max(nrender, nguide + 2, norbit, nlabel);

renderFrameWidth, renderFrameHeight = 560, 40 + (20 * nmax);

starStyleBoxW, starStyleBoxH = 146, 20;
textureResBoxW, textureResBoxH = 146, 20;
--informationTextBoxW, informationTextBoxH = 146, 20;

renderLeftOffset = 20;
guideLeftOffset = 200;
orbitLeftOffset = 380;
labelLeftOffset = 400;

starStyleLeftOffset = guideLeftOffset - 2;
starStyleUpOffset = 9 + 20 * (nguide + 2);
textureResLeftOffset = guideLeftOffset - 2;
textureResUpOffset = 9 + 20 * (nguide + 3);
--informationTextLeftOffset = starStyleLeftOffset;
--informationTextUpOffset = starStyleUpOffset + 20;

renderCheckBox = {};
guideCheckBox = {};
orbitCheckBox = {};
labelCheckBox = {};

rendertable = {};
orbittable = {};
labeltable = {};

local starstyle = celestia:getstarstyle();

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
renderBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

setRenderButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Set Render Options"))
    :movable(false)
    :active(true)
    :attach(renderBox, 8, 4, 8, 3)

setRenderButton.Action = (function()
    return
        function()
            renderFrame.Visible = not(renderFrame.Visible);
            if renderFrame.Visible then
                renderFrame:orderfront();
                setRenderButton.Bordercolor = cbubordon;
                setRenderButton.Fillcolor = {cbubordon[1]*2/3, cbubordon[2]*2/3, cbubordon[3]*2/3, cbubordon[4]/2};
            else
                setRenderButton.Bordercolor = cbubordoff;
                setRenderButton.Fillcolor = nil;
            end
        end
    end) ();

renderFrame = CXBox:new()
    :init(0, 0, 0, 0)
    :fillcolor(csetbofill)
    --:bordercolor(cbubordoff)
    :movable(false)
    :visible(false)
    :attach(screenBox, (width-renderFrameWidth)/2+50, height-renderFrameHeight-2, (width-renderFrameWidth)/2-50, 2);

renderFrame.Customdraw =
    function(this)
        -- We start displaying the text on the second tick in order to
        -- hide a possible uggly resizing of the box during the first tick.
        if render_firstTickDone then
            textlayout:setfont(normalfont);
            textlayout:setfontcolor(ctext);
            textlayout:setpos(this.lb+renderLeftOffset, this.tb-20);
            textlayout:println(_("Show:"));
            textlayout:setpos(this.lb+guideLeftOffset, this.tb-20);
            textlayout:println(_("Guides:"));
            textlayout:setpos(this.lb+orbitLeftOffset, this.tb-20);
            textlayout:println(_("Orbits / Labels:"));

            if not(renderCloseButtonDone) then
                renderCloseButtonDone = true;
                makeCloseButton(renderCloseButton, renderFrame, setRenderButton);
            end
        else
            render_firstTickDone = true;
        end
        renderFrame:attach(screenBox, (width-renderFrameWidth)/2, height-renderFrameHeight-2, (width-renderFrameWidth)/2, 2);
    end;

for k, v in ipairs(renderclass) do

    makeClassBox(renderClassBox, k, v, renderLeftOffset);
    makeCheckBox(renderCheckBox, k, renderLeftOffset);

    if v == "" then
        renderCheckBox[k].Visible = false;
    end

local vv, kk = v, k;

    renderCheckBox[k].Customdraw =
        function(this)
            vr = setRenderElementName(vv);
            renderFlag = celestia:getrenderflags()[vr];
            setCheckBoxText(renderCheckBox, kk, renderFlag)
        end;

    renderCheckBox[k].Action = (function()
        return
            function()
                vr = setRenderElementName(vv);
                renderFlag = celestia:getrenderflags()[vr];
                renderFlag = not(renderFlag);
                rendertable[vr] = renderFlag;
                celestia:setrenderflags(rendertable);
            end
        end) ();
    end

for k, v in ipairs(guideclass) do

    makeClassBox(guideClassBox, k, v, guideLeftOffset);
    makeCheckBox(guideCheckBox, k, guideLeftOffset);

    if v == "" then
        guideCheckBox[k].Visible = false;
    end

local vv, kk = v, k;

    guideCheckBox[k].Customdraw =
        function(this)
            vr = setRenderElementName(vv);
            renderFlag = celestia:getrenderflags()[vr];
            setCheckBoxText(guideCheckBox, kk, renderFlag)
        end;

    guideCheckBox[k].Action = (function()
        return
            function()
                vr = setRenderElementName(vv);
                renderFlag = celestia:getrenderflags()[vr];
                renderFlag = not(renderFlag);
                rendertable[vr] = renderFlag;
                celestia:setrenderflags(rendertable);
            end
        end) ();
    end

for k, v in ipairs(orbitclass) do

    makeClassBox(orbitClassBox, k, "", orbitLeftOffset);
    makeCheckBox(orbitCheckBox, k, orbitLeftOffset);

local vv, kk = v, k;

    orbitCheckBox[k].Customdraw =
        function(this)
            vo = setOrbitElementName(vv);
            orbitFlag = celestia:getorbitflags()[vo];
            setCheckBoxText(orbitCheckBox, kk, orbitFlag);
        end;

    orbitCheckBox[k].Action = (function()
        return
            function()
                vo = setOrbitElementName(vv);
                orbitFlag = celestia:getorbitflags()[vo];
                orbitFlag = not(orbitFlag);
                orbittable[vo] = orbitFlag;
                celestia:setorbitflags(orbittable);
            end
        end) ();

    end

for k, v in ipairs(labelclass) do

    makeClassBox(labelClassBox, k, v, labelLeftOffset)
    makeCheckBox(labelCheckBox, k, labelLeftOffset)

    if v == "" then
        labelCheckBox[k].Visible = false;
    end

local vv, kk = v, k;

    labelCheckBox[k].Customdraw =
        function(this)
            vl = setLabelElementName(vv);
            labelFlag = celestia:getlabelflags()[vl];
            if vv == "Constell. in Latin" then
                setCheckBoxText(labelCheckBox, kk, not(labelFlag))
            else
                setCheckBoxText(labelCheckBox, kk, labelFlag)
            end
        end;

    labelCheckBox[k].Action = (function()
        return
            function()
                vl = setLabelElementName(vv);
                labelFlag = celestia:getlabelflags()[vl];
                labelFlag = not(labelFlag);
                labeltable[vl] = labelFlag;
                celestia:setlabelflags(labeltable);
            end
        end) ();
    end


starStyleBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(ctext)
    :movetext(18, 3)
    :text(_("Star Style"))
    :movable(false)
    :attach(renderFrame, starStyleLeftOffset, renderFrameHeight-starStyleUpOffset-starStyleBoxH, renderFrameWidth-starStyleLeftOffset-starStyleBoxW, starStyleUpOffset);

starStyleCheckBox = CXBox:new()
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
        :attach(starStyleBox, 2, 4, 133, 5)

setStarStyleRadioButtonText(starstyle);

starStyleBox.Customdraw =
    function(this)
        if starstyle ~= celestia:getstarstyle() then
            starstyle = celestia:getstarstyle();
            setStarStyleRadioButtonText(starstyle);
        end
    end;

starStyleCheckBox.Action = (function()
        return
            function()
                if starstyle == "point" then
                    starstyle = "fuzzy";
                elseif starstyle == "fuzzy" then
                    starstyle = "disc";
                elseif starstyle == "disc" then
                    starstyle = "point";
                end
                celestia:setstarstyle(starstyle);
                setStarStyleRadioButtonText(starstyle);
            end
        end) ();

textureResBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(ctext)
    :movetext(18, 3)
    :text(_("Texture Resolution"))
    :movable(false)
    :attach(renderFrame, textureResLeftOffset, renderFrameHeight-textureResUpOffset-textureResBoxH, renderFrameWidth-textureResLeftOffset-textureResBoxW, textureResUpOffset);

textureResCheckBox = CXBox:new()
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
        :attach(textureResBox, 2, 4, 133, 5)

textureResCheckBox.Text = celestia:gettextureresolution();

textureResBox.Customdraw =
    function(this)
        if textureRes ~= celestia:gettextureresolution() then
            textureRes = celestia:gettextureresolution();
            textureResCheckBox.Text = textureRes;
        end
    end;

textureResCheckBox.Action = (function()
        return
            function()
                if textureRes == 2 then
                    textureRes = 0;
                else
                    textureRes = textureRes + 1;
                end
                celestia:settextureresolution(textureRes);
                textureResCheckBox.Text = textureRes;
            end
        end) ();

--[[informationTextBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(ctext)
    :movetext(18, 3)
    :text(_("Information Text"))
    :movable(false)
    :attach(renderFrame, informationTextLeftOffset, renderFrameHeight-informationTextUpOffset-informationTextBoxH,
                renderFrameWidth-informationTextLeftOffset-informationTextBoxW, informationTextUpOffset);

informationTextCheckBox = CXBox:new()
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
        :attach(informationTextBox, 2, 4, 133, 5)

setInformationTextCheckBoxText(verbosity);

informationTextBox.Customdraw =
    function(this)
        if informationText ~= celestia:getverbosity() then
            informationText = celestia:getverbosity();
            informationTextCheckBox.Text = tostring(verbosity);
        end
    end;

informationTextCheckBox.Action = (function()
        return
            function()
                verbosity = verbosity + 1;
                if verbosity > 3 then
                    verbosity = 1;
                end
                celestia:setverbosity(verbosity);
                informationTextCheckBox.Text = tostring(verbosity);
            end
        end) ();
]]