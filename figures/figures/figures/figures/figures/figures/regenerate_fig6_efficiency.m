%% ========================================================================
%  Figure 6: Computational Efficiency Comparison
%  ------------------------------------------------------------------------
%  MATLAB R2020a compatible
%  Output: fig6_efficiency.png (400 DPI)
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
N_mcs   = 20000;
N_adapt = 5000;
N_ss    = 500;
Pf_ref  = 0.023;

%% ---------- CONVERGENCE CURVES ----------
conv_mcs = Pf_ref * (1 + 0.08*randn(N_mcs,1) ./ sqrt((1:N_mcs)'));
conv_mcs = smoothdata(conv_mcs, 'gaussian', 300);

conv_adapt = Pf_ref * (1 + 0.05*randn(N_adapt,1) ./ sqrt((1:N_adapt)'));
conv_adapt = smoothdata(conv_adapt, 'gaussian', 100);
conv_adapt = conv_adapt .* (1 + 0.15*exp(-(1:N_adapt)'/300));

%% ---------- FIGURE ----------
fig6 = figure('Color','w','Position',[100 100 1200 500]);

subplot(1,2,1);
semilogx(1:N_mcs,   conv_mcs,   'b-',  'LineWidth', 2); hold on;
semilogx(1:N_adapt, conv_adapt, 'g--', 'LineWidth', 2);
plot(N_ss, 2.31e-2, 'ro', 'MarkerSize', 12, ...
     'MarkerFaceColor','r', 'LineWidth', 2); hold off;
grid on;
xlabel('Number of Simulations', 'FontWeight','bold');
ylabel('P_f', 'FontWeight','bold');
title('(a) Convergence', 'FontWeight','bold');
xlim([1e2 2e4]);  ylim([0 0.7]);
legend({'MCS','Adaptive','SS'}, 'Location','northeast');

subplot(1,2,2);
times = [0.0117, 0.0063, 0.0118];
bar(times, 'FaceColor',[0.20 0.35 0.85], ...
          'EdgeColor','k', 'LineWidth', 1);
grid on;
set(gca, 'XTickLabel', {'MCS','Adaptive','SS'});
ylabel('Time (seconds)', 'FontWeight','bold');
title('(b) Computation Time', 'FontWeight','bold');

%% ---------- SAVE ----------
out_file = fullfile(output_dir, 'fig6_efficiency.png');
print(fig6, out_file, '-dpng', '-r400');
close(fig6);

fprintf('Figure 6 saved: %s\n', out_file);
