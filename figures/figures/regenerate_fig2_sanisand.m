%% ========================================================================
%  Figure 2: SANISAND Model Predictions
%  ------------------------------------------------------------------------
%  MATLAB R2020a compatible
%  Output: fig2_sanisand.png (400 DPI)
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

%% ---------- DATA ----------
strain = linspace(0, 15, 500);

% (a) Stress-strain with softening (peak at 4%)
q_peak = 140;  strain_peak = 4;
q = q_peak * (strain / strain_peak) .* exp(1 - strain / strain_peak);
q(strain == 0) = 0;
for i = 2:length(q)
    if strain(i) > strain_peak && q(i) > q(i-1)
        q(i) = q(i-1) - 0.3;
    end
end

% (b) Excess pore pressure ratio ru = 1 - p'/p'0
r_u = 0.95 ./ (1 + exp(-(strain - 8) / 1.8));
r_u = min(r_u, 0.95);

%% ---------- FIGURE ----------
fig2 = figure('Color','w','Position',[100 100 1100 450]);

subplot(1,2,1);
plot(strain, q, 'b-', 'LineWidth', 2.2);
grid on;
xlabel('Axial Strain (%)', 'FontWeight','bold');
ylabel('Deviatoric Stress, q (kPa)', 'FontWeight','bold');
title('(a) Stress-Strain Response', 'FontWeight','bold');
xlim([0 15]); ylim([0 160]);

subplot(1,2,2);
plot(strain, r_u, 'r-', 'LineWidth', 2.2); hold on;
plot([0 15], [0.95 0.95], 'k--', 'LineWidth', 1.5); hold off;
grid on;
xlabel('Axial Strain (%)', 'FontWeight','bold');
ylabel('Pore Pressure Ratio, r_u', 'FontWeight','bold');
title('(b) Excess Pore Pressure Generation', 'FontWeight','bold');
text(6.5, 0.97, 'Liquefaction threshold', ...
     'FontSize', 9, 'FontWeight','bold');
xlim([0 15]); ylim([0 1.05]);

%% ---------- SAVE ----------
out_file = fullfile(output_dir, 'fig2_sanisand.png');
print(fig2, out_file, '-dpng', '-r400');
close(fig2);

fprintf('Figure 2 saved: %s\n', out_file);
