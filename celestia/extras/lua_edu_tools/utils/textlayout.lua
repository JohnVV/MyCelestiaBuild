require "CXBox";

textlayout = {};

textlayout.getfonts =
    function(this)
        -- Use preferably 'sansbold20.txf' as titlefont.
        titlefont = celestia:loadfont("fonts/sansbold20.txf")
        if not titlefont then
            -- If 'sansbold20.txf' is not available, then use titlefont defined in celestia.cfg.
            titlefont = celestia:gettitlefont();
        end
        -- Use preferably 'sans12.txf' as normalfont.
        normalfont = celestia:loadfont("fonts/sans12.txf")
        if not normalfont then
            -- If 'sans12.txf' is not available, then use normalfont defined in celestia.cfg.
            normalfont = celestia:getfont();
        end
        -- Use preferably 'sans10.txf' as smallfont.
        smallfont = celestia:loadfont("fonts/sans10.txf")
        if not smallfont then
            smallfont = normalfont;
        end
    end

textlayout.init =
    function(this)
        this.xpos = 0;
        this.ypos = 0;
        this.linespace = 10;
        --this.leftmargin = 15;
        --this.linestart = 15;
        --this.em = 8;
        this.indent = 0;
        this.xpos = 0;
        --this.linestart = xpos;
        this.ypos = 0;
        this.font = nil;
        this.color = {0,0,0,0};
    end

textlayout.print =
    function(this,s)
        local co = this.color;
        gl.Color(co[1], co[2], co[3], co[4] * alpha * opacity);
        gl.Enable(gl.TEXTURE_2D);
        gl.Enable(gl.BLEND);
        gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
        gl.MatrixMode(gl.PROJECTION);
        gl.PushMatrix();
        gl.LoadIdentity();
        sx,sy = celestia:getscreendimension();
        gl.Ortho(0, sx+0, 0, sy+0, 0, 1); 
        gl.MatrixMode(gl.MODELVIEW);
        gl.PushMatrix();
        gl.LoadIdentity();
        local xpos = math_round(this.xpos);
        local ypos = math_round(this.ypos);
        gl.Translate(xpos+0.125, ypos+0.125);
        this.font:bind();
        this.font:render(s);
        gl.PopMatrix();
        gl.MatrixMode(gl.PROJECTION);
        gl.PopMatrix();
        gl.MatrixMode(gl.MODELVIEW);
    end

textlayout.newln =
    function(this)
        this.xpos = this.leftmargin + this.indent;
        this.linestart = this.xpos;
        this.ypos = this.ypos - this.linespace;
    end

textlayout.println =
    function(this,s)
        this:print(s);
        this:newln();
    end

textlayout.printstr =
    function(this,s)
        this:print(s);
        this.xpos = this.xpos + this.font:getwidth(s);
    end

textlayout.printinbox =
    function(this,s,b,x,y)
        local textwidth = this.font:getwidth(s);
        local textheight = this.font:getheight();
        local boxwidth, boxheight = b:size();
        local x_pos = (boxwidth-textwidth)/2;
        local y_pos = (boxheight+textheight)/2;
        this.leftmargin = b.lb + x_pos + x;
        this.indent = 0;
        this.linestart = b.lb + x_pos + x;
        this.xpos = b.lb + x_pos + x;
        this.ypos = b.tb - y_pos - y;
        this:print(s);
        this:newln();
    end

textlayout.setpos =
    function(this,x,y)
        this.leftmargin = x;
        this.indent = 0;
        this.linestart = x;
        this.xpos = x;
        this.ypos = y;
    end

textlayout.movex =
    function(this,dx)
        this.xpos = this.xpos + dx;
    end

textlayout.setfont =
    function(this,f)
        this.font = f;
    end

textlayout.setfontcolor =
    function(this,c)
        this.color = c;
    end

textlayout.setlinespacing =
    function(this,x)
        this.linespace = x;
    end

textlayout.indentby =
    function(this,x)
        this.indent = this.indent+(x*this.em);
        if this.xpos == this.linestart then 
            this.xpos = this.leftmargin+this.indent;
        end;
    end

replaceGreekLetterAbbr = function (str)
    require "greekAlphabet";
    spacepos = string.find(str, " ");
    if spacepos then
        abbr1 = string.sub(str, 1, spacepos-1);
        abbr2 = string.sub(str, 1, spacepos-2);
        if greek[abbr1] then
            starname = string.gsub(str, abbr1, greek[abbr1]);
        elseif greek[abbr2] then
            starname = string.gsub(str, abbr2, greek[abbr2]);
        else
            starname = str;
        end
    else
        starname = str;
    end
    
    return starname;
    
end

limitStrWidth = function(str, font, maxWidth)
    local strWidth = font:getwidth(str);
    if strWidth > maxWidth or string.sub(str, -1) == string.char(195) then
        str = string.sub(str, 1, -2);
        str = limitStrWidth(str, font, maxWidth)
    end
    return str;
end