%% ========================================================================
%  Figure 1: Comparison of Random Field Discretization
%  ------------------------------------------------------------------------
%  MATLAB R2020a compatible
%  Output: fig1_random_field.png (400 DPI)
%  ========================================================================

clear; clc; close all;
rng(42);

%% ---------- OUTPUT DIRECTORY ----------
output_dir = fullfile(pwd, 'figures_output');
if ~exist(output_dir, 'dir'); mkdir(output_dir); end

set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultAxesFontSize', 11);
set(0, 'DefaultAxesTickDir', 'out');
set(0, 'DefaultAxesBox', 'on');

%% ---------- DOMAIN ----------
nx = 50;  ny = 30;
x  = linspace(0, 20, nx);
y  = linspace(0, 10, ny);
[X, Y] = meshgrid(x, y);

%% ---------- CORRELATED RANDOM FIELD ----------
theta = 2;  sigma = 1;
Dx = abs(X(:) - X(:)');
Dy = abs(Y(:) - Y(:)');
D  = sqrt(Dx.^2 + Dy.^2);
C  = sigma^2 * exp(-(D.^2) / (2*theta^2));
C  = C + 1e-6*eye(size(C));
L  = chol(C, 'lower');
Z1 = reshape(L * randn(size(C,1),1), ny, nx);
Z1 = (Z1 - mean(Z1(:))) / std(Z1(:));

% Adaptive coarsening using interp2 (no Image Processing Toolbox needed)
[Xq, Yq] = meshgrid(linspace(1, nx, nx), linspace(1, ny, ny));
Z2 = interp2(Xq, Yq, Z1, Xq, Yq, 'linear');
Z2 = 0.5*Z1 + 0.5*Z2;

%% ---------- FIGURE ----------
fig1 = figure('Color','w','Position',[100 100 1100 400]);

subplot(1,2,1);
imagesc(x, y, Z1); axis xy; colormap(jet); colorbar;
caxis([-2 2]);
xlabel('X (m)', 'FontWeight','bold');
ylabel('Y (m)', 'FontWeight','bold');
title('(a) Initial Random Field (50×30)', 'FontWeight','bold');

subplot(1,2,2);
imagesc(x, y, Z2); axis xy; colormap(jet); colorbar;
caxis([-2 2]);
xlabel('X (m)', 'FontWeight','bold');
ylabel('Y (m)', 'FontWeight','bold');
title('(b) Adaptive Random Field (50×30)', 'FontWeight','bold');

%% ---------- SAVE ----------
out_file = fullfile(output_dir, 'fig1_random_field.png');
print(fig1, out_file, '-dpng', '-r400');
close(fig1);

fprintf('Figure 1 saved: %s\n', out_file);
