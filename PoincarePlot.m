classdef PoincarePlot
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x = [];
        y = [];
    end
    
    methods
        function obj = PoincarePlot(x,y)
            obj.x = x;
            obj.y = y;
        end
        
        function represent(obj)
            plot(obj.x, obj.y, '*');
            xlabel('X');
            ylabel('Y');
            title('Poincare Plot')
        end
    end
end

