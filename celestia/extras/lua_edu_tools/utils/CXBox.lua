-- CXBox.lua

require "CXClass"

----------------------------------------------------------------

inset =
    function(il,ir,pbl,pbr)
        local bl,br;
        local pw = pbr-pbl;
        if math.abs(il) <= 1 then xil = il* pw else xil = il end;
        if math.abs(ir) <= 1 then xir = ir* pw else xir = ir end;
        if il >= 0 then bl = pbl+xil end;
        if ir >= 0 then br = pbr-xir end;
        if il < 0 and ir < 0 then
            pc = pbl+pw/2;
            bl = pc+xil;
            br = pc-xir;
        elseif il < 0 then    -- ir >= 0
            bl = br+xil;
        elseif ir < 0  then -- il >= 0
            br = bl-xir;
        end; 
        return math_round(bl), math_round(br);
    end;

movelimit =
    function(x,il,ir,pbl,pbr)
        local bl, br = inset(il,ir,pbl,pbr);
        if br+x >= pbr-3 then x = pbr-br-3 end;
        if bl+x <= pbl+3 then x = pbl-bl+3 end;
        return x;
    end;

adjustinsets =
    function(x,il,ir,pbl,pbr)
        local pw = pbr-pbl;
        if il > 0 then
            if il > 1 then
                il = il + x;
            else
                il = il + x/pw;
            end;
        end;
        if ir > 0 then
            if ir > 1 then
                ir = ir - x;
            else
                ir = ir - x/pw;
            end;
        end;
        if il < 0 and ir < 0 then
            if il < -1 then
                il = il - x;
            else
                il = il - x/pw;
            end;
            if ir < -1 then
                ir = ir + x;
            else
                ir = ir + x/pw;
            end;
        end;
        return il,ir;
    end;

----------------------------------------------------------------

CXBox = 
    Class {
    classname = "CXBox";
    superclass = CXObject;
    init =
        function(this,x,y,w,h)
            this.Parent = nil;
            this.la = x;
            this.ba = y;
            this.ra = w;
            this.ta = h;
            this:updatebounds();
            this.Visible = true; 
            this.Movable = true; 
            this.Editable = false;
            return this;
        end;

----------------------------------------------------------------
-- debug methods

trace =
    function(this,msg)
        if not debug then print("no debug"); return end;
        local sourceinfo = debug.getinfo(2,"Snl");
        local sourcetext = (sourceinfo.name)..":"..(sourceinfo.currentline);
        if this.Text then
            print(sourcetext," ",msg,this.Text) else print (sourcetext,msg,"?") 
        end;
        print("  ",this.lb,this.bb,this.rb,this.tb);
        print("  ",this.la,this.ba,this.ra,this.ta);
    end;

----------------------------------------------------------------
-- accessor methods

fillcolor = function (this,c)
    if c then
        this.Fillcolor = c;
        return this;
    else
        return this.Fillcolor;
    end
end;
fillimage = function (this,i)
    if i then
        this.Fillimage = i;
        return this;
    else
        return this.Fillimage;
    end
end;
text = function (this,t)
    if t then
        this.Text = t;
        return this;
    else
        return this.Text;
    end
end;
movetext = function (this,dx,dy)
    if dx and dy then
        this.dx = dx;
        this.dy = dy;
        return this
    else
        return this.dx, this.dy;
    end
end;
textfont = function (this,f)
    if f then
        this.Textfont = f;
        return this;
    else
        return this.Textfont;
    end
end;
textcolor = function (this,c)
    if c then
        this.Textcolor = c;
        return this;
    else
        return this.Textcolor;
    end
end;
bordercolor = function (this,c)
    if c then
        this.Bordercolor = c;
        return this;
    else
        return this.Bordercolor;
    end
end;
fittotext = function(this, x)
    if x then
        this.Fittotext = x;
        return this;
    else
        return this.Fittotext;
    end
end;
textpos = function(this, s)
    if s then 
        this.Textpos = s;
        return this;
    else
        return this.Textpos;
    end
end;
visible = function (this,c)
    if c ~= nil then
        this.Visible = (c ~= false);
        return this;
    else
        return this.Visible or false;
    end
end;
movable = function (this,c)
    if c ~= nil then
        this.Movable = (c ~= false);
        return this;
    else
        return this.Movable or false;
    end
end;
editable = function (this,c)
    if c ~= nil then
        this.Editable = (c ~= false);
        return this;
    else
        return this.Editable or false;
    end
end;
active = function (this,c)
    if c ~= nil then
        this.Active = (c ~= false);
        return this;
    else
        return this.Active or false;
    end
end;
action = function (this,f)
    if f then 
        this.Action = f;
        return this;
    else
        return this.Action;
    end
end;
highlight = function (this,c)
    if c ~= nil then
        this.Highlight = (c ~= false);
        return this;
    else
        return this.Highlight or false;
    end
end;
clickable = function (this,c)
    if c ~= nil then
        this.Clickable = (c ~= false);
        return this;
    else
        return this.Clickable or false;
    end
end;
masked =    function(this,b)
    if b then
        this.Masked = b;
        return this;
    else
        return this.Masked;
    end
end;

----------------------------------------------------------------
-- geometry methods
    
bounds =
    function(this)
        return this.lb,this.bb,this.rb,this.tb;
    end;

origin =
    function(this)
        return this.lb,this.bb;
    end;

size =
    function(this)
        return this.rb-this.lb,this.tb-this.bb;
    end;

center =
    function(this)
        return (this.lb+this.rb)/2,(this.bb+this.tb)/2;
    end;

area =
    function(this)
        return (this.rb-this.lb)*(this.tb-this.bb);
    end;

contains =
    function(this,x,y)
        return x >= this.lb and y >= this.bb and x <=  this.rb and y <= this.tb;
    end;

offset =
    function(this,x,y)
        return x-this.lb,y-this.bb;
    end;

----------------------------------------------------------------
-- attachment methods

attach =
    function(this,parent,la,ba,ra,ta)
        if this.Parent ~= parent then
            if this.Parent then
                for i,v in pairs(this.Parent.attatchments) do
                    if v == this then
                        table.remove(this.Parent.attatchments,i);
                        break;
                    end;
                end;
            end;
            if parent then
                if not parent.attachments then
                    parent.attachments = {};
                end;            
                table.insert(parent.attachments,this);
            end;
        end;
        this.Parent,this.la,this.ba,this.ra,this.ta = parent,la,ba,ra,ta;
        --[[ this:updatebounds(); ]]
        return this;
    end;

detach = 
    function(this)
        if this.parent then
            table.remove(parent.attatchments);
            this.parent = nil;
        end
        --[[ TODO: adjust attachment values to screen? ]]
    end;

----------------------------------------------------------------

getbounds =
    function(this)
        p = this.Parent;
        if not p then 
            local screenw, screenh = celestia:getscreendimension();
            this.lb,this.rb = 0, screenw;
            this.bb,this.tb = 0, screenh;
            return;
        end;
        this.lb,this.rb = inset(this.la,this.ra,p.lb,p.rb);
        this.bb,this.tb = inset(this.ba,this.ta,p.bb,p.tb);
    end;

move =
    function(this,dx,dy)
        p = this.Parent;
        if not p then return end;
        this.la,this.ra = adjustinsets(dx,this.la,this.ra,p.lb,p.rb);
        this.ba,this.ta = adjustinsets(dy,this.ba,this.ta,p.bb,p.tb);
    end;

moveby = 
    function(this,dx,dy)
        p = this.Parent;
        if not p then return end;
        dx = movelimit(dx,this.la,this.ra,p.lb,p.rb);
        dy = movelimit(dy,this.ba,this.ta,p.bb,p.tb);
        this:move(dx,dy);
    end;

stickyborders =
    function(this)
        p = this.Parent;
        lb,bb,rb,tb = this:bounds();
        pl,pb,pr,pt = p:bounds();
        if this.la <0 and lb-pl < 5 then
            this.ra = lb-rb;
            this.la = 5;
        elseif this.ra <0 and pr-rb < 5 then
            this.la = lb-rb;
            this.ra = 5;
        end;
        if this.ba <0 and bb-pb < 5 then
            this.ta = bb-tb;
            this.ba = 5;
        elseif this.ta <0 and pt-tb < 5 then
            this.ba = bb-tb;
            this.ta = 5;
        end;
    end;

----------------------------------------------------------------

updatebounds =
    function(this)
        this:getbounds();
        if this.attachments then 
            for i,v in ipairs(this.attachments) do
                --if v.Visible then v:updatebounds() end;
                v:updatebounds();
            end;
        end;
        return lb,bb,rb,tb;
    end;

----------------------------------------------------------------

orderfront =
    function(this,child)
        if child and this.Toplevel then
             if this.attachments then
                 for i,v in ipairs(this.attachments) do
                    if v == child then
                        table.remove(this.attachments,i);
                        table.insert(this.attachments,v);
                        return;
                    end;
                end;
            end;
        else
            this.Parent:orderfront(this);
        end;
    end;

----------------------------------------------------------------

adjustborders =
    function(this)
        if (not this.Toplevel) then
            return;
        end;
        if this.attachments then
            for i,v in ipairs(this.attachments) do
                v:moveby(0,0);
                v:stickyborders();
            end;
        end;
    end;

----------------------------------------------------------------
-- drawing methods

drawtexture =
    function(this)
        gl.Enable(gl.TEXTURE_2D);
        gl.Begin(gl.QUADS);
        gl.Color(1, 1, 1, 1 * alpha * opacity);
        gl.TexCoord(0.0, 1.0);
        gl.Vertex(this.lb, this.bb);
        gl.TexCoord(1.0, 1.0);
        gl.Vertex(this.rb, this.bb);
        gl.TexCoord(1.0, 0.0);
        gl.Vertex(this.rb, this.tb);
        gl.TexCoord(0.0, 0.0);
        gl.Vertex(this.lb, this.tb);
        gl.End();
        gl.Disable(gl.TEXTURE_2D);
    end;

drawrect =
    function(this)
        gl.Begin(gl.LINE_LOOP);
        gl.Vertex(this.rb, this.bb);
        gl.Vertex(this.rb, this.tb);
        gl.Vertex(this.lb, this.tb);
        gl.Vertex(this.lb,this.bb);
        gl.End();
    end;

drawmaskedrect =
    function(this, box)
        gl.Begin(gl.LINE_LOOP);
        gl.Vertex(box.rb, this.bb);
        gl.Vertex(this.rb, this.bb);
        gl.Vertex(this.rb, this.tb);
        gl.Vertex(box.rb, this.tb);
        gl.End();
        gl.Begin(gl.LINE_LOOP);
        gl.Vertex(box.lb, this.tb);
        gl.Vertex(this.lb,this.tb);
        gl.Vertex(this.lb, this.bb);
        gl.Vertex(box.lb, this.bb);
        gl.End();
    end;

draw =
    function(this)
        if this.Fillimage then
            this.Fillimage:bind();
            this:drawtexture();
        end
        if this.Fillcolor or this.Highlight then
            if this.Highlight then
                gl.Color(cbubordon[1]*2/3, cbubordon[2]*2/3, cbubordon[3]*2/3, cbubordon[4]/2 * alpha * opacity);
            else
                local fco = this.Fillcolor;
                gl.Color(fco[1], fco[2], fco[3], fco[4] * alpha * opacity);
            end
            gl.Disable(gl.TEXTURE_2D);
            gl.Begin(gl.POLYGON); 
            this:drawrect();
        end
        if this.Bordercolor then
            if this.Highlight then
                gl.Color(cbubordon[1], cbubordon[2], cbubordon[3], cbubordon[4] * alpha * opacity);
            else
                local bco = this.Bordercolor;
                gl.Color(bco[1], bco[2], bco[3], bco[4] * alpha * opacity);
            end;
            gl.Disable(gl.TEXTURE_2D);
            if this.Masked then
                this:drawmaskedrect(this.Masked);
            else
                this:drawrect();
            end
        end;
        if this.Text and this.Textfont then
            gl.MatrixMode(gl.MODELVIEW);
            gl.PushMatrix();
            gl.LoadIdentity();
            gl.Enable(gl.TEXTURE_2D);
            gl.Enable(gl.BLEND);
            gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
            if not(this.dx) then this.dx = 0 end;
            if not(this.dy) then this.dy = 0 end;
            if this.Textcolor then
                local tco = this.Textcolor;
                gl.Color(tco[1], tco[2], tco[3], tco[4] * alpha * opacity);
            else
                local tco = this.Bordercolor;
                gl.Color(tco[1], tco[2], tco[3], tco[4] * alpha * opacity);
            end
            if this.Textpos == "center" then
                local textwidth = this.Textfont:getwidth(this.Text);
                local boxwidth, boxheight = this:size();
                this.dx = math.floor((boxwidth - textwidth) / 2) - 5;
            end
            local xpos = math_round(this.lb + 5 + this.dx);
            local ypos = math_round(this.tb - 18 + this.dy);
            gl.Translate(xpos + 0.125, ypos + 0.125);
            this.Textfont:bind();
            this.Textfont:render(this.Text);
            gl.PopMatrix();
            gl.Disable(gl.TEXTURE_2D);
        end;
        if this.Fittotext and this.Textfont and this.Text and this.Parent and this.ba and this.ta then
            local textwidth = this.Textfont:getwidth(this.Text);
            local parent = this.Parent;
            local parentwidth, parentheight = parent:size();
            local xoffset = this.Fittotext;
            local lbb, rbb = (parentwidth-10-textwidth)/2+xoffset, (parentwidth-10-textwidth)/2-xoffset;
            this:attach(parent, lbb, this.ba, rbb, this.ta);
        end;
    end;

drawall =
    function(this)
        if not(this.Visible) then
            return;
        end
        -- We start drawing the box on the second tick in order to
        -- hide a possible uggly resizing of the box during the first tick.
        if this.FirstTickDone then
            this:draw();
        else
            this.FirstTickDone = true;
        end
        if this.Customdraw then
            this:Customdraw();
        end
        if this.attachments then
            for i,v in ipairs(this.attachments) do
                v:drawall();
            end;
        end;
    end;

Action =
    function(this)
        print(this, " got action");
        return nil;
    end;

-----------------------------------------------------------------
-- field editing methods

beginedit =
    function(this)
        eventeater = this;
        this.Highlight = true;
    end;

quitedit =
    function(this)
        this.Highlight = nil;
        eventeater = nil;
        return true;
    end;

endedit =
    function(this)
        this.Highlight = nil;
        eventeater = nil;
        if this.NextField then
            this.NextField:beginedit();
        end;
        return true;
    end;

-----------------------------------------------------------------
-- event processing methods

findcontainer =
    function(this,x,y)
        if not this.Visible then return nil end;
        local r;
        if this.attachments then 
            for i = table.getn(this.attachments),1,-1 do
                v = this.attachments[i];
                r = v:findcontainer(x,y);
                if r then
                    return r;
                end;
            end;
        end;
        if this:contains(x or -1,y or -1) then
            return this;
        else
            return nil;
        end;
    end;

charentered =
    function(this,ch)
        if  ch == "\r"  then
            print("return")
            return this:endedit();
        elseif ch == "\n" then
            print("newline")
        elseif ch == "\b" then
            print("backspace")
            len = string.len(this.Text)-1;
            if len < 0 then return true end;
            s = string.sub(this.Text,1,len);
            this.Text = s;
            return true;
        elseif ch == "\t" then
            print("tab")
            return this:endedit();
        elseif ch ~= " " then
            saved = this.Text;
            this.Text = this.Text..ch;
            n = tonumber(this.Text);
            if n == nil then
                print("not a number: '"..this.Text.."'");
                this.Text = saved;
            end;
            return true;
        end;
        return true;
    end;

--[[mousemove =
    function(this,x,y)
        cursorXPos = x;
        cursorYPos = y;
    end;
    ]]

mousebuttondown =
    function(this,x,y,b)
        if this:contains(x,y) then
            if not(this.Clickable) and (overlay.visible or this == toolButton) then
                eventeater = this;
            end
            if this.Toplevel then
                return;
            end;
            if this.Active and (overlay.visible or this == toolButton) then
                this:Action();
                this:orderfront();
                this.Highlight = true;
            end;
            if this.Movable and overlay.visible then
                this:orderfront();
                this.Move = true;
            end;
            toolButton:orderfront();
            return true;
        else
            this:quitedit();
            return false;
        end;
    end;

mousebuttonmove =
    function(this,dx,dy)
        if eventeater ~= this then return false end;
        if this.Movable then
            this:moveby(dx,dy);
            return true;
        end;
        if this.Active then
            return true;
        end;
        return false;
    end;

mousebuttonup =
    function(this,x,y,b)
        if eventeater ~= this then return false end;
        eventeater = nil;
        this.Highlight = nil;
        this.Move = false;
        if this:contains(x,y) then
            if this.Editable then
                this.Highlight = true;
                eventeater = this;
                return true;
            end;
        end;
        return true;
    end;

-----------------------------------------------------------------

print =
    function(this)
        print(
            "Box { ",
                this.la," , ",
                this.ba," , ",
                this.ra," , ",
                this.ta,
            " }" );
        end;
    }

CXBox.__tostring =
    function(this)
        return "Box { ".. 
            (this:text() or "?").." "..
            this.la.." , "..
            this.ba.." , "..
            this.ra.." , "..
            this.ta..
        " }";
    end;
