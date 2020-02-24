% kbParticle1D for 1-D temperature testing
%  Just a mathematical particle

classdef kbParticle1D
    properties
        % Position
        x
        % Size and substance
        T
        
        % Numerical parameters
        historyDepth % Depth of history vector for C, T histories
        dt % Timestep for numerical convolution computation
        
        % Internal storage
        THistory
        ActiveHistory
        TNew
        isActiveNew
        alwaysActive
    end
    
    methods
        % Initialize by specifying position x, y; initial particle radius;
        % and initial oxidizer concentration in field
        function obj = kbParticle1D(x, historyDepth, dt)
            % Initialize location data
            obj.x = x;
            % Initialize depth of history vector
            obj.historyDepth = historyDepth;
            % Set timestep for integration
            obj.dt = dt;
            % Initialize history vectors
            obj.THistory = ones(1,historyDepth);
            obj.ActiveHistory = false(1,historyDepth);
            
            % Dummy values (just for fun)
            obj.TNew = 0; % Dummy; should be assigned by initialize
            obj.isActiveNew = false; % Dummy; should be assigned by initialize

            % Default: not always active
            obj.alwaysActive = false;
        end
        
        % Sets last value of T and C. Optional: force the particle to
        % activate.
        function obj = initialize(obj, T)            
            obj.THistory(end) = T;
            obj.ActiveHistory(end) = true;
        end
        
        % Stores next T, C in memory, but does not add it to the T, C
        % history vectors (for use in loop over all particles).
        function obj = storeState(obj, T)
            obj.TNew = T;
        end
        
        % Adds T, C, activity state to history after shifting everything to
        % the left (so that the last element in the history vectors is the
        % most recent).
        function obj = updateState(obj)
            % Shift history
            obj.THistory = circshift(obj.THistory,-1);
            obj.ActiveHistory = circshift(obj.ActiveHistory,-1);
            % Record new entry from right
            obj.THistory(end) = obj.TNew;
            obj.ActiveHistory(end) = true;
        end
        
        % Returns the convolution vector for T. That is, G(t-tau), for
        % t-tau = [T, T-dt, ... , dt] where the final time
        % T = obj.historyDepth*dt.
        % Usage: dot(K, f(t)) to convolve K with f, where the most recent
        % value of f is at the end of the vector.
        function [K, tVector] = discreteConvolutionVectorT(obj, r2)
            % Timeline (remove the t = 0 element), i.e. lag tau - t
            tVector = obj.dt*(obj.historyDepth:-1:1);
            % Original G kernel (dirac delta in space)
            % K = 1./(4*pi*tVector) .* ...
            %     exp(-0.25*r2./tVector);
            K = 1./sqrt(pi*(4*tVector)) .* ...
                exp(-r2./(4*tVector));
        end
        
        % Computes the contribution of the particle (passed as obj) to the
        % value of T at (xTarget, yTarget) by convolution.
        function T_at_targetParticle0 = convolveT(obj, xTarget)
            % Compute square-distance
            r2 = (obj.x-xTarget).^2;
            
            % Compute discrete convolution coefficient for mod. Green's
            % function, against piecewise constant
            convVector0 = obj.ActiveHistory .* ...
                discreteConvolutionVectorT(obj, r2);
            
            % Part 1: Trapezoidal (composite closed Newton-Cotes)
            f = exp(-1./obj.THistory);
            % Integration weights applied to integration kernel, part 1
            f1 = obj.dt*f(1:end-2);
            f1(1) = 0.5*f1(1);
            f1(end) = 0.5*f1(end);
            % Integral
            I = dot(convVector0(1:end-2),f1);
            
            % Part 2: Trapezoidal (open Newton-Cotes to get up to t = 0);
            % uses all data in tandem with Part 1
            f2 = (1.5*obj.dt)*f(end-1:end);
            I = I + dot(convVector0(end-1:end),f2);
            T_at_targetParticle0 = I;
        end
    end
end