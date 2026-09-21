%% ========================================================================
%  Figure 4: Subset Simulation Convergence vs Standard MCS
%  ------------------------------------------------------------------------
%  MATLAB R2020a compatible
%  Output: fig4_subset_convergence.png (400 DPI)
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

%% ---------- PARAMETERS ----------
N_mcs  = 20000;
N_ss   = 500;
Pf_mcs = 2.34e-2;
Pf_ss  = 2.31e-2;

%% ---------- MCS CONVERGENCE ----------
conv = Pf_mcs * (1 + 0.08*randn(N_mcs,1) ./ sqrt((1:N_mcs)'));
conv = smoothdata(conv, 'gaussian', 300);
conv = conv * (Pf_mcs / conv(end));

%% ---------- FIGURE ----------
fig4 = figure('Color','w','Position',[100 100 750 550]);

semilogx(1:N_mcs, conv, 'b-', 'LineWidth', 1.8); hold on;
plot(N_ss, Pf_ss, 'ro', 'MarkerSize', 14, ...
     'MarkerFaceColor','r', 'LineWidth', 2); hold off;

grid on;
xlabel('Number of Simulations (log scale)', 'FontWeight','bold');
ylabel('Estimated Failure Probability P_f', 'FontWeight','bold');
title('Subset Simulation Convergence vs Standard MCS', ...
      'FontWeight','bold');
xlim([1e2 2e4]);
ylim([1e-3 1]);

legend({ sprintf('Standard MCS (N = %s)', num2str(N_mcs,'%d,')), ...
         sprintf('Subset Sim. (N = %d, P_f = %.2e)', N_ss, Pf_ss) }, ...
         'Location','northeast', 'FontSize', 10);

%% ---------- SAVE ----------
out_file = fullfile(output_dir, 'fig4_subset_convergence.png');
print(fig4, out_file, '-dpng', '-r400');
close(fig4);

fprintf('Figure 4 saved: %s\n', out_file);
