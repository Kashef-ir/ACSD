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
