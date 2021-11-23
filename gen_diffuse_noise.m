function gen_diffuse_noise(noise_list, out_path, num_utts, M, mic_pos, gen_L)
    
    if exist(out_path,'dir') == 0
        mkdir(out_path);
    end
    
    noise_lst = importdata(noise_list);
    num_noise = length(noise_lst);
    
    % Initialization
    Fs = 16000;                % Sample frequency (Hz)
    c  = 343;                  % Sound velocity (m/s)
    K  = 256;                  % FFT length
    type_nf = 'spherical';     % Type of noise field: % 'spherical' or 'cylindrical'
    
    % Generate matrix with desired spatial coherence
    % theta_c = 2*pi/M;
    ww = 2*pi*Fs*(0:K/2)/K;
    DC = zeros(M,M,K/2+1);
    for p = 1:M
        for q = 1:M
            if p == q
                DC(p,q,:) = ones(1,1,K/2+1);
            else
                % lsd = 2*d*abs(sin(abs(p-q)*theta_c/2));
                lsd = norm(mic_pos(p, :) - mic_pos(q, :));
                switch lower(type_nf)
                    case 'spherical'
                        DC(p,q,:) = sinc(ww*lsd/(c*pi));
                    % case 'cylindrical'
                    %    DC(p,q,:) = bessel(0,ww*lsd*d/c);
                    otherwise
                        error('Unknown noise field.')
                end
            end
        end
    end
    n = 0;                         
    %while true
    for noi_id=1:num_noise
        % noi_id = randi([1, num_noise]);
        [data,Fs_data] = audioread(noise_lst{noi_id});
        noi_name       = getFileName(noise_lst{noi_id});
        
        if Fs ~= Fs_data
            data = resample(data, Fs, Fs_data);
            % error('Sample frequency of input file is incorrect.');
        end
        data = data - mean(data);
        num_sample = size(data, 1);
        L = floor(num_sample / M);
        babble = zeros(L,M);
        for m=1:M
            babble(:,m) = data((m-1)*L+1:m*L);
        end

        diff_noi = mix_signals(babble, DC, 'eigen');  %% cholesky Generate sensor signals with desired spatial coherence
        diff_noi = diff_noi / M;
        
        if gen_L > 0
            nsample       = size(diff_noi, 1);
            segment_start = 1;
            segment_end   = segment_start + gen_L;
            while segment_end < nsample
                n = n + 1;
                segment_diff_noi = diff_noi(segment_start:segment_end, :);
                diff_file = [out_path, filesep, 'diffuse_', num2str(M), 'Mic_', noi_name, '_', num2str(n), '.wav'];
                audiowrite(diff_file, segment_diff_noi, Fs);
                disp([num2str(n), '/', num2str(num_utts), ' ', diff_file]);
                
                segment_start = segment_start + gen_L;
                segment_end   = segment_start + gen_L;
            end
            
            segment_end   = nsample;
            segment_start = max(nsample - gen_L, 1);
            n = n + 1;
            segment_diff_noi = diff_noi(segment_start:segment_end, :);
            diff_file = [out_path, filesep, 'diffuse_', num2str(M), 'Mic_', noi_name, '_', num2str(n), '.wav'];
            audiowrite(diff_file, segment_diff_noi, Fs);
            disp([num2str(n), '/', num2str(num_utts), ' ', diff_file]);
        else
            n = n + 1;
            % diff_file = [out_path, filesep, 'diffuse_', num2str(M), 'Mic_', noi_name, '_', num2str(n), '.wav'];
            diff_file = [out_path, filesep, 'diffuse_', num2str(M), 'Mic_', noi_name,'.wav'];
            audiowrite(diff_file, diff_noi, Fs);
            disp([num2str(n), '/', num2str(num_utts), ' ', diff_file]);
        end
        if n > num_utts
            break;
        end
    end    
end

