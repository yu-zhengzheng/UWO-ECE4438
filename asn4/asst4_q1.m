% Parameter to scale initial contour
CONTOUR_SCALE = 1.75      % Default: 1.0

% Snake parameters
K = 100                  % Number of points along snake
ALPHA = 0.1              % Factor for elastic forces (default: 0.1)
BETA = 0.5               % Factor for bending forces (default: 0.5)
GAMMA = 6.6              % Factor for image forces (default: 0.6)
NI = 1                   % Number of snake iterations before resampling
MAX_ITERATIONS = 300     % Max number of snake iterations (default: 300)

% Edge map parameters
T = 0.001               % Threshold for edge map
SIG = 15                % Std dev for computing edge map
NSIG = 3                % Width of Gaussian smoothing filter (number of std dev)
ORDER = 'before'          % Whether we wish to apply filter to image and/or edge map (default: both)
FORCE_TYPE = 'MOG'      % Can use MOG or GVF for computing image energy and forces
                        % GVF requires other parameters to be set

% Read in and display image; print message
g = imread('noisy-elliptical-object.tif');
imshow(g), axis off
hold on

% Load in pre-defined initial contour so we can experiment with parameters
% in a controlled manner
load asst4_q1_xy
% Allow scaling of initial shape about its centroid so we can try different
% initializations
polyrep = polyshape(x, y);
[xc, yc] = centroid(polyrep);
polyrep_scaled = scale(polyrep, CONTOUR_SCALE, [xc, yc]);
x = polyrep_scaled.Vertices(:,1);
y = polyrep_scaled.Vertices(:,2);
% Converting to polyrep opens contour, so we need to reclose it
x = [x; x(1)];
y = [y; y(1)];
pts = interparc(K, x, y, 'linear'); % 3rd-party function; no need to understand code
x1 = pts(:,1); % Re-assignment to x1 and y1 done to keep original contour
y1 = pts(:,2);
h = plot(x1,y1, 'y.-');

% Compute edge map and then image forces over entire image
emap = snakeMap(g,T, SIG, NSIG, ORDER);
[Fx,Fy] = snakeForce(emap, FORCE_TYPE);
% Normalize forces
mag = hypot(Fx, Fy);
small = 1e-10; % To prevent division by zero
Fx = Fx ./ (mag + small);
Fy = Fy ./ (mag + small);

for i = 1 : MAX_ITERATIONS
    [x1, y1] = snakeIterate(ALPHA, BETA, GAMMA, x1, y1, NI, Fx, Fy);
    [x1, y1] = snakeRespace(x1, y1);
    delete(h)
    h = plot(x1,y1, 'm.-', 'linewidth',3);
    drawnow
end
% Plot initial contour
plot(x, y, 'ys-', 'linewidth',3);
hold off
s = sprintf('CONTOUR\\_SCALE = %.2f', CONTOUR_SCALE);
title(s, 'fontsize', 20)



