% Bar Plot

data_huff = csvread('[huffman_decoder_times].txt');
data_lz4 = csvread('[lz4_decoder_times].txt');

ave_huff = median(data_huff)
ave_lz4 = median(data_lz4)

file_names = {'huffman','lz4'};

x = [ave_huff; ave_lz4]';

plot = bar(x, 0.7);
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);