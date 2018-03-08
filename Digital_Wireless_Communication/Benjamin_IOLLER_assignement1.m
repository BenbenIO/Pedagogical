% ================================
%We simulate the signal transmition, then calculate the error probability
%Each simulation increase the signal per energy bit (Eb/No), link between SNR and Eb/No is explained in sources.
% -BER1: only AWGN, 
% -BER2: fading + AWGN
% The simulation uses separate function to help understanding and to keep the wireless communication structure:
% Signal Generation->Modulation->Transmission->Demodulation->BER
% ================================
clc;
clear all;
close all;
format long;

%% PARAMETERS
%Range of the simulation
SNR = 0:1:60;

%% MAIN LOOP
for n=1:1:length(SNR)
    [BER1(n),BER2(n)]=BER_BPSKsim(SNR(n));
end    

%% BER PLOTING:
% Simulated BER
figure;
semilogy(SNR,BER1,'o-b');           %Case H=1: No fading, only AWGN
hold on;
semilogy(SNR,BER2,'o-g');           %Case H!=1: Rayeigh fading and AWGN
hold on;
grid on;
xlabel('Eb/No (dB)');
ylabel('BER'); 
title({'Simulated and Theoretical BPSK modulation','with Rayeigh fading and AWGN'});

% Theoretical BER
hold on;
SNRlin=10.^(SNR/10);
theoryBER = .5*erfc(sqrt(SNRlin));                  %BER AWGN.
theoryBERfad = .5*(1-sqrt((SNRlin./(1+SNRlin))));   %BER on fading channel.
semilogy(SNR,theoryBER,'-r');                       
semilogy(SNR,theoryBERfad,'-r');                    
legend('Simulated BPSK over only AWGN','Simulated BPSK over fading+AWGN', 'Theoretical BPSK over AWGN only','Theoretical BPSK over fading+AWGN');
axis([0 length(SNR) 10^-6 1]);
