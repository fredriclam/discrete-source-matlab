% kbParticle version alpha
%  Particle class containing constants relevant to the particle. Contains
%  methods for converting between equivalent information (e.g. mass to
%  volume to radius of particle), determining the effect of the particle on
%  gas temperature or oxidizer concentration at an arbitrary location, and
%  for updating the internal state of the particle (i.e. particle
%  temperature and mass changing due to reaction).
%  
%  Particle is quenched manually when volume reaches 1% of initial volume.
% 
% Dated:
%  Aug. 18, 2018
%  Full k-beta particle for any dimension
%  Notes:
%   -Dimension two is not implemented
%   -It works with Forward Euler for ODE part, but implicit has issues with
%   inverting the matrix for Newton-Raphson

classdef kbParticle_alpha
    properties
        % Tuned parameters 
        h_p = 100; %!Not quite sure value % Convective heat transfer coefficient [W/m^2-K]
        kappa = 80; % Pre-exponential fudge factor, two-dimensional [m/s]
        T_a = 6500; % Activation temperature [K] % 15000
        % Solid fuel
        c_s = 900; % Heat capacity of solid aluminum [J/kg-K solid]
        q = 3.1e7; % Heating value of solid [J/kg solid] % Ballpark Soo et al. "Combustion of particles, agglomerates, and suspensions -- a basic thermophysical analysis"
        rho_s = 2700.0;
        % Gas phase
        c_g  = 1000.0;% Bulk gas heat capacity (constant) [J/kg-K]
        rho_g = 1.0; % Bulk gas density (constant) [kg/m^3]
        lambda_g = 0.02; % Gas conductivity (constant) [W/m-K]
        D = 2e-5; % Oxidizer mass diffusivity (constant) [m^2/s] -- so that Le = 1

        % Position
        position
        dimension
        
        % Size and substance
        r_p % Particle radius [m]
        m_p % Particle mass [kg]
        A_p % Particle wetted surface area [m^2]
        r_p_0 % Initial
        m_p_0 % Initial particle mass [as above] % Unneeded

        % Minimum particle volume ratio below which reaction stops
        % If set to zero, the particle temperature approaches infinity to
        % conserve energy
        % e.g. set to 0.01 => 1% of particle mass remains when reaction is
        % shut down
        minimumParticleVolume = 0.01
        
        % Field parameters
        C_g % Gas oxidizer concentration [kg/m^3]
        
        % Thermophysical
        beta_p % Mass transfer coefficient (beta = D / r_p), two-dimensional [m^2/s]
        k % Reaction rate [m/s?]
        k_eff % Effective reaction rate [m/s?]
        T_p % Particle temperature (assumed homogeneous) [K]
        T_g % Gas temperature at this location [K]
        T_p_0 % Initial particle temperature (for numeric scaling) [K] % Unneeded
        
        % Numerical parameters
        historyDepth % Depth of history vector for C, T histories
        dt % Timestep for numerical convolution computation
        
        % Active flag (i.e., can still react)
        isReactive
        
        % Image spacing for uniform grid of particles
        imageSpacing
        
        % Internal storage
        CgHistory
        TpHistory
        TgHistory
        ApHistory
        keffHistory
        ActiveHistory
        rpHistory % Not used in calculation; just to see radius change
    end
    
    methods
        % Initialize by specifying position x, y; initial particle radius;
        % and initial oxidizer concentration in field
        function obj = kbParticle_alpha(...
                positionVector, r_p_0, dimension, historyDepth, dt, ...
                imageSpacing)
            % Initialize location data
            obj.position = positionVector;
            obj.dimension = dimension;
            % Initialize physical data
            obj.r_p_0 = r_p_0;
            % Set depth of history vector
            obj.historyDepth = historyDepth;
            % Set timestep for integration
            obj.dt = dt;
            % Set image spacing
            obj.imageSpacing = imageSpacing;
            % Allow particle to burn
            obj.isReactive = true;
            % Initialize history vectors
            obj.CgHistory = zeros(1,historyDepth);
            obj.TpHistory = zeros(1,historyDepth);
            obj.TgHistory = zeros(1,historyDepth);
            obj.ApHistory = zeros(1,historyDepth);
            obj.keffHistory = zeros(1,historyDepth);
            obj.ActiveHistory = false(1,historyDepth);
            obj.rpHistory = zeros(1,historyDepth);
        end
        
        % Runs cycle 0 of the simulation loop; update all properties
        function obj = initialize(obj, Cg, Tp, Tg)
            obj.C_g = Cg;
            obj.T_p = Tp;
            obj.T_g = Tg;
            % Step 0: initialize particle mass
            obj = obj.computeSizeFromRadius(obj.r_p_0);
            % Step 1: compute physics coefficients at t = 0
            obj = obj.computePhysicsCoefficients();
            % Store values in history
            obj = obj.updateHistory();
            % Store initial values for scaling
            obj.T_p_0 = obj.T_p;
            obj.m_p_0 = obj.m_p;
        end
        
        % Compute particle radius, area, mass from any one
        function obj = computeSizeFromRadius(obj, r)
            obj.r_p = r;
            obj.A_p = 4*pi*r^2;
            obj.m_p = 4/3*pi*r^3*obj.rho_s;
        end
        function obj = computeSizeFromArea(obj, A)
            obj.r_p = sqrt(A/(4*pi));
            obj.A_p = A;
            obj.m_p = 4/3*pi*obj.r_p^3*obj.rho_s;
        end
        function obj = computeSizeFromMass(obj, m)
            obj.r_p = ((3/(4*pi))*(m/obj.rho_s))^(1/3);
            obj.A_p = 4*pi*obj.r_p^2;
            obj.m_p = m;
        end
        
        % Compute physical coefficients
        function obj = computePhysicsCoefficients(obj)
            obj.beta_p = obj.D / obj.r_p_0;
            obj.k = obj.kappa * exp(-obj.T_a/ obj.T_p);
            obj.k_eff = obj.isReactive * obj.k*obj.beta_p/(obj.k+obj.beta_p);
        end
        
        % Stores next Tg, Cg in memory, but does not add it to the Tg, Cg
        % history vectors (for use in loop over all particles).
        function obj = storeState(obj, Cg, Tg)
            obj.C_g = Cg;
            obj.T_g = Tg;
        end
        
        % Adds current state to history after shifting everything to
        % the left (so that the last element in the history vectors is the
        % most recent).
        function obj = updateHistory(obj)
            % Shift history
            obj.CgHistory = circshift(obj.CgHistory,-1);
            obj.TpHistory = circshift(obj.TpHistory,-1);
            obj.TgHistory = circshift(obj.TgHistory,-1);
            obj.ApHistory = circshift(obj.ApHistory,-1);
            obj.keffHistory = circshift(obj.keffHistory,-1);
            obj.ActiveHistory = circshift(obj.ActiveHistory,-1);
            obj.rpHistory = circshift(obj.rpHistory,-1);
            % Record new entry from right
            obj.CgHistory(end) = obj.C_g;
            obj.TpHistory(end) = obj.T_p;
            obj.TgHistory(end) = obj.T_g;
            obj.ApHistory(end) = obj.A_p;
            obj.keffHistory(end) = obj.k_eff;
            obj.ActiveHistory(end) = obj.isReactive;
            obj.rpHistory(end) = obj.r_p;
        end
        
        % Returns the convolution vector G_alpha(t-tau), for
        % t-tau = [tmax, T-dt, ... , dt] where the final time
        % T = obj.historyDepth*dt.
        % Usage: dot(K, f(t)) to convolve K with f, where the most recent
        % value of f is at the end of the vector.
        % Alpha is the coefficient in front of the Laplacian for the heat
        % equation
        % For images, assumes propagation direction is in x-direction
        function [G, tVector] = discreteConvolutionVector(obj, alpha, dr)
            % Timeline (remove the t = 0 element), i.e. lag tau - t
            tVector = obj.dt*(obj.historyDepth:-1:1);
            % Green's function
            G = 1./(pi*(4*alpha*tVector)).^(obj.dimension/2) .* ...
                    exp(-dot(dr,dr)./(4*alpha*tVector));
            % Periodic Green's function
            if obj.dimension == 2
                error('Not implemented; # of images not free to specify')
            elseif obj.dimension == 3                
                % Fixed image set addition exploiting symmetry of grid
                offset = obj.imageSpacing*[0 1 0];
                G = G + 1./(pi*(4*alpha*tVector)).^(obj.dimension/2) .* (...
                    4*exp(-dot(dr+offset,dr+offset)./(4*alpha*tVector)) + ...
                    4*exp(-dot(dr+sqrt(2)*offset,dr+sqrt(2)*offset)./(4*alpha*tVector)) + ...
                    4*exp(-dot(dr+2*offset,dr+2*offset)./(4*alpha*tVector)) + ...
                    8*exp(-dot(dr+sqrt(5)*offset,dr+sqrt(5)*offset)./(4*alpha*tVector)) + ...
                    4*exp(-dot(dr+sqrt(8)*offset,dr+sqrt(8)*offset)./(4*alpha*tVector))+ ... extend to corners 5x5);
                    4*exp(-dot(dr+3*offset,dr+3*offset)./(4*alpha*tVector))+ ... extend to 7x7 shell
                    8*exp(-dot(dr+sqrt(10)*offset,dr+sqrt(10)*offset)./(4*alpha*tVector))+ ...
                    8*exp(-dot(dr+sqrt(13)*offset,dr+sqrt(13)*offset)./(4*alpha*tVector))+ ...
                    4*exp(-dot(dr+sqrt(18)*offset,dr+sqrt(18)*offset)./(4*alpha*tVector)));
            elseif obj.dimension > 1
                error('Dimensionality error! Could not compute Greens fn')
            end
        end

        % Computes the contribution of the particle (passed as obj) to the
        % value of T at target particle's location by convolution.
        function TtargetParticle = propagateT(obj, targetParticle)
            % Compute distance vector dr
            dr = targetParticle.position - obj.position;
            
            % Compute discrete convolution coefficients but zero for t < 0
            convolutionVector = obj.ActiveHistory .* ...
                obj.discreteConvolutionVector(...
                obj.lambda_g/(obj.c_g*obj.rho_g),dr);
            
            % Compute T at target particle location
            TtargetParticle = ...
                obj.h_p / (obj.c_g * obj.rho_g) * ...
                obj.integrateProduct(convolutionVector,...
                obj.ApHistory .* (obj.TpHistory - obj.TgHistory), obj.dt);
        end
        
        % Computes the contribution of the particle (passed as obj) to the
        % value of C at target particle's location by convolution.
        function CtargetParticle = propagateC(obj, targetParticle)
            % Compute distance vector
            dr = targetParticle.position - obj.position;
            
            % Compute discrete convolution coefficients but zero for t < 0
            convolutionVector = obj.ActiveHistory .* ...
                obj.discreteConvolutionVector(obj.D,dr);
            
            % Compute T at target particle location
            CtargetParticle = ...
                obj.integrateProduct(convolutionVector,...
                obj.keffHistory .* obj.CgHistory .* obj.ApHistory, obj.dt);
        end
        
        % Integration method here
        function I = integrateProduct(obj,u,v,dt)
            % Part 1: Trapezoidal (composite closed Newton-Cotes)
            u1 = dt*u(1:end-2);
            u1(1) = 0.5*u1(1);
            u1(end) = 0.5*u1(end);
            % Part 2: Trapezoidal (open Newton-Cotes to get up to t = 0)
            u2 = (1.5*dt)*u(end-1:end); %1.5 == 3dt/2
            I = dot(u1,v(1:end-2)) + dot(u2,v(end-1:end));

%             % Alternate method: Trapezoidal all (composite closed Newton-Cotes)
%             u = dt*u;
%             u(1) = 0.5*u(1);
%             u(end) = 0.5*u(end);
%             % Integral
%             I = dot(u,v);
        end
        
        % ODE method here
        function obj = timeStepParticleProperties(obj)
            % Mass (forward Euler); store in temporary variable
            m_p_next = obj.m_p - obj.dt* ...
                obj.k_eff*obj.C_g*obj.A_p;
            
            % Energy (forward Euler)
            obj.T_p = obj.T_p + obj.dt* ...
                obj.A_p/(obj.c_s*obj.m_p)*(...
                obj.k_eff*obj.C_g*(obj.c_s*obj.T_p+obj.q) - ...
                obj.h_p * (obj.T_p - obj.T_g));
            
            % Store updated mass
            obj.m_p = m_p_next;
            % Bind to area, radius
            obj = obj.computeSizeFromMass(obj.m_p);
            
            % If particle radius less than percent of initial radius,
            % disable forever
            if obj.r_p < obj.minimumParticleVolume^(1/3)*obj.r_p_0
                obj.isReactive = false;
            end
        end
            
% %         % Disabled
% %         % ODE method here
% %         function obj = timeStepParticlePropertiesImplicit(obj)
% %             % Unravel ODE dependency of system source term on m_p, T_p
% %             % Holding gas properties constant
% %             beta_p = @(r_p) obj.D / r_p;
% %             k = @(T_p) obj.kappa * exp(-obj.T_a/ T_p);
% %             r_p = @(m_p) (3/(4*pi)*m_p/obj.rho_s)^(1/3);
% %             A_p = @(m_p) 4*pi*r_p(m_p)^2;
% %             k_eff = @(m_p, T_p) obj.isReactive * ...
% %                 k(T_p)*beta_p(r_p(m_p))/(k(T_p)+beta_p(r_p(m_p)));
% %             m_pFromr_p = @(r_p) 4/3*pi*r_p^3*obj.rho_s;
% % 
% %             % Forcing function f
% %             f = @(m_p, T_p) [-obj.C_g * k_eff(m_p, T_p) * A_p(m_p);
% %                 A_p(m_p)/(obj.c_s*m_p)*(obj.C_g*...
% %                 k_eff(m_p, T_p)*(obj.c_s*T_p+obj.q) - ...
% %                 obj.h_p * (T_p - obj.T_g))];
% % 
% %             % u at last timestep
% %             uLast = [obj.m_p;
% %                 obj.T_p];
% %             
% %             % Explicit method
% %             u = [obj.m_p;
% %                 obj.T_p];
% %             % Forward Euler
% %             u = u + f(u(1),u(2)) * obj.dt;
% % 
% %             % Save data
% %             obj.m_p = u(1);%Iterate(1);
% %             obj.T_p = u(2);%Iterate(2);
% %             % Compute particle surface area, particle radius
% %             obj = obj.computeSizeFromMass(obj.m_p);
% % 
% %             % If particle radius less than percent of initial radius,
% %             % disable forever
% %             if obj.r_p < 0.01^(1/3)*obj.r_p_0
% %                 obj.isReactive = false;
% %             end
% % 
% %             % Error catch
% %             if obj.T_p < obj.T_p_0
% % %                 warning('Cold particle detected')
% %             end
% %         end
    end
end