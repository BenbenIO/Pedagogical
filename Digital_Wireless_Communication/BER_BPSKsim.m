function [ BER1, BER2 ] = BER_BPSKsim( SNR )
% ================================
% This function is use to simulate a BPSK signal over a Rayeigh fading
% channel with additive white Gaussian noise.
% This function calculs 2 BER:
% -BER1: only AWGN, 
% -BER2: fading + AWGN
% The simulation uses separate function to help understanding and to keep the wireless communication structure:
% Signal Generation->Modulation->Transmission->Demodulation->BER
% ================================
%% PARAMETERS
format long;
%Signal size: 
%The lengh of signal is really important to have goodsimulation graphic.
Nobits=100000;
%Ber parameter initialisation
nb_Error=0;
nb_Error2=0;

%% SIGNAL, FADING AND NOISE GENERATION:
%BPSK generation via a random function
for k =1:1:Nobits
    Uncoded_signal(k)=rand;
    if Uncoded_signal(k)<0.5
        S(k)=-1;                    %S for signal, S = -1 if rand<0.5
    else    
        S(k)=1;                     %S for signal, S = +1 if rand>0.5
    end
end
    
%Noise Variance and Noise generation:
NO=10^(-SNR/10);
N = sqrt(NO/2)*[randn(1,length(S)) + i*randn(1,length(S))];     %randn generate a matrix of rand.
%Fading generation:
H=sqrt(.5)*[randn(1,length(S)) + i*randn(1,length(S))];

%% SIGNAL TRANSMITION:
R1=S+N;             %Case H=1: No fading, only AWGN
R2=H.*S+N;          %Case H!=1: Rayeigh fading and AWGN

%% SIGNAL DEMODULATION: (zero forcing)
Rd=R2./H;

%% BER CALCULATION:
for k =1:1:Nobits
    if S(k)*R1(k)<0              %if R>0 & S<0 or R<0 & S>0 
        nb_Error=nb_Error+1;     %only AWGN
    end
    if S(k)*Rd(k)<0              %if R>0 & S<0 or R<0 & S>0
        nb_Error2=nb_Error2+1;   %faging and AWGN
    end
end
BER1=nb_Error/Nobits;            %Case H=1: No fading, only AWGN
BER2=nb_Error2/Nobits;           %Case H!=1: Rayeigh fading and AWGN

end

