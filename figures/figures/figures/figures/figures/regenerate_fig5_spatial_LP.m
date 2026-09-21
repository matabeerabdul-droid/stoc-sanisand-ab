%% ========================================================================
%  Figure 5: Spatial Liquefaction Potential Maps (4 panels a-d)
%  ------------------------------------------------------------------------
%  MATLAB R2020a compatible
%  Output: fig5a_random_field.png, fig5b_LP_map.png,
%          fig5c_histogram_LP.png, fig5d_binary_map.png (400 DPI each)
%  ========================================================================

clear; clc; close all;
rng(42);

%% ---------- OUTPUT DIRECTORY ----------
output_dir = fullfile(pwd, 'figures_output');
if ~exist(output_dir, 'dir'); mkdir(output_dir); end

set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultAxesTickDir', 'out');
set(0, 'DefaultAxesBox', 'on');

%% ---------- DOMAIN ----------
nx = 40;  ny = 25;
x  = linspace(0, 20, nx);
y  = linspace(0, 10, ny);
[X, Y] = meshgrid(x, y);
n_total = nx * ny;

%% ---------- CORRELATED RANDOM FIELD ----------
theta = 2;  sigma = 1;
Dx = abs(X(:) - X(:)');
Dy = abs(Y(:) - Y(:)');
D  = sqrt(Dx.^2 + Dy.^2);
C  = sigma^2 * exp(-(D.^2) / (2*theta^2));
C  = C + 1e-6*eye(size(C));
L  = chol(C, 'lower');
Z  = reshape(L * randn(size(C,1),1), ny, nx);
Z  = (Z - mean(Z(:))) / std(Z(:));

%% ---------- BUILD BIMODAL LP FIELD ----------
n_full = round(0.018 * n_total);   % 18 cells
n_elev = round(0.220 * n_total);   % 220 cells
n_safe = n_total - n_full - n_elev;

[~, sort_idx] = sort(Z(:), 'descend');
idx_full = sort_idx(1:n_full);
idx_elev = sort_idx(n_full+1 : n_full+n_elev);
idx_safe = sort_idx(n_full+n_elev+1 : end);

LP_flat = zeros(n_total, 1);
LP_flat(idx_safe) = 0.08 + 0.15 * rand(n_safe, 1);
LP_flat(idx_elev) = 0.55 + 0.35 * rand(n_elev, 1);
LP_flat(idx_full) = 0.96 + 0.04 * rand(n_full, 1);
LP = reshape(LP_flat, ny, nx);

fprintf('Fully liquefied (LP>0.95): %.2f%%\n', ...
        100*sum(LP(:)>0.95)/n_total);
fprintf('Elevated risk (0.5<LP<=0.95): %.2f%%\n', ...
        100*sum(LP(:)>0.5 & LP(:)<=0.95)/n_total);

%% ---------- FIGURE 5(a): Adaptive Random Field ----------
fig5a = figure('Color','w','Position',[100 100 800 450]);
imagesc(x, y, Z); axis xy; colormap(jet);
cb = colorbar;
cb.Label.String = 'Z(x, y)';
cb.Label.FontWeight = 'bold';
caxis([-1.5 1.5]);
xlabel('X (m)', 'FontWeight','bold', 'FontSize', 13);
ylabel('Y (m)', 'FontWeight','bold', 'FontSize', 13);
title('Figure 5(a): Adaptive Random Field Z(x, y)', ...
      'FontWeight','bold', 'FontSize', 13);
set(gca, 'XTick', 0:2:20, 'YTick', 0:2:10);
print(fig5a, fullfile(output_dir, 'fig5a_random_field.png'), ...
      '-dpng', '-r400');
close(fig5a);

%% ---------- FIGURE 5(b): Spatial LP Map ----------
fig5b = figure('Color','w','Position',[100 100 800 450]);
imagesc(x, y, LP); axis xy; colormap(jet);
cb = colorbar;
cb.Label.String = 'Liquefaction Potential, LP';
cb.Label.FontWeight = 'bold';
caxis([0 1]);
xlabel('X (m)', 'FontWeight','bold', 'FontSize', 13);
ylabel('Y (m)', 'FontWeight','bold', 'FontSize', 13);
title('Figure 5(b): Spatial Liquefaction Potential LP(x, y)', ...
      'FontWeight','bold', 'FontSize', 13);
set(gca, 'XTick', 0:5:20, 'YTick', 0:2:10);
print(fig5b, fullfile(output_dir, 'fig5b_LP_map.png'), '-dpng', '-r400');
close(fig5b);

%% ---------- FIGURE 5(c): Histogram ----------
fig5c = figure('Color','w','Position',[100 100 800 550]);
edges = linspace(0, 1, 21);
histogram(LP(:), edges, 'FaceColor',[0.85 0.33 0.30], ...
          'EdgeColor','k', 'LineWidth', 0.5);
grid on;
xlabel('Liquefaction Potential (LP)', 'FontWeight','bold', 'FontSize', 13);
ylabel('Frequency (number of cells)', 'FontWeight','bold', 'FontSize', 13);
title('Figure 5(c): Bimodal Distribution of LP across Domain', ...
      'FontWeight','bold', 'FontSize', 13);
xlim([0 1]); ylim([0 800]);
set(gca, 'XTick', 0:0.1:1);
print(fig5c, fullfile(output_dir, 'fig5c_histogram_LP.png'), ...
      '-dpng', '-r400');
close(fig5c);

%% ---------- FIGURE 5(d): Binary Map ----------
fig5d = figure('Color','w','Position',[100 100 800 450]);
imagesc(x, y, double(LP > 0.95)); axis xy;
colormap(gca, [0.92 0.92 0.92; 0.10 0.60 0.20]);
xlabel('X (m)', 'FontWeight','bold', 'FontSize', 13);
ylabel('Y (m)', 'FontWeight','bold', 'FontSize', 13);
pct_full = 100 * sum(LP(:)>0.95) / n_total;
title(sprintf('Figure 5(d): Fully Liquefied Zones (LP > 0.95): %.1f%%', ...
      pct_full), 'FontWeight','bold', 'FontSize', 13);
set(gca, 'XTick', 0:2:20, 'YTick', 0:2:10);
print(fig5d, fullfile(output_dir, 'fig5d_binary_map.png'), ...
      '-dpng', '-r400');
close(fig5d);

fprintf('\nAll Figure 5 panels saved.\n');
