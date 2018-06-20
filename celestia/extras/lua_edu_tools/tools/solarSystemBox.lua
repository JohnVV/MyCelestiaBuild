require "locale";
require "closeButton";
require "scrollButton";

----------------------------------------------
-- Load images.
----------------------------------------------
startImage = celestia:loadtexture("../images/start_button.png");
endImage = celestia:loadtexture("../images/end_button.png");

----------------------------------------------
-- Define local functions
----------------------------------------------
local makeChildrenBox = function(childrenBox, k, leftOffset)
    childrenBox[k] = CXBox:new()
        :init(0, 0, 0, 0)
        --:bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(normalfont)
        :textcolor(cbutextoff)
        :movetext(0, 6)
        :text("")
        :movable(false)
        :active(true)
        :attach(solsysFrame, leftOffset+5, solsysFrameHeight-52-(18*k), solsysFrameWidth-leftOffset-85, 37+(18*k))
end

local makeEtcBox = function(leftOffset)
    etcBox = CXBox:new()
        :init(0, 0, 0, 0)
        --:fillcolor(csetbofill)
        --:bordercolor(cbubordoff)
        :textfont(normalfont)
        :textcolor(cclotext)
        --:textpos("center")
        :movetext(1, 12)
        :text("...")
        :movable(false)
        :attach(solsysFrame, leftOffset+5, 20, solsysFrameWidth-leftOffset-85, solsysFrameHeight-20-10)
    return etcBox;
end

local makePrefixBox = function(prefixBox, k, leftOffset)
    prefixBox[k] = CXBox:new()
        :init(0, 0, 0, 0)
        :bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(smallfont)
        :textcolor(cbutextoff)
        :textpos("center")
        :movetext(0, 10)
        :text("+")
        :movable(false)
        :active(true)
        :visible(false)
        :attach(solsysFrame, leftOffset-4, solsysFrameHeight-49-(18*k), solsysFrameWidth-leftOffset-5, 40+(18*k))
end

local makeStartBox = function(startBox, k, leftOffset)
    startBox[k] = CXBox:new()
        :init(0, 0, 0, 0)
        --:bordercolor(cbubordoff)
        :fillimage(startImage)
        --:fillcolor({1,1,0,.2})
        --:textfont(smallfont)
        --:textcolor(cbutextoff)
        --:textpos("center")
        --:movetext(0, 10)
        --:text("")
        :movable(false)
        :active(true)
        :visible(false)
        :attach(solsysFrame, leftOffset+85, solsysFrameHeight-50-(18*k), solsysFrameWidth-leftOffset-93, 41+(18*k))
end

local makeEndBox = function(endBox, k, leftOffset)
    endBox[k] = CXBox:new()
        :init(0, 0, 0, 0)
        --:bordercolor(cbubordoff)
        :fillimage(endImage)
        --:fillcolor({1,1,0,.2})
        --:textfont(smallfont)
        --:textcolor(cbutextoff)
        --:textpos("center")
        --:movetext(0, 10)
        --:text("")
        :movable(false)
        :active(true)
        :visible(false)
        :attach(solsysFrame, leftOffset+95, solsysFrameHeight-50-(18*k), solsysFrameWidth-leftOffset-103, 41+(18*k))
end

local makeChildScrollbarFrame = function(leftOffset)
    childScrollbarFrame = CXBox:new()
        --:bordercolor(cbubordoff)
        --:fillcolor({.2,.2,.6,.1})
        :visible(true)
        :attach(solsysFrame, leftOffset+90, 30, solsysFrameWidth-leftOffset-90-childScrollbarFrameW, solsysFrameHeight-30-childScrollbarFrameH)
    return childScrollbarFrame;
end

local makeChildScrollbarBox = function(childScrollbarFrame, leftOffset, nChildren)
    childScrollbarBox = CXBox:new()
        :bordercolor(cbubordoff)
        :fillcolor(cscrollfill)
        :visible(true)
        :movable(true)
        :attach(childScrollbarFrame, 0, (nChildren-nChildrenMax)*solsysScrollCoeff, 0, 3)
    return childScrollbarBox;
end

local makeChildScrollUpButton = function(childScrollbarFrame)
    childScrollUpButton = CXBox:new()
        :init(0, 0, 0, 0)
        --:fillcolor(csetbofill)
        --:bordercolor(cbubordoff)
        :textfont(titlefont)
        :textcolor(cclotext)
        --:textpos("center")
        :movetext(-4, -1)
        :text(_("ˆ"))
        :movable(false)
        :attach(childScrollbarFrame, 0, childScrollbarFrameH, 0, -11);
    return childScrollUpButton;
end

local makeChildScrollDownButton = function(childScrollbarFrame)
    childScrollDownButton = CXBox:new()
        :init(0, 0, 0, 0)
        --:fillcolor(csetbofill)
        --:bordercolor(cbubordoff)
        :textfont(titlefont)
        :textcolor(cclotext)
        --:textpos("center")
        :movetext(-4, -1)
        :text(_("ˇ"))
        :movable(false)
        :attach(childScrollbarFrame, 0, -11, 0,childScrollbarFrameH);    -- Inverted but OK (not active).
    return childScrollDownButton;
end

local refreshChildScrollbarFrame = function(childScrollbarFrame, childScrollbarBox)
    local lb3,bb3,rb3,tb3 = childScrollbarFrame:bounds();
    local lb4,bb4,rb4,tb4 = childScrollbarBox:bounds();
    childScroll = math_round((tb3-tb4-3)/solsysScrollCoeff);
    return childScroll
end

local refreshChildScrollbarBox = function(childScrollbarFrame, childScrollbarBox, childScroll, childScrollbarBoxH, nChildren)
    if resetScrollPos then
        if nChildren < 4000 then
            solsysScrollCoeff = 25*math.log(nChildren)/(nChildren-nChildrenMax)
        else
            solsysScrollCoeff = 200/(nChildren-nChildrenMax)
        end
        childScrollbarBoxH = childScrollbarFrameH-6-(nChildren-nChildrenMax)*solsysScrollCoeff
        childScrollbarBox:attach(childScrollbarFrame, 0, childScrollbarFrameH-childScrollbarBoxH-3, 0, 3)
    end
end

local setScrollbarVisibility = function(childScrollbarFrame, nChildren)
    if nChildren > nChildrenMax then
        childScrollbarFrame.Visible = true;
    else
        childScrollbarFrame.Visible = false;
    end
end

local setEtcBoxVisibility = function(childEtcBox, childScroll, nChildren)
    if childScroll < nChildren-nChildrenMax then
        childEtcBox.Visible = true;
    else
        childEtcBox.Visible = false;
    end
end

local getSolarSystemElements = function()
    local sel = celestia:getselection();
    if selection then
        parent = sel;
        while parent:type() ~= "star" do
            parent = parent:getinfo().parent
        end
        children = parent:getchildren();
        for k, v in ipairs(children) do
            if v:type() == "invisible" or v:name() == "" then
                table.remove(children, k)
            end
        end
        nchildren = table.getn(children);
        return parent, children, nchildren;
    end
end

local deleteChildrenNames = function()
    for k = 1, nChildrenMax do
        planetBox[k].Text = "";
        dwarfplanetBox[k].Text = "";
        asteroidBox[k].Text = "";
        moonBox[k].Text = "";
        minormoonBox[k].Text = "";
        cometBox[k].Text = "";
        spacecraftBox[k].Text = "";
    end
end

local removeNumberFromName = function(name)
    pos = string.find(name, ' ');
    if pos then
        num =  tonumber(string.sub(name, 0, pos-1));
        if num and (num < 1998 or num > 2010) then
            name = string.sub(name, pos + 1);
        end
    end
    return name;
end

local resetScroll = function()
    dwarfplanetScroll = 0;
    asteroidScroll = 0;
    moonScroll = 0;
    minormoonScroll = 0;
    cometScroll = 0;
    spacecraftScroll = 0;
end

local resetAllScrolls = function()
    planetScroll = 0;
    dwarfplanetScroll = 0;
    asteroidScroll = 0;
    moonScroll = 0;
    minormoonScroll = 0;
    cometScroll = 0;
    spacecraftScroll = 0;
end

local emptyClasses = function()
    dwarfplanets = {};
    asteroids = {};
    moons = {};
    minormoons = {};
    comets = {};
    spacecraft = {};
end

local emptyAllClasses = function()
    planets = {};
    dwarfplanets = {};
    asteroids = {};
    moons = {};
    minormoons = {};
    comets = {};
    spacecraft = {};
end

local setPrefix = function(prefixBox, k, nchild)
    if nchild > 0 then
        prefixBox[k].Visible = true;
    else
        prefixBox[k].Visible = false;
    end
end

local setStart = function(startBox, k, startdate)
    if startdate and not string.find(startdate, "INF") then
        startBox[k].Visible = true;
    else
        startBox[k].Visible = false;
    end
end

local setEnd = function(endBox, k, enddate)
    if enddate and not string.find(enddate, "INF") then
        endBox[k].Visible = true;
    else
        endBox[k].Visible = false;
    end
end

local setBoxTextColorOff = function(box)
    for k, v in pairs(box) do
        v.Textcolor = cbutextoff;
    end
end

local setBoxBorderColorOff = function(box)
    for k, v in pairs(box) do
        v.Bordercolor = cbubordoff;
    end
end

local setObjectColorsOff = function()
    starBox.Textcolor = cbutextoff;
    setBoxTextColorOff(planetBox);
    setBoxTextColorOff(dwarfplanetBox);
    setBoxTextColorOff(asteroidBox);
    setBoxTextColorOff(moonBox);
    setBoxTextColorOff(minormoonBox);
    setBoxTextColorOff(cometBox);
    setBoxTextColorOff(spacecraftBox);
end

local setPrefixColorsOff = function()
    setBoxTextColorOff(planetPrefixBox);
    setBoxTextColorOff(dwarfplanetPrefixBox);
    setBoxTextColorOff(asteroidPrefixBox);
    setBoxTextColorOff(moonPrefixBox);
    setBoxTextColorOff(minormoonPrefixBox);
    setBoxTextColorOff(cometPrefixBox);
    setBoxTextColorOff(spacecraftPrefixBox);

    setBoxBorderColorOff(planetPrefixBox);
    setBoxBorderColorOff(dwarfplanetPrefixBox);
    setBoxBorderColorOff(asteroidPrefixBox);
    setBoxBorderColorOff(moonPrefixBox);
    setBoxBorderColorOff(minormoonPrefixBox);
    setBoxBorderColorOff(cometPrefixBox);
    setBoxBorderColorOff(spacecraftPrefixBox);
end

----------------------------------------------
-- Set initial values
----------------------------------------------
local star, starChildren, nStarChildren = getSolarSystemElements();
solsysFrameWidth, solsysFrameHeight = 560, 320;
childScrollbarFrameW, childScrollbarFrameH = 9, 220;

starLeftOffset = 7
planetLeftOffset = 15
dwarfplanetLeftOffset = 125
asteroidLeftOffset = 235;
moonLeftOffset = 235;
minormoonLeftOffset = 345;
cometLeftOffset = 345;
spacecraftLeftOffset = 455;

nChildrenMax = 13;
resetAllScrolls();
emptyAllClasses();

planetBox = {};
dwarfplanetBox = {};
moonBox = {};
minormoonBox = {};
cometBox = {};
asteroidBox = {};
spacecraftBox = {};

planetPrefixBox = {};
dwarfplanetPrefixBox = {};
moonPrefixBox = {};
minormoonPrefixBox = {};
cometPrefixBox = {};
asteroidPrefixBox = {};
spacecraftPrefixBox = {};

spacecraftStartBox = {};
spacecraftEndBox = {};

nPlanets = 0;
nDwarfPlanets = 0;
nAsteroids = 0;
nMoons = 0;
nMinorMoons = 0;
nComets = 0;
nSpacecraft = 0;

solsysScrollCoeff = 10;

planetScrollbarBoxH = 0;
dwarfplanetScrollbarBoxH = 0;
asteroidScrollbarBoxH = 0;
moonScrollbarBoxH = 0;
minormoonScrollbarBoxH = 0;
cometScrollbarBoxH = 0;
spacecraftScrollbarBoxH = 0;

----------------------------------------------
-- Set up and Draw the boxes
----------------------------------------------
solarSystemBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

solsysButton = CXBox:new()
    :init(0, 0, 0, 0)
    :bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :textpos("center")
    :movetext(0, 6)
    :text(_("Solar System Browser"))
    :movable(false)
    :active(true)
    :attach(solarSystemBox, 8, 4, 8, 3)

solsysButton.Action = (function()
    return
        function()
            starName = nil;
            solsysFrame.Visible = not(solsysFrame.Visible);
            if solsysFrame.Visible then
                solsysFrame:orderfront();
                solsysButton.Bordercolor = cbubordon;
                solsysButton.Fillcolor = {cbubordon[1]*2/3, cbubordon[2]*2/3, cbubordon[3]*2/3, cbubordon[4]/2};
            else
                solsysButton.Bordercolor = cbubordoff;
                solsysButton.Fillcolor = nil;
            end
        end
    end) ();

solsysFrame = CXBox:new()
    :init(0, 0, 0, 0)
    :fillcolor(csetbofill)
    --:bordercolor(cbubordoff)
    :movable(false)
    :visible(false)
    :attach(screenBox, (width-solsysFrameWidth)/2, 0, (width-solsysFrameWidth)/2, height-solsysFrameHeight);

solsysFrame.Customdraw =
    function(this)
        local sel = celestia:getselection();
        if selection and sel:type() ~= "galaxy" and sel:type() ~= "nebula" and sel:type() ~= "opencluster" then
            star, starChildren, nStarChildren = getSolarSystemElements();
            resetScrollPos = false;
            starBox.Visible = true;
            setObjectColorsOff();
            setPrefixColorsOff();
            if parentObj and parentObjChanged then
                parentObjChanged = false;
                resetScrollPos = true;
                emptyClasses();
                resetScroll();
                children = parentObj:getchildren();
                for k, v in ipairs(children) do
                    if v:name() ~= "" and v:visible() then
                        if v:type() == "asteroid" then
                            table.insert(asteroids, v);
                        elseif v:type() == "moon" then
                            table.insert(moons, v);
                        elseif v:type() == "minormoon" then
                            table.insert(minormoons, v);
                        elseif v:type() == "spacecraft" then
                            table.insert(spacecraft, v);
                        end
                    end
                end
                nDwarfPlanets = 0;
                nMoons = table.getn(moons);
                nMinorMoons = table.getn(minormoons);
                nComets = 0;
                nAsteroids = table.getn(asteroids);
                nSpacecraft = table.getn(spacecraft);
                parentObj_str = _("Bodies orbiting")..' '..limitStrWidth(getlocalname(parentObj), normalfont, 100)..' :';
            end
            if star and starName ~= getlocalname(star) then
                starName = getlocalname(star);
                resetScrollPos = true;
                starBox.Text = limitStrWidth(starName, normalfont, 100);
                parentObj = star;
                emptyAllClasses();
                resetAllScrolls();
                for k, v in ipairs(starChildren) do
                    if v:name() ~= "" and v:visible() then
                        if v:type() == "planet" then
                            table.insert(planets, v)
                        elseif v:type() == "dwarfplanet" then
                            table.insert(dwarfplanets, v)
                        elseif v:type() == "asteroid" then
                            table.insert(asteroids, v)
                        elseif v:type() == "comet" then
                            table.insert(comets, v)
                        elseif v:type() == "spacecraft" then
                            table.insert(spacecraft, v)
                        end
                    end
                end
                nPlanets = table.getn(planets);
                nDwarfPlanets = table.getn(dwarfplanets);
                nMoons = 0;
                nMinorMoons = 0;
                nAsteroids = table.getn(asteroids);
                nComets = table.getn(comets);
                nSpacecraft = table.getn(spacecraft);
                if nAsteroids == 0 and nComets == 0 and nSpacecraft == 0 then
                    parentObj_str = "";
                else
                    parentObj_str = _("Other bodies orbiting")..' '..limitStrWidth(getlocalname(parentObj), normalfont, 100)..' :';
                end
            end
            -- We start displaying the text on the second tick in order to
            -- hide a possible uggly resizing of the box during the first tick.
            if solsys_firstTickDone then
                textlayout:setfont(normalfont);
                textlayout:setfontcolor(ctext);
                textlayout:setpos(this.lb+moonLeftOffset+10, this.tb-15);
                textlayout:println(parentObj_str);
                textlayout:setfontcolor(ctext);

                if not(solsysCloseButtonDone) then
                    solsysCloseButtonDone = true;
                    makeCloseButton(solsysCloseButton, solsysFrame, solsysButton);
                end

                if nPlanets > 0 then
                    textlayout:setpos(this.lb+planetLeftOffset+5, this.tb-45);
                    textlayout:println(_("Planets").." :");
                end
                if nDwarfPlanets > 0 then
                    textlayout:setpos(this.lb+dwarfplanetLeftOffset+5, this.tb-45);
                    textlayout:println(_("Dwarf Planets").." :");
                end
                if nComets > 0 then
                    textlayout:setpos(this.lb+cometLeftOffset+5, this.tb-45);
                    textlayout:println(_("Comets").." :");
                end
                if nMoons > 0 then
                    textlayout:setpos(this.lb+moonLeftOffset+5, this.tb-45);
                    textlayout:println(_("Moons").." :");
                end
                if nMinorMoons > 0 then
                    textlayout:setpos(this.lb+minormoonLeftOffset+5, this.tb-45);
                    textlayout:println(_("Minor Moons").." :");
                end
                if nAsteroids > 0 then
                    textlayout:setpos(this.lb+asteroidLeftOffset+5, this.tb-45);
                    textlayout:println(_("Asteroids").." :");
                end
                if nSpacecraft > 0 then
                    textlayout:setpos(this.lb+spacecraftLeftOffset+5, this.tb-45);
                    textlayout:println(_("Spacecraft").." :");
                end
            else
                solsys_firstTickDone = true;
            end
            for k = 1, nChildrenMax do
                if planets[k+planetScroll] then
                    planetBox[k].Visible = true;
                    local child = planets[k+planetScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(planetPrefixBox, k, nchild);
                    planetBox[k].Text = limitStrWidth(getlocalname(planets[k + planetScroll]), normalfont, 77);
                else
                    planetBox[k].Visible = false;
                    planetPrefixBox[k].Visible = false;
                end
                if dwarfplanets[k+dwarfplanetScroll] then
                    dwarfplanetBox[k].Visible = true;
                    local child = dwarfplanets[k+dwarfplanetScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(dwarfplanetPrefixBox, k, nchild);
                    dwarfplanetBox[k].Text = limitStrWidth(removeNumberFromName(getlocalname(dwarfplanets[k + dwarfplanetScroll])), normalfont, 77);
                else
                    dwarfplanetBox[k].Visible = false;
                    dwarfplanetPrefixBox[k].Visible = false;
                end
                if asteroids[k+asteroidScroll] then
                    asteroidBox[k].Visible = true;
                    local child = asteroids[k+asteroidScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(asteroidPrefixBox, k, nchild);
                    asteroidBox[k].Text = limitStrWidth(removeNumberFromName(getlocalname(asteroids[k+asteroidScroll])), normalfont, 77);
                else
                    asteroidBox[k].Visible = false;
                    asteroidPrefixBox[k].Visible = false;
                end
                if moons[k+moonScroll] then
                    moonBox[k].Visible = true;
                    local child = moons[k+moonScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(moonPrefixBox, k, nchild);
                    moonBox[k].Text = limitStrWidth(getlocalname(moons[k+moonScroll]), normalfont, 77);
                else
                    moonBox[k].Visible = false;
                    moonPrefixBox[k].Visible = false;
                end
                if minormoons[k+minormoonScroll] then
                    minormoonBox[k].Visible = true;
                    local child = minormoons[k+minormoonScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(minormoonPrefixBox, k, nchild);
                    minormoonBox[k].Text = limitStrWidth(getlocalname(minormoons[k+minormoonScroll]), normalfont, 77);
                else
                    minormoonBox[k].Visible = false;
                    minormoonPrefixBox[k].Visible = false;
                end
                if comets[k+cometScroll] then
                    cometBox[k].Visible = true;
                    local child = comets[k+cometScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(cometPrefixBox, k, nchild);
                    cometBox[k].Text = limitStrWidth(getlocalname(comets[k+cometScroll]), normalfont, 77);
                else
                    cometBox[k].Visible = false;
                    cometPrefixBox[k].Visible = false;
                end
                if spacecraft[k+spacecraftScroll] then
                    spacecraftBox[k].Visible = true;
                    local child = spacecraft[k+spacecraftScroll]:getchildren();
                    local nchild = table.getn(child);
                    setPrefix(spacecraftPrefixBox, k, nchild);
                    spacecraftBox[k].Text = limitStrWidth(getlocalname(spacecraft[k+spacecraftScroll]), normalfont, 77);
                    local startdate = spacecraft[k+spacecraftScroll]:getinfo().lifespanStart;
                    local enddate = spacecraft[k+spacecraftScroll]:getinfo().lifespanEnd;
                    setStart(spacecraftStartBox, k, startdate);
                    setEnd(spacecraftEndBox, k, enddate);
                else
                    spacecraftBox[k].Visible = false;
                    spacecraftPrefixBox[k].Visible = false;
                    spacecraftStartBox[k].Visible = false;
                    spacecraftEndBox[k].Visible = false;
                end
            end

            setScrollbarVisibility(planetScrollbarFrame, nPlanets);
            setScrollbarVisibility(dwarfplanetScrollbarFrame, nDwarfPlanets);
            setScrollbarVisibility(asteroidScrollbarFrame, nAsteroids);
            setScrollbarVisibility(moonScrollbarFrame, nMoons);
            setScrollbarVisibility(minormoonScrollbarFrame, nMinorMoons);
            setScrollbarVisibility(cometScrollbarFrame, nComets);
            setScrollbarVisibility( spacecraftScrollbarFrame, nSpacecraft);

            setEtcBoxVisibility(planetEtcBox, planetScroll, nPlanets);
            setEtcBoxVisibility(dwarfplanetEtcBox, dwarfplanetScroll, nDwarfPlanets);
            setEtcBoxVisibility(asteroidEtcBox, asteroidScroll, nAsteroids);
            setEtcBoxVisibility(moonEtcBox, moonScroll, nMoons);
            setEtcBoxVisibility(minormoonEtcBox, minormoonScroll, nMinorMoons);
            setEtcBoxVisibility(cometEtcBox, cometScroll, nComets);
            setEtcBoxVisibility(spacecraftEtcBox, spacecraftScroll, nSpacecraft);
        else
            star = nil;
            starName = nil;
            parentObj = nil;
            deleteChildrenNames();
            setPrefixColorsOff();
            starBox.Visible = false;
            planetScrollbarFrame.Visible = false;
            planetEtcBox.Visible = false;
            dwarfplanetScrollbarFrame.Visible = false;
            dwarfplanetEtcBox.Visible = false;
            asteroidScrollbarFrame.Visible = false;
            asteroidEtcBox.Visible = false;
            moonScrollbarFrame.Visible = false;
            moonEtcBox.Visible = false;
            minormoonScrollbarFrame.Visible = false;
            minormoonEtcBox.Visible = false;
            cometScrollbarFrame.Visible = false;
            cometEtcBox.Visible = false;
            spacecraftScrollbarFrame.Visible = false;
            spacecraftEtcBox.Visible = false;
            for k = 1, nChildrenMax do
                planetPrefixBox[k].Visible = false;
                dwarfplanetPrefixBox[k].Visible = false;
                asteroidPrefixBox[k].Visible = false;
                moonPrefixBox[k].Visible = false;
                minormoonPrefixBox[k].Visible = false;
                cometPrefixBox[k].Visible = false;
                spacecraftPrefixBox[k].Visible = false;
                spacecraftStartBox[k].Visible = false;
                spacecraftEndBox[k].Visible = false;
            end
        end
        if newselection then
            setObjectColorsOff();
            setPrefixColorsOff();
        end
        if starName == getlocalname(sel) then
            starBox.Textcolor = cbutexton;
        end
        for k = 1, nChildrenMax do
            if getlocalname(planets[k+planetScroll]) == getlocalname(sel) then
                planetBox[k].Textcolor = cbutexton;
            end
            if getlocalname(dwarfplanets[k+dwarfplanetScroll]) == getlocalname(sel) then
                dwarfplanetBox[k].Textcolor = cbutexton;
            end
            if getlocalname(asteroids[k+asteroidScroll]) == getlocalname(sel) then
                asteroidBox[k].Textcolor = cbutexton;
            end
            if getlocalname(moons[k+moonScroll]) == getlocalname(sel) then
                moonBox[k].Textcolor = cbutexton;
            end
            if getlocalname(minormoons[k+minormoonScroll]) == getlocalname(sel) then
                minormoonBox[k].Textcolor = cbutexton;
            end
            if getlocalname(comets[k+cometScroll]) == getlocalname(sel) then
                cometBox[k].Textcolor = cbutexton;
            end
            if getlocalname(spacecraft[k+spacecraftScroll]) == getlocalname(sel) then
                spacecraftBox[k].Textcolor = cbutexton;
            end
            if getlocalname(planets[k+planetScroll]) == getlocalname(parentObj) then
                planetPrefixBox[k].Textcolor = cbutexton;
                planetPrefixBox[k].Bordercolor = cbubordon;
            end
            if getlocalname(dwarfplanets[k+dwarfplanetScroll]) == getlocalname(parentObj) then
                dwarfplanetPrefixBox[k].Textcolor = cbutexton;
                dwarfplanetPrefixBox[k].Bordercolor = cbubordon;
            end
            if getlocalname(asteroids[k+asteroidScroll]) == getlocalname(parentObj) then
                asteroidPrefixBox[k].Textcolor = cbutexton;
                asteroidPrefixBox[k].Bordercolor = cbubordon;
            end
            if getlocalname(moons[k+moonScroll]) == getlocalname(parentObj) then
                moonPrefixBox[k].Textcolor = cbutexton;
                moonPrefixBox[k].Bordercolor = cbubordon;
            end
            if getlocalname(minormoons[k+minormoonScroll]) == getlocalname(parentObj) then
                minormoonPrefixBox[k].Textcolor = cbutexton;
                minormoonPrefixBox[k].Bordercolor = cbubordon;
            end
            if getlocalname(comets[k+cometScroll]) == getlocalname(parentObj) then
                cometPrefixBox[k].Textcolor = cbutexton;
                cometPrefixBox[k].Bordercolor = cbubordon;
            end
            if getlocalname(spacecraft[k+ spacecraftScroll]) == getlocalname(parentObj) then
                spacecraftPrefixBox[k].Textcolor = cbutexton;
                spacecraftPrefixBox[k].Bordercolor = cbubordon;
            end
        end

        -- We add the scrollButton on the second tick
        -- when bounds are getting updated.
        if solsysScroll_firstTickDone then
            if not(solsysScrollButtonDone) then
                solsysScrollButtonDone = true;
                makeScrollButton(planetScrollUpButton, planetScrollDownButton, planetScrollbarFrame);
                makeScrollButton(dwarfplanetScrollUpButton, dwarfplanetScrollDownButton, dwarfplanetScrollbarFrame);
                makeScrollButton(asteroidScrollUpButton, asteroidScrollDownButton, asteroidScrollbarFrame);
                makeScrollButton(moonScrollUpButton, moonScrollDownButton, moonScrollbarFrame);
                makeScrollButton(minormoonScrollUpButton, minormoonScrollDownButton, minormoonScrollbarFrame);
                makeScrollButton(cometScrollUpButton, cometScrollDownButton, cometScrollbarFrame);
                makeScrollButton(spacecraftScrollUpButton, spacecraftScrollDownButton, spacecraftScrollbarFrame);
            end
        else
            solsysScroll_firstTickDone = true;
        end

        solsysFrame:attach(screenBox, (width-solsysFrameWidth)/2, 0, (width-solsysFrameWidth)/2, height-solsysFrameHeight);
    end;

starBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    --:fillcolor({1,1,0,.2})
    :textfont(normalfont)
    :textcolor(cbutextoff)
    :movetext(-3, 6)
    :text("")
    :movable(false)
    :active(true)
    :attach(solsysFrame, starLeftOffset, solsysFrameHeight-4-20, solsysFrameWidth-100, 9)

starBox.Action = (function()
    return
        function()
            celestia:select(star);
            parentObj = star;
            starName = nil;
        end
    end) ();

for k = 1, nChildrenMax do
    makeChildrenBox(planetBox, k, planetLeftOffset)
    makeChildrenBox(dwarfplanetBox, k, dwarfplanetLeftOffset)
    makeChildrenBox(asteroidBox, k, asteroidLeftOffset)
    makeChildrenBox(moonBox, k, moonLeftOffset)
    makeChildrenBox(minormoonBox, k, minormoonLeftOffset)
    makeChildrenBox(cometBox, k, cometLeftOffset)
    makeChildrenBox(spacecraftBox, k, spacecraftLeftOffset)
    makePrefixBox(planetPrefixBox, k, planetLeftOffset)
    makePrefixBox(dwarfplanetPrefixBox, k, dwarfplanetLeftOffset)
    makePrefixBox(asteroidPrefixBox, k, asteroidLeftOffset)
    makePrefixBox(moonPrefixBox, k, moonLeftOffset)
    makePrefixBox(minormoonPrefixBox, k, minormoonLeftOffset)
    makePrefixBox(cometPrefixBox, k, cometLeftOffset)
    makePrefixBox(spacecraftPrefixBox, k, spacecraftLeftOffset)
    makeStartBox(spacecraftStartBox, k, spacecraftLeftOffset)
    makeEndBox(spacecraftEndBox, k, spacecraftLeftOffset)

local kk = k;

planetBox[k].Action = (function()
    return
        function()
            celestia:select(planets[kk+planetScroll]);
        end
    end) ();

dwarfplanetBox[k].Action = (function()
    return
        function()
            celestia:select(dwarfplanets[kk+dwarfplanetScroll]);
        end
    end) ();

asteroidBox[k].Action = (function()
    return
        function()
            celestia:select(asteroids[kk+asteroidScroll]);
        end
    end) ();

moonBox[k].Action = (function()
    return
        function()
            celestia:select(moons[kk+moonScroll]);
        end
    end) ();

minormoonBox[k].Action = (function()
    return
        function()
            celestia:select(minormoons[kk+minormoonScroll]);
        end
    end) ();

cometBox[k].Action = (function()
    return
        function()
            celestia:select(comets[kk+cometScroll]);
        end
    end) ();

spacecraftBox[k].Action = (function()
    return
        function()
            celestia:select(spacecraft[kk+spacecraftScroll]);
        end
    end) ();

planetPrefixBox[k].Action = (function()
    return
        function()
            parentObj = planets[kk+planetScroll];
            parentObjChanged = true;
        end
    end) ();

dwarfplanetPrefixBox[k].Action = (function()
    return
        function()
            parentObj = dwarfplanets[kk+dwarfplanetScroll];
            parentObjChanged = true;
        end
    end) ();

asteroidPrefixBox[k].Action = (function()
    return
        function()
            parentObj = asteroids[kk+asteroidScroll];
            parentObjChanged = true;
        end
    end) ();

moonPrefixBox[k].Action = (function()
    return
        function()
            parentObj = moons[kk+moonScroll];
            parentObjChanged = true;
        end
    end) ();

minormoonPrefixBox[k].Action = (function()
    return
        function()
            parentObj = minormoons[kk+minormoonScroll];
            parentObjChanged = true;
        end
    end) ();

cometPrefixBox[k].Action = (function()
    return
        function()
            parentObj = comets[kk+cometScroll];
            parentObjChanged = true;
        end
    end) ();

spacecraftPrefixBox[k].Action = (function()
    return
        function()
            parentObj = spacecraft[kk+spacecraftScroll];
            parentObjChanged = true;
        end
    end) ();

spacecraftStartBox[k].Action = (function()
    return
        function()
            local startdate = spacecraft[kk+spacecraftScroll]:getinfo().lifespanStart;
            celestia:settime(startdate);
        end
    end) ();

spacecraftEndBox[k].Action = (function()
    return
        function()
            local enddate = spacecraft[kk+spacecraftScroll]:getinfo().lifespanEnd;
            celestia:settime(enddate);
        end
    end) ();

end

planetEtcBox = makeEtcBox(planetLeftOffset)
dwarfplanetEtcBox = makeEtcBox(dwarfplanetLeftOffset)
asteroidEtcBox = makeEtcBox(asteroidLeftOffset)
moonEtcBox = makeEtcBox(moonLeftOffset)
minormoonEtcBox = makeEtcBox(minormoonLeftOffset)
cometEtcBox = makeEtcBox(cometLeftOffset)
spacecraftEtcBox = makeEtcBox(spacecraftLeftOffset)

planetScrollbarFrame = makeChildScrollbarFrame(planetLeftOffset);
dwarfplanetScrollbarFrame = makeChildScrollbarFrame(dwarfplanetLeftOffset);
asteroidScrollbarFrame = makeChildScrollbarFrame(asteroidLeftOffset);
moonScrollbarFrame = makeChildScrollbarFrame(moonLeftOffset);
minormoonScrollbarFrame = makeChildScrollbarFrame(minormoonLeftOffset);
cometScrollbarFrame = makeChildScrollbarFrame(cometLeftOffset);
spacecraftScrollbarFrame = makeChildScrollbarFrame(spacecraftLeftOffset);

planetScrollbarBox = makeChildScrollbarBox(planetScrollbarFrame, planetLeftOffset, nPlanets);
dwarfplanetScrollbarBox = makeChildScrollbarBox(dwarfplanetScrollbarFrame, dwarfplanetLeftOffset, nDwarfPlanets);
asteroidScrollbarBox = makeChildScrollbarBox(asteroidScrollbarFrame, asteroidLeftOffset, nAsteroids);
moonScrollbarBox = makeChildScrollbarBox(moonScrollbarFrame, moonLeftOffset, nMoons);
minormoonScrollbarBox = makeChildScrollbarBox(minormoonScrollbarFrame, minormoonLeftOffset, nMinorMoons);
cometScrollbarBox = makeChildScrollbarBox(cometScrollbarFrame, cometLeftOffset, nComets);
spacecraftScrollbarBox = makeChildScrollbarBox(spacecraftScrollbarFrame, spacecraftLeftOffset, nSpacecraft);

planetScrollbarFrame.Customdraw =
    function(this)
        planetScroll = refreshChildScrollbarFrame(planetScrollbarFrame, planetScrollbarBox);
    end;

planetScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(planetScrollbarFrame,planetScrollbarBox, planetScroll, planetScrollbarBoxH, nPlanets)
    end;

dwarfplanetScrollbarFrame.Customdraw =
    function(this)
        dwarfplanetScroll = refreshChildScrollbarFrame(dwarfplanetScrollbarFrame, dwarfplanetScrollbarBox);
    end;

dwarfplanetScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(dwarfplanetScrollbarFrame,dwarfplanetScrollbarBox, dwarfplanetScroll, dwarfplanetScrollbarBoxH, nDwarfPlanets)
    end;

asteroidScrollbarFrame.Customdraw =
    function(this)
        asteroidScroll = refreshChildScrollbarFrame(asteroidScrollbarFrame, asteroidScrollbarBox);
    end;

asteroidScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(asteroidScrollbarFrame, asteroidScrollbarBox, asteroidScroll, asteroidScrollbarBoxH, nAsteroids)
    end;

moonScrollbarFrame.Customdraw =
    function(this)
        moonScroll = refreshChildScrollbarFrame(moonScrollbarFrame, moonScrollbarBox);
    end;

moonScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(moonScrollbarFrame, moonScrollbarBox, moonScroll, moonScrollbarBoxH, nMoons)
    end;

minormoonScrollbarFrame.Customdraw =
    function(this)
        minormoonScroll = refreshChildScrollbarFrame(minormoonScrollbarFrame, minormoonScrollbarBox);
    end;

minormoonScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(minormoonScrollbarFrame, minormoonScrollbarBox, minormoonScroll, minormoonScrollbarBoxH, nMinorMoons)
    end;

cometScrollbarFrame.Customdraw =
    function(this)
        cometScroll = refreshChildScrollbarFrame(cometScrollbarFrame, cometScrollbarBox);
    end;

cometScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(cometScrollbarFrame, cometScrollbarBox, cometScroll, cometScrollbarBoxH, nComets)
    end;

spacecraftScrollbarFrame.Customdraw =
    function(this)
        spacecraftScroll = refreshChildScrollbarFrame(spacecraftScrollbarFrame, spacecraftScrollbarBox);
    end;

spacecraftScrollbarBox.Customdraw =
    function(this)
        refreshChildScrollbarBox(spacecraftScrollbarFrame, spacecraftScrollbarBox, spacecraftScroll, spacecraftScrollbarBoxH, nSpacecraft)
    end;


