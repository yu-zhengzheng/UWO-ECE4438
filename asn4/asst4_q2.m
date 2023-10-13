% Edge map parameters
T = 0.001               % Threshold for edge map
SIG = 1                 % Std dev for computing edge map
NSIG = 3                % Width of Gaussian smoothing filter (number of std dev)
ORDER = 'after'         % Whether we wish to apply filter to edge map to spread forces

% Force parameters for GVF
MU = 0.1
GVF_ITERATIONS = 10

% Create test image (white square on black background, no noise)
g = zeros(128);
g(64-16:64+15, 64-16:64+15) = 1;

% Compute edge map and then image forces over entire image
emap = snakeMap(g,T, SIG, NSIG, ORDER);

% Compute and display MOG-based forces
[Fx,Fy] = snakeForce(emap, 'MOG');
% Normalize forces
mag = hypot(Fx, Fy);
small = 1e-10; % To prevent division by zero
Fx = Fx ./ (mag + small);
Fy = Fy ./ (mag + small);
% Display test image with MOG force field superimposed as a quiver plot.
% For quiver function, I flip Fy and give it first then the flipped
% version of -Fx to conform to (row, col) coordinate system used with 
% images. Quiver uses a different coordinate system for calculations.
imshow(g), axis off
hold on
quiver(flipud(Fy), flipud(-Fx))
title('MOG Force Field')
hold off

% Compute and display GVF-based forces
[Fgvfx,Fgvfy] = snakeForce(emap, 'GVF', MU,GVF_ITERATIONS);
% Normalize forces
mag = hypot(Fgvfx, Fgvfy);
small = 1e-10; % To prevent division by zero
Fgvfx = Fgvfx ./ (mag + small);
Fgvfy = Fgvfy ./ (mag + small);
% For quiver function, I flip Fy and give it first then the flipped
% version of -Fx to conform to (row, col) coordinate system used with 
% images
% Display image and quiver plot of GVF force field
figure
imshow(g), axis off
hold on
quiver(flipud(Fgvfy), flipud(-Fgvfx))
title('GVF Force Field')
hold off


