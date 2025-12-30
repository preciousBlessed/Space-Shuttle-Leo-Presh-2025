% SIPRO Lab 2: Space Shuttle
% Dated: 13/11/2025/

% Group Project with Members:
%Name 1: OLUKA Leonard % leonard.oluka@eleves.ec-nantes.fr
%Name 2: CHUKWUEZI Tochukwu Precious % tochukwu-precious.chukwuezi@eleves.ec-nantes.fr

% Supervised By
% Prof. Eric Le-Carpentier % eric.le-carpentier@ec-nantes.fr [S519]
% Prof. Ina Taralova % ina.taralova@ec-nantes.fr [S318, S310]



% Before running Simulink, run this file so that we will load the variables
% to the workspace, since Simulink uses the variables declared here.
%% C.3.2 Transfer function and state space representation
%clc, clear;

% Define System Parameters
wo = 2;
G = 1;
ts = 0.1;
num = G*wo^2;
den = [1 0 wo^2];

A = [0 1; -1*wo^2 0];
B = [0; G*wo^2];
C = [1 0];
D = 0;

% Hyperparameters
alpha_norm = 0.3;

% Obtaining the Transfer Functions, Continuous in L and Discrete in Z
Lhs = tf(num, den); % Lh(s)
Zht = c2d(Lhs,ts); % Zh-tilde of z
%% Step Response
ax = gca;
step(Lhs, Zht);
xlim(ax, [0 8]);
legend('continuous', 'discrete');
grid on;
%% C.3.2 Transfer function and state space representation for Continuous and Discrete
sys_continuous = ss(A, B, C, D);
sys_discrete = c2d(sys_continuous, ts);
[Atilde, Btilde, ~] = ssdata(sys_discrete);

[numd, dend] = tfdata(Zht, 'v');
disp(numd);
disp(dend);
%% C.3.3: Open Loop Simulation

% Completion of Necessary Functions

% 1. navettecontinue
function xpoint = navettecontinue(t, x, A, B)
    % xpoint = dx/dt = A*x + B*u(t)
    % Step input: u(t) = 0.05Nm * 1_{t >= 1} % indicator function
    if t >= 1
        u = 0.05;
    else
        u = 0;
    end
    % We return the state derivative
    xpoint = A*x + B*u;
end

% 2. navettediscrete
function xeplus = navettediscrete(n, xe, Atilde, Btilde, ts)
    % xeplus = x[n+1] = Atilde*x[n] + Btilde*u[n]
    
    % We must find the corresponding time index n when
    % the unit-step pulse switches, given that we
    % know n and ts.Since t = n*ts, and pulse switches 
    % when t = 1, then we solve 1 = n*ts, so that 
    % n = floor(1/Ts) = fs

    fs = floor(1/ts);

    % Step input: u[n] = 0.05Nm * 1_{n >= fs} % indicator function
    if n >= fs % or if n*ts >= 1
        u = 0.05;
    else
        u = 0;
    end

    % Next state
    xeplus = Atilde * xe + Btilde * u;
end
%% Simulation Proper

% Initial state, where our state vector x = [alpha_tilde, omega]
% we were told that alpha(0) = alpha_norm
% alpha_tilde(0) = alpha_norm - alpha_norm = 0, hence

x0 = [0; 0];
%% Continuous-Time Simulation
tic
fc = @(t,x) navettecontinue(t, x, A, B);
[t_cont, X_cont] = ode45(fc, [0 8], x0);
time_cont = toc;

alpha_cont = X_cont(:,1) + 0.3;   % output = first state
%% Discrete-Time Simulation
Nmax = round(8/ts);

tic
fd = @navettediscrete;
[N, X_disc] = ore(fd, [0 Nmax], x0, Atilde, Btilde, ts); % or ore(@(n,x) navettediscrete(n, x, Atilde, Btilde, ts), [0 round(8/ts)], x0)
time_disc = toc;

alpha_disc = X_disc(:,1) + 0.3;   % output = first state
t_disc = N * ts;
%% Plotting Results
figure;
plot(t_cont, alpha_cont, 'r','LineWidth', 1.5); hold on;
%plot(t_disc, alpha_disc, 'b','LineWidth', 1.5);
stairs(t_disc, alpha_disc, 'k', 'LineWidth', 1);
xlabel('Time (s)');
ylabel('\alpha (rad)');
legend('Continuous', 'Discrete');
title('Open-loop Shuttle Response');
grid on;
%% Displaying Computation Times
fprintf('Continuous simulation time: %.6f seconds\n', time_cont);
fprintf('Discrete simulation time:   %.6f seconds\n', time_disc);
%% 3.5 Closed Loop Simulation
KI = 2.70; %Nmrad−1 s−1
KP = 1.25; %Nmrad−1
KD = 0.75; %Nms rad−1
Ts = ts;

%% 3.6 Closed Loop with PWM

E = 0.05; % peak of torque
Tpwm = 0.02; % period of PWM


