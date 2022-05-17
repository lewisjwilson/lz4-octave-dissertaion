% Bar Plot

data_huff = csvread('[huffman_decoder_times].txt');
data_huff = data_huff(3:end);
data_lz4 = csvread('[lz4_decoder_times].txt');
data_lz4 = data_lz4(3:end);

file_names = {'cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};

x = [data_huff; data_lz4]';

plot = bar(x, 1);
set (plot(1), 'facecolor', 'b');
set (plot(2), 'facecolor', 'k');
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);