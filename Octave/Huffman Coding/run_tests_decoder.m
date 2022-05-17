clear;clc;

fprintf("Huffman Decoder Results\n")

filenames = {'a0020.txt','a0270.txt','cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};
filename = '';
for i=1:length(filenames)
  fprintf("\n\n")
  filename = filenames{i}
  huffman_decoder_final(filenames{i})
end
