clear all
% Snake parameters
ALPHA = 0.01               % Factor for elastic forces - FILL IN
BETA = 0.1                % Factor for bending forces - FILL IN
GAMMA = 2               % Factor for image forces - FILL IN
NI = 1;                  % Number of snake iterations before resampling
MAX_ITERATIONS = 400;      % Max number of snake iterations  - FILL IN

% Edge map parameters
T = 0.02                   % Threshold for edge map  - FILL IN
SIG = 5                 % Std dev for computing edge map  - FILL IN
NSIG = 7;                % Width of Gaussian smoothing filter (number of std dev) - FILL IN
ORDER = 'both';               % Whether we wish to apply filter to image and/or edge map  - FILL IN

% Force parameters for GVF
MU = 0.24                  % Regularization parameter for GVF  - FILL IN
GVF_ITERATIONS = 19      % FILL IN


% Read in and display image; print message
g = imread('breast-implant.tif');
g = im2double(g);
imshow(g), axis off

% Create and plot initial snake.
theta = (0:0.1:2*pi)';
x = 300 + 70*cos(theta);
y = 300 + 90*sin(theta);
% Close snake, i.e., like the Ouroboros
x(end+1) = x(1);
y(end+1) = y(1);
x1 = x; % Re-assignment to x1 and y1 done to keep original contour
y1 = y;
hold on
% When plotting, we have to flip the roles of x and y to match normal
% curve plotting coordinate system to image coordinate system
h = plot(y1,x1, 'y.-');

% Compute edge map and then image forces over entire image
emap = snakeMap(g,T, SIG, NSIG, ORDER);
% Scale forces to range [0, 1]
emap = im2double(intensityScaling(emap));
[Fx,Fy] = snakeForce(emap, 'gvf', MU, GVF_ITERATIONS);
% Normalize forces
mag = hypot(Fx, Fy);
small = 1e-10; % To prevent division by zero
Fx = Fx./(mag + small);
Fy = Fy./(mag + small);

% Deform snake. Hisssssssss.
for i = 1 : MAX_ITERATIONS
    [x1, y1] = snakeIterate(ALPHA, BETA, GAMMA, x1, y1, NI, Fx, Fy);
    [x1, y1] = snakeRespace(x1, y1);
    delete(h)
    h = plot(y1,x1, 'y.-', 'linewidth',3);
    drawnow
end
% Plot initial contour
%plot(y, x, 'm-', 'linewidth',3);
hold off



