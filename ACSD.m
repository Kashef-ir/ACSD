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

% calculate poles and zeros
figure('Name', 'System Characteristics', 'Position', [150 150 800 600]);

poles = pole(sys_total);
zeros_sys = zero(sys_total);

subplot(2,2,1);
pzmap(sys_total);
title('Pole-Zero Map', 'FontSize', 12);
grid on;

subplot(2,2,2);
bode(sys_total);
title('Bode Plot', 'FontSize', 12);
grid on;

subplot(2,2,3);
nyquist(sys_total);
title('Nyquist Plot', 'FontSize', 12);
grid on;

subplot(2,2,4);
rlocus(sys_total);
title('Root Locus', 'FontSize', 12);
grid on;

% display system info
disp(' ');
disp('=== System Specifications ===');
fprintf('Number of poles: %d\n', length(poles));
fprintf('Number of zeros: %d\n', length(zeros_sys));
disp(' ');
disp('System poles:');
disp(poles);
if ~isempty(zeros_sys)
    disp('System zeros:');
    disp(zeros_sys);
end

% stability check
if all(real(poles) < 0)
    disp('The system is stable');
else
    disp('The system is unstable');
end

% create simulink model
disp(' ');
create_simulink = input('Do you want to generate a Simulink model? (1=Yes, 0=No): ');
if create_simulink == 1
    model_name = 'AutoGeneratedControlSystem';
  
    % close and empty previous model if it exists
    if bdIsLoaded(model_name)
        close_system(model_name, 0);
    end
    if exist([model_name '.slx'], 'file')
        delete([model_name '.slx']);
    end
  
    % create new model
    new_system(model_name);
    open_system(model_name);
  
    % add input and output blocks
    add_block('simulink/Sources/Step', [model_name '/Input']);
    add_block('simulink/Sinks/Scope', [model_name '/Output']);
  
    % create each block individually
    x_pos = 300;
    y_base = 50;
  
    for i = 1:num_blocks
        block_name = sprintf('G%d', i);
      
        % add transfer function block
        add_block('simulink/Continuous/Transfer Fcn', [model_name '/' block_name]);
      
        % get numerator and denominator
        [num_i, den_i] = tfdata(G{i}, 'v');
      
        % set block parameters
        set_param([model_name '/' block_name], 'Numerator', mat2str(num_i));
        set_param([model_name '/' block_name], 'Denominator', mat2str(den_i));
      
        % set position (vertical column)
        y_pos = y_base + (i-1)*100;
        set_param([model_name '/' block_name], 'Position', [x_pos y_pos x_pos+100 y_pos+40]);
    end
  
    disp(' ');
    disp('Building block diagram...');
  
    % Build connections based on string
    try
        [first_block, last_block] = build_connections(model_name, connection_str, num_blocks);
      
        % Set input and output positions
        set_param([model_name '/Input'], 'Position', [50 200 100 230]);
        set_param([model_name '/Output'], 'Position', [900 200 950 230]);
      
        % Connect input to first block
        if ~isempty(first_block)
            try
                add_line(model_name, 'Input/1', [first_block '/1'], 'autorouting', 'on');
                disp(['Input connected to ' first_block '.']);
            catch
                disp(['Error: Could not connect input to ' first_block '.']);
            end
        else
            % Special case for simple parallel
            if startsWith(connection_str, 'parallel(G')
                tokens = regexp(connection_str, 'parallel\(G(\d+),G(\d+)\)', 'tokens');
                if ~isempty(tokens)
                    idx1 = str2double(tokens{1}{1});
                    idx2 = str2double(tokens{1}{2});
                    block1 = sprintf('G%d', idx1);
                    block2 = sprintf('G%d', idx2);
                    add_line(model_name, 'Input/1', [block1 '/1'], 'autorouting', 'on');
                    add_line(model_name, 'Input/1', [block2 '/1'], 'autorouting', 'on');
                    disp('Input connected to parallel blocks.');
                end
            end
        end
      
        % connect last block to output
        if ~isempty(last_block)
            try
                add_line(model_name, [last_block '/1'], 'Output/1', 'autorouting', 'on');
                disp(['Output connected from ' last_block '.']);
            catch
                disp(['Error: Could not connect ' last_block ' to output.']);
            end
        end
      
        % auto arrange layout
        Simulink.BlockDiagram.arrangeSystem(model_name);
      
        disp(['Simulink model "' model_name '" has been created successfully.']);
    catch ME
        disp('Error while building connections:');
        disp(ME.message);
        disp('Blocks were created but connections must be made manually.');
    end
end

disp(' ');
disp('Program finished');

% helper functions 
function [first_block, last_block] = build_connections(model_name, conn_str, num_blocks)
    % simple connection creator function
  
    % remove extra spaces
    conn_str = strtrim(conn_str);
  
    % simple series: series(G1,G2)
    if startsWith(conn_str, 'series(G') && ~contains(conn_str(8:end), 'series') && ~contains(conn_str(8:end), 'parallel') && ~contains(conn_str(8:end), 'feedback')
        tokens = regexp(conn_str, 'series\(G(\d+),G(\d+)\)', 'tokens');
        if ~isempty(tokens)
            idx1 = str2double(tokens{1}{1});
            idx2 = str2double(tokens{1}{2});
          
            block1 = sprintf('G%d', idx1);
            block2 = sprintf('G%d', idx2);
          
            add_line(model_name, [block1 '/1'], [block2 '/1'], 'autorouting', 'on');
            first_block = block1;
            last_block = block2;
            return;
        end
      
    % simple parallel: parallel(G1,G2)
    elseif startsWith(conn_str, 'parallel(G') && ~contains(conn_str(10:end), 'series') && ~contains(conn_str(10:end), 'parallel') && ~contains(conn_str(10:end), 'feedback')
        tokens = regexp(conn_str, 'parallel\(G(\d+),G(\d+)\)', 'tokens');
        if ~isempty(tokens)
            idx1 = str2double(tokens{1}{1});
            idx2 = str2double(tokens{1}{2});
          
            block1 = sprintf('G%d', idx1);
            block2 = sprintf('G%d', idx2);
          
            % Add Sum block for parallel output
            add_block('simulink/Math Operations/Sum', [model_name '/Sum_Out']);
            set_param([model_name '/Sum_Out'], 'Inputs', '++');
          
            % Connect block outputs to Sum
            add_line(model_name, [block1 '/1'], 'Sum_Out/1', 'autorouting', 'on');
            add_line(model_name, [block2 '/1'], 'Sum_Out/2', 'autorouting', 'on');
          
            first_block = []; % input will be branched
            last_block = 'Sum_Out';
            return;
        end
      
    % simple feedback: feedback(G1,G2)
    elseif startsWith(conn_str, 'feedback(G') && ~contains(conn_str(10:end), 'series') && ~contains(conn_str(10:end), 'parallel') && ~contains(conn_str(10:end), 'feedback')
        tokens = regexp(conn_str, 'feedback\(G(\d+),G(\d+)\)', 'tokens');
        if ~isempty(tokens)
            idx1 = str2double(tokens{1}{1});
            idx2 = str2double(tokens{1}{2});
          
            block1 = sprintf('G%d', idx1); % forward path
            block2 = sprintf('G%d', idx2); % feedback path
          
            % add sum block for feedback
            add_block('simulink/Math Operations/Sum', [model_name '/Sum_FB']);
            set_param([model_name '/Sum_FB'], 'Inputs', '+-');
          
            % connections
            add_line(model_name, 'Sum_FB/1', [block1 '/1'], 'autorouting', 'on');
            add_line(model_name, [block1 '/1'], [block2 '/1'], 'autorouting', 'on');
            add_line(model_name, [block2 '/1'], 'Sum_FB/2', 'autorouting', 'on');
          
            first_block = 'Sum_FB';
            last_block = block1;
            return;
        end
    else
        % complex structure - needs recursive parser (will be done in next updates)
        warning('Complex structure detected. Please make connections manually.');
        first_block = [];
        last_block = [];
    end
end
