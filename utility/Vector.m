classdef Vector<handle
    %Vector data structure
    %   Vector from C++. Preallocates and then fills with NaN. Call method
    %   array to read data. Used in scalingRun to keep track of ignition
    %   information about contributors (called in run_with_tracker).
    
    properties
        size = 16;
        data = nan(16,1);
        iterator = 1;
    end
    
    methods
        function self = append(self, input)
            % Check input
            if ~iscolumn(input)
                input = input';
            end
            if ~iscolumn(input)
                error('Vector: appended item not a vector input')
            end
            % Check if there is enough room
            while length(input) > (self.size - self.iterator) + 1
                self.expand;
            end
            % Append
            self.data(self.iterator:self.iterator+length(input)-1) = input;
            self.iterator = self.iterator + length(input);
        end
        function self = expand(self)
            self.data = [self.data; nan(size(self.data))];
            self.size = self.size * 2;
        end
        function output = array(self)
            output = self.data(1:self.iterator-1);
        end
    end
    
end