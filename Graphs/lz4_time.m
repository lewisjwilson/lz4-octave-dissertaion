% Bar Plot

data_128 = csvread('[lz4_results_128].txt');
data_128 = data_128(:,3)';

data_256 = csvread('[lz4_results_256].txt');
data_256 = data_256(:,3)';

data_512 = csvread('[lz4_results_512].txt');
data_512 = data_512(:,3)';

data_1024 = csvread('[lz4_results_1024].txt');
data_1024 = data_1024(:,3)';

data_huff = csvread('[huffman_results_8bit_len]_bits.txt');
data_huff = data_huff(:,3)';

file_names = {'a0020.txt','a0270.txt','cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};

x = [data_128; data_256; data_512; data_1024; data_huff]';

plot = bar(x, 1);
set (plot(1), 'facecolor', 'k');
set (plot(2), 'facecolor', [0 0 .8]);
set (plot(3), 'facecolor', [.6 .68 1]);
set (plot(4), 'facecolor', [.8 .8 1]);
set (plot(5), 'facecolor', 'm');
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);