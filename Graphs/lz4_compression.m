% Bar Plot

data_128 = csvread('[lz4_results_128].txt');
data_128 = data_128(:,3)';

data_256 = csvread('[lz4_results_256].txt');
data_256 = data_256(:,3)';

data_512 = csvread('[lz4_results_512].txt');
data_512 = data_512(:,3)';

data_1024 = csvread('[lz4_results_1024].txt');
data_1024 = data_1024(:,3)';

data_2048 = csvread('[lz4_results_2048].txt');
data_2048 = data_2048(:,3)';

data_4096 = csvread('[lz4_results_4096].txt');
data_4096 = data_4096(3:end,4)';

data_huff = csvread('[huffman_results_8bit_len]_bits.txt');
data_huff = data_huff(3:end,4)';

file_names = {'cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};

x = [data_128; data_256; data_512; data_1024; data_2048; data_4096; data_huff]';

plot = bar(x, 1);
set (plot(1), 'facecolor', 'k');
set (plot(2), 'facecolor', [0 0 .8]);
set (plot(3), 'facecolor', [.2 .15 1]);
set (plot(4), 'facecolor', [.3 .3 1]);
set (plot(5), 'facecolor', [.4 .45 1]);
set (plot(6), 'facecolor', [.6 .6 1]);
set (plot(7), 'facecolor', 'm');
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);