function generate_dynamics_cwh(varargin)
% GENERATE_DYNAMICS_CWH Generates A, B, G for a CWH system.
%
%   GENERATE_DYNAMICS_CWH() Generates the dynamics for a CWH system. This
%   function is run BEFORE anything else, and is not called by any other
%   function.

p = inputParser;
addOptional(p, 'T', 20);
addParameter(p, 'OrbitalRadius', 850 + 6378.1);
addParameter(p, 'GravitationalConstant', 6.673e-11);
addParameter(p, 'BodyMass', 5.9472e24);
addParameter(p, 'SpacecraftMass', 300);

parse(p, varargin{:});

% Sampling period.
T = p.Results.T;

% Orbital radius.
R = p.Results.OrbitalRadius;
% Gravitational constant.
G = p.Results.GravitationalConstant;
% Celestial body mass.
M = p.Results.BodyMass;

% Gravitational body.
mu = G*M/(1000^3);
% Orbital angular velocity.
w = sqrt(mu/(R^3));

% Mass of the spacecraft.
mc = p.Results.SpacecraftMass;

tau = w*T;

Btemp = [0 0; 0 0;1/mc 0; 0 1/mc];

A = [4 - 3*cos(tau), 0, sin(tau)/w, (2/w)*(1-cos(tau));
     6*(sin(tau) - tau), 1, -(2/w)*(1-cos(tau)), (4*sin(tau)-3*tau)/w;
     3*w*sin(tau), 0, cos(tau), 2*sin(tau);
     -6*w*(1-cos(tau)), 0, -2*sin(tau), 4*cos(tau)-3];

B_int = @(t,~) [4*t - 3*sin(w*t)/w, 0, -cos(w*t)/w^2, (2/w)*(t - sin(w*t)/w);
                6*(sin(w*t)/w - w*t^2/2), t, -(2/w)*(t - sin(w*t)/w), (-4*cos(w*t)/w - 3*w*t^2/2)/w;
                -3*cos(w*t), 0, sin(w*t)/w, -2*cos(w*t)/w;
                -6*w*(t - sin(w*t)/w), 0, 2*cos(w*t)/w, 4*sin(w*t)/w - 3*t];

B = (B_int(T,w) - B_int(0,w))*Btemp;

G = eye(4);

save('dynamics_cwh.mat', 'A', 'B', 'G');
