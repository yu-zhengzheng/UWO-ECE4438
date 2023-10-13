% Snake parameters
K = 100                 % Number of points along snake
ALPHA = 0.1             % Factor for elastic forces
BETA = 0.5              % Factor for bending forces
GAMMA = 0.7             % Factor for image forces
NI = 1                  % Number of snake iterations before resampling
MAX_ITERATIONS = 500    % Max number of snake iterations

% Edge map parameters
T = 0.001               % Threshold for edge map
SIG = 15                % Std dev for computing edge map
NSIG = 3                % Width of Gaussian smoothing filter (number of std dev)
ORDER = 'both'          % Whether we wish to apply filter to image and/or edge map
FORCE_TYPE = 'MOG'      % Can use MOG or GVF for computing image energy and forces
                        % GVF requires other parameters to be set

% Read in and display image; print message
g = imread('noisy-elliptical-object.tif');
g = imread('breast-implant.tif');
imshow(g), axis off
hold on

% Allow user to draw polygon interactively and resample
disp('Click to select points along initial contour. Double-click to select last point.');
disp('ALSO double-click on polygon to confirm and proceed.');
[BW, x, y] = roipoly;
% Resample curve and plot
pts = interparc(K, x, y, 'linear'); % 3rd-party function; no need to understand code
x1 = pts(:,1);
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
    h = plot(x1,y1, 'w.-');
    drawnow
end

hold off



