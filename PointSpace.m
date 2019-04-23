classdef PointSpace
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x = [];
        y = [];
    end
    
    methods
        function obj = PointSpace(x,y)
            obj.x = x;
            obj.y = y;
        end
        
        function represent(obj)
            hold on
            plot(obj.x, obj.y, '*');
        end
    end
end

