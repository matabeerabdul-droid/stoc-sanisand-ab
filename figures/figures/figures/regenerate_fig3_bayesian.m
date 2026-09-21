%% ========================================================================
%  Figure 3: Bayesian Updating (5 panels a-e)
%  ------------------------------------------------------------------------
%  MATLAB R2020a compatible
%  Output: fig3_bayesian.png (400 DPI)
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

%% ---------- GENERATE DISTRIBUTIONS ----------
N = 5000;

prior_G0 = 125 + 10*randn(N,1);
post_G0  = 125 + 4*randn(N,1);

prior_nu = 0.30 + 0.05*randn(N,1);
post_nu  = 0.29 + 0.025*randn(N,1);

prior_M = 1.20 + 0.10*randn(N,1);
post_M  = 1.20 + 0.055*randn(N,1);

prior_e0 = 0.70 + 0.15*randn(N,1);
post_e0  = 0.65 + 0.09*randn(N,1);

prior_LP = 0.50 + 0.17*randn(N,1);
post_LP  = 0.67 + 0.10*randn(N,1);

%% ---------- FIGURE ----------
fig3 = figure('Color','w','Position',[50 50 1400 850]);

subplot(2,3,1);
histogram(prior_G0, 30, 'FaceColor',[0.30 0.55 0.85], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold on;
histogram(post_G0, 30, 'FaceColor',[0.90 0.45 0.30], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold off;
grid on;
xlabel('G_0 (Shear Modulus Constant)', 'FontWeight','bold');
ylabel('Probability Density', 'FontWeight','bold');
title('(a) G_0 Distribution', 'FontWeight','bold');
legend({'Prior','Posterior'}, 'Location','northeast');

subplot(2,3,2);
histogram(prior_nu, 30, 'FaceColor',[0.30 0.55 0.85], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold on;
histogram(post_nu, 30, 'FaceColor',[0.90 0.45 0.30], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold off;
grid on;
xlabel('nu (Poisson Ratio)', 'FontWeight','bold');
ylabel('Probability Density', 'FontWeight','bold');
title('(b) Poisson Ratio Distribution', 'FontWeight','bold');
legend({'Prior','Posterior'}, 'Location','northeast');

subplot(2,3,3);
histogram(prior_M, 30, 'FaceColor',[0.30 0.55 0.85], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold on;
histogram(post_M, 30, 'FaceColor',[0.90 0.45 0.30], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold off;
grid on;
xlabel('M (Critical State Stress Ratio)', 'FontWeight','bold');
ylabel('Probability Density', 'FontWeight','bold');
title('(c) M Distribution', 'FontWeight','bold');
legend({'Prior','Posterior'}, 'Location','northeast');

subplot(2,3,4);
histogram(prior_e0, 30, 'FaceColor',[0.30 0.55 0.85], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold on;
histogram(post_e0, 30, 'FaceColor',[0.90 0.45 0.30], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold off;
grid on;
xlabel('e_0 (Initial Void Ratio)', 'FontWeight','bold');
ylabel('Probability Density', 'FontWeight','bold');
title('(d) e_0 Distribution', 'FontWeight','bold');
legend({'Prior','Posterior'}, 'Location','northeast');

subplot(2,3,5);
histogram(prior_LP, 30, 'FaceColor',[0.30 0.55 0.85], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold on;
histogram(post_LP, 30, 'FaceColor',[0.90 0.45 0.30], ...
          'FaceAlpha',0.6, 'EdgeColor','k'); hold off;
grid on;
xlabel('Liquefaction Potential (LP)', 'FontWeight','bold');
ylabel('Probability Density', 'FontWeight','bold');
title('(e) LP Distribution', 'FontWeight','bold');
legend({'Prior','Posterior'}, 'Location','northeast');

%% ---------- SAVE ----------
out_file = fullfile(output_dir, 'fig3_bayesian.png');
print(fig3, out_file, '-dpng', '-r400');
close(fig3);

fprintf('Figure 3 saved: %s\n', out_file);
