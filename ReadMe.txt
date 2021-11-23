Step-1: 利用单通道纯净噪声借助仿真工具准备相应通道的散射噪声
	单通道纯净噪声：日常背景噪声、风噪、路边噪声、办公室噪声、商场噪声
	进入gen_diffuse_noise/Nonstationary_diffuse_noise 执行gen_diffuse_noise.m
	mic_pos = [0.0000, 0.000000; 0.0350, 0.000000; 0.0700, 0.000000; 0.1050, 0.000000; 0.1400, 0.000000; 0.1750, 0.000000]
	
	gen_diffuse_noise(noise_list, out_path, num_utts, M, mic_pos, gen_L);
	noise_list：单通道纯净噪声的文件列表
	out_path：输出目录
	num_utts：指定生成的散射噪声个数
	M：麦克风个数
	mic_pos：麦克风坐标位置
	gen_L：生成的句子长度，如果给-1，生成的句子长度和单通道纯净噪声的长度一致
	
按照kinect结构生成一批散射数据。
    数据集：wind noise、pink noise、NLPRNoise
    单通道纯净噪声：风噪、粉红噪声、空调声、飞机舱内环境声、机场环境、轻声言语、键盘敲击声等
	进入gen_diffuse_noise/Nonstationary_diffuse_noise 执行gen_diffuse_noise.m
    noise_list = '/home/hyz/Documents/my_script/ssh2server/server127/ssd2/dataset/Noise/NLPRNoise/scp/train.scp4local'
    out_path = './NLPRNoise_train_diffuse'  % './diffuse_dev', './diffuse_test'
    num_utts = 74861
    % num_utts = 6745
    M = 7
	mic_pos = [0.00, 0.00;0.00, 0.04;0.03464101, 0.02;0.03464101, -0.02;0.00, -0.04;-0.03464101, -0.02;-0.03464101, 0.02]
    gen_L = -1
	
	gen_diffuse_noise(noise_list, out_path, num_utts, M, mic_pos, gen_L);
	noise_list：单通道纯净噪声的文件列表
	out_path：输出目录
	num_utts：指定生成的散射噪声个数
	M：麦克风个数
	mic_pos：麦克风坐标位置
	gen_L：生成的句子长度，如果给-1，生成的句子长度和单通道纯净噪声的长度一致

