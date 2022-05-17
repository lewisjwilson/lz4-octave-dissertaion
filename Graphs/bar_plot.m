% Bar Plot

huff_data = csvread('huffman_results.txt');
lz4_data = csvread('lz4_results_1024.txt');
file_names = {'a0020.txt','a0270.txt','cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};

x = [huff_data; lz4_data]';

plot = bar(x, 0.9);
set (plot(1), "facecolor", 'b');
set (plot(2), "facecolor", 'k');
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);

