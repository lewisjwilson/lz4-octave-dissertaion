clear;clc;

fprintf("Huffman Encoder Results [min_fixed_length]\n")

filenames = {'a0020.txt','a0270.txt','cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};
filename = '';
for i=1:length(filenames)
  fprintf("\n\n")
  filename = filenames{i}
  huffman_encoder_final(filenames{i}, 1)
end
