% ACSD Program (Automatic Control System Design 
clear;
clc;
close all;

disp('=== Automatic Control System Designer ===');
disp(' ');

% get number of blocks
num_blocks = input('Enter the number of blocks: ');

% get transfer funcs 
G = cell(1, num_blocks);
disp(' ');
disp('Enter the transfer functions (as vectors):');
disp('Example: for (s+2)/(s^2+3s+1) -> Numerator: [1 2] and Denominator: [1 3 1]');
disp(' ');
for i = 1:num_blocks
    fprintf('Block G%d:\n', i);
    num = input(sprintf(' Numerator of G%d = ', i));
    den = input(sprintf(' Denominator of G%d = ', i));
    G{i} = tf(num, den);
    fprintf(' G%d = ', i);
    disp(G{i});
end

% get connection type as string
disp(' ');
disp('Enter how the blocks are connected:');
disp('Examples:');
disp(' - series(G1,G2)');
disp(' - parallel(G1,G2)');
disp(' - feedback(G1,G2)');
disp(' - feedback(series(G1,G2),G3)');
disp(' - series(parallel(G1,G2),G3)');
disp(' ');
connection_str = input('Connection string: ', 's');

% proccess the string and build the system
eval_str = connection_str;
for i = 1:num_blocks
    eval_str = strrep(eval_str, sprintf('G%d', i), sprintf('G{%d}', i));
end

disp(' ');
disp('Calculating the overall system transfer function...');
sys_total = eval(eval_str);
disp(' ');
disp('Overall system transfer function:');
disp(sys_total);

% get input type
disp(' ');
disp('Select the system input type:');
disp(' 1 - Step');
disp(' 2 - Ramp');
disp(' 3 - Sine');
input_type = input('Your choice: ');

% calculate and plot response 
t = 0:0.01:20;
figure('Name','Control System Response', 'Position', [100 100 1200 800]);

switch input_type
    case 1
        % Step input
        u = ones(size(t));
      
        subplot(3,1,1);
        plot(t, u, 'b', 'LineWidth', 2);
        title('Step Input', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        grid on;
      
        subplot(3,1,2);
        [y, t_out] = step(sys_total, t);
        plot(t_out, y, 'r', 'LineWidth', 2);
        title('System Output (Step Response)', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        grid on;
      
        subplot(3,1,3);
        plot(t, u, 'b', 'LineWidth', 1.5, 'DisplayName', 'Input');
        hold on;
        plot(t_out, y, 'r', 'LineWidth', 1.5, 'DisplayName', 'Output');
        title('Input vs Output Comparison', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        legend('show');
        grid on;
      
    case 2
        % Ramp input
        u = t;
      
        subplot(3,1,1);
        plot(t, u, 'b', 'LineWidth', 2);
        title('Ramp Input', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        grid on;
      
        subplot(3,1,2);
        y = lsim(sys_total, u, t);
        plot(t, y, 'r', 'LineWidth', 2);
        title('System Output (Ramp Response)', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        grid on;
      
        subplot(3,1,3);
        plot(t, u, 'b', 'LineWidth', 1.5, 'DisplayName', 'Input');
        hold on;
        plot(t, y, 'r', 'LineWidth', 1.5, 'DisplayName', 'Output');
        title('Input vs Output Comparison', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        legend('show');
        grid on;
      
    case 3
        % Sinusoidal input
        freq = input('Frequency of sinusoidal signal (Hz): ');
        u = sin(2*pi*freq*t);
      
        subplot(3,1,1);
        plot(t, u, 'b', 'LineWidth', 2);
        title('Sinusoidal Input', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        grid on;
      
        subplot(3,1,2);
        y = lsim(sys_total, u, t);
        plot(t, y, 'r', 'LineWidth', 2);
        title('System Output (Sinusoidal Response)', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        grid on;
      
        subplot(3,1,3);
        plot(t, u, 'b', 'LineWidth', 1.5, 'DisplayName', 'Input');
        hold on;
        plot(t, y, 'r', 'LineWidth', 1.5, 'DisplayName', 'Output');
        title('Input vs Output Comparison', 'FontSize', 14);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        legend('show');
        grid on;
      
    otherwise
        error('Invalid input!');
end
