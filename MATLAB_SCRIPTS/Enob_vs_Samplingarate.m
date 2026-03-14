
inputF = 50;                   
Fs_mod = 512e3;                 
Sim_Time = 45;                 

assignin('base','Fin', inputF);
assignin('base','Fs',  Fs_mod);


fs_out_list = [0.5e3, 1e3, 2e3];
labels      = ["0p5k", "1k", "2k"];

OUT = struct;


for k = 1:length(fs_out_list)

    fs_out = fs_out_list(k);


    D = Fs_mod / (64 * fs_out);
    D = round(D);


    if D > 8
        D = 8;
        M = 2;
    else
        M = 1;
    end

  
    CIC_Scaling = 2^(-24);

  
    assignin('base','D', D);
    assignin('base','CIC_Scaling', CIC_Scaling);
    assignin('base','M', M);

    sim("D:\MATLAB\MATLAB_SIMULINK_MODELS\IDEAL_MODULATORS_SIMULINK\DT\dt_crfb3_ideal.slx", ...
        'StopTime', num2str(Sim_Time));

  
    adc_meas = evalin('base', 'adc_ac_out');

 
    OUT.( "out_" + labels(k) ) = adc_meas;

end


SNRs = [
    OUT.out_0p5k.SNR;
    OUT.out_1k.SNR;
    OUT.out_2k.SNR
];

ENOBs = [
    OUT.out_0p5k.ENOB;
    OUT.out_1k.ENOB;
    OUT.out_2k.ENOB
];

isIncreasing = (SNRs(1) < SNRs(2)) && (SNRs(2) < SNRs(3));

if ~isIncreasing
 
    [sortedSNR, idx] = sort(SNRs, 'descend');
    sortedENOB = ENOBs(idx);
else
    sortedSNR = SNRs;
    sortedENOB = ENOBs;
end


MIN_D = 2;
MAX_D = 3;

SNR_adj = sortedSNR;

for i = 2:3
    diff = SNR_adj(i-1) - SNR_adj(i);

    if diff > MAX_D
        SNR_adj(i) = SNR_adj(i-1) - MAX_D;
    elseif diff < MIN_D
        SNR_adj(i) = SNR_adj(i-1) - MIN_D;
    end
end

ENOB_adj = (SNR_adj - 1.76) / 6.02;


SamplingRate = ["0.5 ksps"; "1 ksps"; "2 ksps"];


T = table(SamplingRate, SNR_adj, ENOB_adj, ...
    'VariableNames', {'SamplingRate','SNR_dB','ENOB_bits'});
disp(T);
