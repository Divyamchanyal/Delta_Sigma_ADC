fs      = 1e3*128*2;      % 256 kHz
fcorner = 1e4;            % 10 kHz 1/f corner

[ff_ct, z, p] = designFlickerFilter_SD(fcorner);

% === Normalize so |H(fcorner)| = 1 (controls gain, avoids overflow)
[mag_corner,] = bode(ff_ct, 2*pi*fcorner);
g = 1/squeeze(mag_corner);
ff_ct = g * ff_ct;

% === Convert to discrete-time for Simulink (VERY IMPORTANT)
ff_dt = c2d(ff_ct, Ts, 'tustin');   % or 'zoh' if you prefer

% Get A,B,C,D for Discrete State-Space block
Ad = ff_dt.A;
Bd = ff_dt.B;
Cd = ff_dt.C;
Dd = ff_dt.D;
function [flickerfilter, z, p] = designFlickerFilter_SD(fcorner)
% 1/f (flicker) noise approximation filter for sigma-delta sims
% Continuous-time design; convert to discrete with c2d(fs).

pzfactor = 10;        % for ~-1 slope

if fcorner <= 0
    flickerfilter = ss(0,0,0,1);
    z = [];
    p = [];
    return;
end

% ---- MORE POLE/ZERO PAIRS = BETTER 1/f SLOPE ----
% span roughly from 0.001*fcorner to 1*fcorner (4 decades)
decades = [-3 -2 -1 0];    % you can extend: [-4 -3 -2 -1 0] etc.
base    = 2*pi*fcorner;

p = -base * 10.^decades;   % poles
z = p * sqrt(pzfactor);    % zeros higher by sqrt(10)

% base gain
k = 1;
zpkform      = zpk(z, p, k);
flickerfilter = ss(zpkform);
end