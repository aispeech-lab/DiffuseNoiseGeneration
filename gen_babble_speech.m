%--------------------------------------------------------------------------
%
% Example that generates babble speech received by a uniform linear array
% of sensors.
%
% Author        : E.A.P. Habets
% Date          : 29-06-2017
%
% Related paper : E.A.P. Habets, I. Cohen and S. Gannot, 'Generating
%                 nonstationary multisensor signals under a spatial
%                 coherence constraint', Journal of the Acoustical Society
%                 of America, Vol. 124, Issue 5, pp. 2911-2917, Nov. 2008.
%
% Remark        : For babble speech the Cholesky decomposition is often
%                 preferred.
%
% Copyright (C) 2009-2017 E.A.P. Habets
%  
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%  
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
%
%--------------------------------------------------------------------------

close all;
clear;

% Initialization
Fs = 16000;                % Sample frequency (Hz)
c = 340;                  % Sound velocity (m/s)
K = 256;                  % FFT length
M = 4;                    % Number of sensors
d = 0.03;                  % Inter sensor distance (m)
type_nf = 'spherical';    % Type of noise field:
                          % 'spherical' or 'cylindrical'
L = 45*Fs;                % Data length

% Generate 'independent' babble speech input signals
[data,Fs_data] = audioread('Babble.wav');
if Fs ~= Fs_data
    error('Sample frequency of input file is incorrect.');
end
data = data - mean(data);
babble = zeros(L,M);
for m=1:M
    babble(:,m) = data((m-1)*L+1:m*L);
end

%% Generate matrix with desired spatial coherence
ww = 2*pi*Fs*(0:K/2)/K;
DC = zeros(M,M,K/2+1);
for p = 1:M
    for q = 1:M
        if p == q
            DC(p,q,:) = ones(1,1,K/2+1);
        else
            switch abs(p-q)
                case 0
                    lsd   = 0;
                case 1
                    lsd   = 1*d;
                case 2
                    lsd   = 2*d;
                case 3
                    lsd   = 3*d;
                otherwise
                   error('Unknown distance.')
                    
            end
            switch lower(type_nf)
                case 'spherical'
                    DC(p,q,:) = sinc(ww*lsd/(c*pi));
                    
                case 'cylindrical'
                    DC(p,q,:) = bessel(0,ww*lsd*d/c);
                    
                otherwise
                    error('Unknown noise field.')
            end
        end
    end
end

%% Generate sensor signals with desired spatial coherence
x = mix_signals(babble,DC,'cholesky');

%% Compare desired and generated coherence
K_eval = 256;
ww = 2*pi*Fs*(0:K_eval/2)/K_eval;
sc_theory = zeros(M-1,K_eval/2+1);
sc_generated = zeros(M-1,K_eval/2+1);
% Calculate desired and generated coherence
for m = 1:M-1
    switch m
       case 1
           lsd   = 1*d;
       case 2
           lsd   = 2*d;
       case 3
           lsd   = 3*d;
       otherwise
            error('Unknown distance.')              
    end
    switch lower(type_nf)
        case 'spherical'
            sc_theory(m,:) = sinc(ww*lsd/(c*pi));
            
        case 'cylindrical'
            sc_theory(m,:) = bessel(0,ww*lsd/c);
    end
    
    [sc_tmp, Freqs]=cohere_mod(x(:,1),x(:,m+1),K_eval,Fs,hanning(K_eval),0.75*K_eval);
    sc_generated(m,:) = real(sc_tmp.');
end

% Calculate mean square error
MSE = zeros(M,1);
for m = 1:M-1
    MSE(m) = 10*log10(sum(((sc_theory(m,:))-(sc_generated(m,:))).^2)./sum((sc_theory(m,:)).^2));
end

% Plot spatial coherence of two sensor pairs
figure(1);
MM=min(2,M-1);
for m = 1:MM
    subplot(MM,1,m);
    plot(Freqs/1000,sc_theory(m,:),'-k','LineWidth',1.5)
    hold on;
    plot(Freqs/1000,sc_generated(m,:),'-.b','LineWidth',1.5)
    hold off;
    xlabel('Frequency [kHz]');
    ylabel('Spatial Coherence');
    title(sprintf('Inter sensor distance %1.2f m',m*d));
    legend('Theory',sprintf('Proposed Method (MSE = %2.1f dB)',MSE(m)));
    grid on; 
end

% Save Babble Speech
audiowrite('mc_babble_speech_example.wav',x/4,Fs);