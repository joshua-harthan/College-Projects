%% Set the fastsim flag
% 0 : Full Simulation
% 1 : Developer's Mode
% 2 : Fast Developers's Mode
% 3 : HDL Coder Mode
mp.fastsim_flag = 1;

%% Set Audio Data Sample Rate
mp.Fs = 48000;      % sample rate frequency of AD1939 codec in Hz
mp.Ts = 1/mp.Fs;    % sample period

%% Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The system clock frequency should be an integer multiple of the Audio
% codec AD1939 Mclk frequency (12.288 MHz)
switch mp.fastsim_flag % set system clock and audio length based on simulation mode
    case 0
        mp.Fs_system = 98304000;      % System clock frequeny in Hz of Avalon Interface Mclk*8 = 12.288MHz*8=98304000
        mp.Naudio_samples = -1;       % - 1 = no truncation
    case 1
        mp.Fs_system = mp.Fs * 2;     % slow system clock
        mp.Naudio_samples = -1;       % -1 = no truncation
    case 2
        mp.Fs_system = mp.Fs * 2;     % slow system clock
        mp.Naudio_samples = mp.Fs;    % sound truncated to 1 second
    case 3
        mp.Fs_system = 98304000;      % System clock frequency in Hz of Avalon Interface Mclk*8 = 12.288MHz*8=98304000
        mp.Naudio_samples = mp.Fs/10; % audio truncated to 100 milliseconds
end
mp.Ts_system = 1/mp.Fs_system;        % System clock period

%% Set the data type for audio signal (left and right channels) in data plane
mp.W_bits = 32; % Word length
mp.F_bits = 28; % Number of fractional bits in word

%% Create test signals for the left and right channels
mp = sm_init_test_signals(mp); % create the test signals that will go through the model

%% Put the test signals into the Avalon Streaming Bus format
% i.e. put the test signals into the data-channel-valid protocol
mp = sm_init_avalon_signals(mp); % create the avalon streaming signals

%% Create the control signals before the simulation starts
mp = sm_init_control_signals(mp); % create the control signals
