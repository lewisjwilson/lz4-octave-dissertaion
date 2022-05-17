clear;clc;

fprintf("LZ4 Encoder Results\n")

#filenames = {'a0020.txt','a0270.txt','cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};
filenames = {'grammar.lsp'};
filename = '';
search_buffer = 256;

for i=1:length(filenames)
  fprintf("\n\n")
  filename = filenames{i}
  lz4_encoder_final(filenames{i}, search_buffer)
end
