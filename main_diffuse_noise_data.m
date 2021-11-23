% M = 7  % for Kinect Azure
% mic_pos = [0.00, 0.00;0.00, 0.04;0.03464101, 0.02;0.03464101, -0.02;0.00, -0.04;-0.03464101, -0.02;-0.03464101, 0.02]

M = 2  % for two mics
mic_pos = [0.03464101, 0.02;-0.03464101, 0.02]
gen_L = -1

noise_list = './noise/noise.lst'
out_path = './output'
num_utts = 4

gen_diffuse_noise(noise_list, out_path, num_utts, M, mic_pos, gen_L);