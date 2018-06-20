-- lua_edu_tools.lua

require "celutil";
require "textlayout";
require "format";
require "config";
require "CXBox";
require "locale";

celestia:log("lua_edu_tools");

----------------------------------------------
-- Define local functions
----------------------------------------------
local setTimeOverlay =
    function()
        for i = 1, table.getn(toolset) do
            if toolset[i] == "timeBox" then
                celestia:setoverlayelements{ Time = false };
                break
            else
                celestia:setoverlayelements{ Time = true };
            end
        end
    end

local setFrameOverlay =
    function()
        for i = 1, table.getn(toolset) do
            if toolset[i] == "obsModeBox" then
                celestia:setoverlayelements{ Frame = false };
                break
            else
                celestia:setoverlayelements{ Frame = true };
            end
        end
    end

local beginScreenDraw =
    function()
        gl.MatrixMode(gl.PROJECTION);
        gl.PushMatrix();
        gl.LoadIdentity();
        sx,sy = celestia:getscreendimension();
        gl.Ortho(0, sx, 0, sy, 0, 1);
        gl.MatrixMode(gl.MODELVIEW);
        gl.PushMatrix();
        gl.LoadIdentity();
        gl.Disable(gl.TEXTURE_2D);
        gl.Disable(gl.LIGHTING);
        gl.Enable(gl.TEXTURE_2D);
        gl.Enable(gl.BLEND);
        gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    end;

local endScreenDraw =
    function()
        gl.MatrixMode(gl.PROJECTION);
        gl.PopMatrix();
        gl.MatrixMode(gl.MODELVIEW);
        gl.PopMatrix();
    end;

local changeOrbitDistance =
    function(d)
        center = obs:getframe():getrefobject();
        if empty(center) or not empty(sel) then
            center = sel;
            obs:setframe(celestia:newframe(obs:getframe():getcoordinatesystem(), center));
        end
        if not empty(center) then
            obsPos = obs:getposition();
            focusPosition = center:getposition();
            size = center:radius();
            minOrbitDistance = size * MLY_PER_KM;
            naturalOrbitDistance = (4.0 * minOrbitDistance);
            v = focusPosition:vectorto(obsPos);
            currentDistance = v:length();
            if currentDistance < minOrbitDistance then
                minOrbitDistance = currentDistance * 0.5;
            end
            if currentDistance >= minOrbitDistance and naturalOrbitDistance ~= 0 then
                r = (currentDistance - minOrbitDistance) / naturalOrbitDistance;
                newDistance = minOrbitDistance + naturalOrbitDistance * math.exp(math.log(r) + d);
                v = v * (newDistance / currentDistance);
                newPos = focusPosition:addvector( v );
                obs:setposition(newPos);
            end
        end
    end

----------------------------------------------
-- Define global functions
----------------------------------------------
empty =
    function(obj)
        return     obj == nil or obj:name() == "?";
    end

zoomToFit =
    function()
        local obs = celestia:getobserver()
        local obsPos = obs:getposition()
        local sel = celestia:getselection()
        if empty(sel) then return end
        local selPos = sel:getposition()
        local dist = obsPos:distanceto(selPos)
        local rad = sel:radius()
        local appDia = 2*math.atan(rad/dist)
        obs:setfov(appDia*1.20)
        celestia:flash("Zoom to fit "..sel:name(), 2)
    end;

customGoto = 
    function(obj)
        -- Goto selection and make it fit the screen.
        local obs = celestia:getobserver()
        if empty(obj) == true then
            local sel = celestia:getselection()
            obj = sel;
        end
        local fov = obs:getfov()
        if empty(obj) == false then
            obs:follow(obj);
            obs:gotodistance(obj, 5.5 * obj:radius() / (fov / 0.4688), custom_goto_duration)
        end
    end;

enableSmoothLines = 
    function()
        gl.Enable(gl.LINE_SMOOTH);
    gl.LineWidth(1.5);
   end;

disableSmoothLines = 
    function()
        gl.Disable(gl.LINE_SMOOTH);
    gl.LineWidth(1.0);
    end;
----------------------------------------------

dolly = {};

dolly.Speed = .2;
dolly.Rate  =  0;

dolly.start =
    function(dr)
        if dr == dolly.Rate then
            dolly.Rate = 0;
            return;
        end;
        obs = celestia:getobserver();
        sel = celestia:getselection();
        if empty(sel) then
            dolly.Rate = 0;
        else
            dolly.Rate = dr;
        end
    end

dolly.tick =
    function(dt)
        changeOrbitDistance( dt*dolly.Rate );
    end;

dolly.in2 =
    function()
        dolly.start(-dolly.Speed);
    end

dolly.out =
    function()
        dolly.start(dolly.Speed);
    end

----------------------------------------------
t0 = 0;
dt = 0;
alpha = 0;
overlay = {};
-- Get overlay.visible initial value from config.lua.
overlay.visible = show_lua_edu_tools;

notified1 = overlay.visible;
notified2 = not(overlay.visible);

-- Get the initial overlay elements table.
iOverlayElements = celestia:getoverlayelements()

if overlay.visible then
    -- Set the standard overlay elements when the Lua Edu Tools are enabled.
    setTimeOverlay();
    setFrameOverlay();
end

overlay.toggle =
    function()
        overlay.visible = not overlay.visible;
    end;

overlay.draw =
    function()
        local screenw, screenh = celestia:getscreendimension();
        if overlay.visible and screenw > 790 and screenh > toolBoxHeight+2 then
            -- Enable the Lua Edu Tools
            if notified1 == false then
                notified1 = true;
                notified2 = false;
                celestia:print(_("Lua Edu Tools enabled"));
                setToolBoxVisibility(true);
                -- Set the standard overlay elements when the Lua Edu Tools are enabled.
                setTimeOverlay();
                setFrameOverlay();
            end
            if alpha < 0.8 then
                -- Fade in effect.
                if t0 == 0 then
                    t0 = celestia:getscripttime();
                else
                    dt = celestia:getscripttime() - t0;
                    alpha = alpha + dt;
                end
            else
                alpha = 1;
                t0 = 0;
            end
        else
            -- Disable the Lua Edu Tools
            if alpha > 0 then
                -- Fade out effect.
                if t0 == 0 then
                    t0 = celestia:getscripttime();
                else
                    dt = celestia:getscripttime() - t0;
                    alpha = alpha - dt;
                end
            else
                t0 = 0;
                alpha = 0;
                if notified2 == false then
                    notified2 = true;
                    notified1 = false;
                    celestia:print(_("Lua Edu Tools disabled"));
                    setToolBoxVisibility(false);
                    -- Display initial overlay elements when the Lua Edu Tools are disabled.
                    celestia:setoverlayelements(iOverlayElements);
                end
            end
        end

        beginScreenDraw();
        screenBox:updatebounds();
        screenBox:drawall();
        endScreenDraw();

    end;

----------------------------------------------
-- Hook Event Handler
----------------------------------------------

keymap =
    {
         -- i = dolly.in2;
        -- o = dolly.out;
        -- z = zoomToFit;
        -- q = os.exit;
        I = overlay.toggle;
        G = customGoto;
     }

lua_edu_tools =
{

--[[mousemove =
    function(self,x,y)
        sx,sy = celestia:getscreendimension();
        screenBox:mousemove(x,sy-y)
    end;
    ]]

mousebuttondown =
    function(self,x,y,b)
        if eventeater then
            if eventeater:mousebuttondown(x,sy-y,b) then
                return true;
            end;
        end;
        sx,sy = celestia:getscreendimension();
        c = screenBox:findcontainer(x,sy-y);
        if c then
            return c:mousebuttondown(x,sy-y,b);
        end;
        return false;
    end;

keydown =
    function(self,ch,cmods)
        ch = string.char(ch);
        --[[if keymap[ch] then
            return true;
        else
            return false;
        end;]]
    end;

resize =
    function(self,x,y)
        screenBox:updatebounds();
        screenBox:adjustborders();
        return false;
    end;

mousebuttonmove =
    function(self,dx,dy,b)
        sx,sy = celestia:getscreendimension();
        if eventeater then
            return eventeater:mousebuttonmove(dx,-dy,b);
        end;
        return false;
    end;

mousebuttonup =
    function(self,x,y,b)
        sx,sy = celestia:getscreendimension();
        if eventeater then
            return eventeater:mousebuttonup(x,sy-y,b);
        end;
        return false;
    end;

charentered =
    function(self,ch)
        if eventeater then
            result = eventeater:charentered(ch);
            if result then return true end
        end;
        local f = keymap[ch]
        if f then
            f()
            return true;
        end
        return false;
    end;

renderoverlay =
    function(self)
        sx,sy = celestia:getscreendimension();
        if not titlefont then
            textlayout:getfonts();
            textlayout:init();
            textlayout:setfont(normalfont);
            textlayout:setlinespacing(20);
            require "toolBox";
        end;
        setLocaleNumeric("")
        overlay.draw();
        setLocaleNumeric("C")
        if lastTime == 0 then lastTime = celestia:getscripttime() end;
        currentTime = celestia:getscripttime();
        if dolly.Rate ~= 0 then
            dolly.tick( currentTime - lastTime );
        end
        lastTime = currentTime;
    end;
};

----------------------------------------------

require "screenBox";
screenBox.Toplevel = true;
celestia:log("lua_edu_tools");
print("lua_edu_tools");