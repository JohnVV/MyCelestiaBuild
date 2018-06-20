--[[-----------------------------------------]]

Class =
    function(newmetatable)
        local newclass;
        if CXClass then
            newclass = CXClass:new();
        else
            newclass = newmetatable;
        end;
        newclass.__index = newmetatable;
        if newmetatable.superclass then
            setmetatable(newmetatable,newmetatable.superclass);
        end;
        return newclass;
    end;

--[[-----------------------------------------]]

CXClass =
    Class {
    classname = "CXClass";
    new =
        function (o)
            local newinstance = {};
            setmetatable(newinstance,o);
            return newinstance;
        end;
    supperclass =
        function (o)
            return getmetatable(o._index);
        end;
    }

--[[-----------------------------------------]]

CXObject = 
    Class{
    classname = "CXObject";
    }

--[[-----------------------------------------]]