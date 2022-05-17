%============================Huffman Encoder====================================

%-------------------------Parameters to define----------------------------------

% fname = name of file + extension;
% min_fixed_len = 1 for min fixed-length codes, 0 for 8 bit fixed length codes;

%-------------------------------------------------------------------------------

function huffman_encoder_final(fname, min_fixed_len)

fid = fopen(fname, 'r');
input_data = fread(fid);
fclose(fid);

input_L = length(input_data);

%Generate unique data matrix and populate with sum of each unique value
unique_data = unique(input_data);
%length of unique(input) string
unique_L = length(unique_data);

%for 8-bit fixed length
fixed_bits_per_symbol = 8;
end_text = '8-bit';

if min_fixed_len == 1
  end_text = 'Min';
  %for min fixed-length
  fixed_bits_per_symbol = ceil(log2(unique_L));
  if fixed_bits_per_symbol == 0
    fixed_bits_per_symbol = 1;
  end
end

tic

for i=1:unique_L
  unique_data(i, 2) = sum(input_data==unique_data(i,1));
end

symbols=unique_data(:,1);
unique_data(:,1)=1:length(symbols);

%create a sorted matrix to sort based on frequency column
[~,idx] = sort(unique_data(:,2));
unique_data_sorted = unique_data(idx, :);

%create store of unique_data_sorted for reference
unique_data_ref = unique_data_sorted;
[rows, ~] = size(unique_data_sorted);

%initialise a new tree structure matrix and reference counter
tree_struct = [];
ref_counter = 1;

%for each row in the sorted matrix, add to ref matrix 
for i = 1:rows-1
  %unique_data_sorted
  
  tree_struct(i,1) = unique_data_sorted(1,1);
  unique_data_sorted(1,1) = -ref_counter;
  
  if rows~=i
    tree_struct(i,2) = unique_data_sorted(2,1);
    unique_data_sorted(1,2) = unique_data_sorted(1,2)+unique_data_sorted(2,2);
    unique_data_sorted(2,:) = [];
    ref_counter += 1;
  end
  
  [~,idx] = sort(unique_data_sorted(:,2));
  unique_data_sorted = unique_data_sorted(idx, :);
  
end

%ref counter acts as number of rows in tree_struct
codes=cell(1,rows);
prefixes=cell(1,rows-1);

%For data containing only 1 symbol
if rows==1
  codes(1, 1)='0';
end

for i=rows-1:-1:1
  if tree_struct(i,1)>0
    codes{tree_struct(i,1)} = strcat( prefixes{i} , '1');
  else
    prefixes{-tree_struct(i,1)} = strcat( prefixes{i}, prefixes{-tree_struct(i,1)} , '1');
  end
  if tree_struct(i,2)>0
    codes{tree_struct(i,2)} = strcat( prefixes{i} , '0');
  else
    prefixes{-tree_struct(i,2)} = strcat( prefixes{i}, prefixes{-tree_struct(i,2)} , '0');
  end
end

%output encoded data as new (text) file
fid = fopen(strcat(fname,'_encoded.txt'), 'w');
for i = 1:length(input_data)
  input_symbol = input_data(i);
  [~,index] = ismember(input_symbol, symbols, 'rows');
  fprintf(fid, '%s', codes{index});
end
fclose(fid);

%output encoded data as a new (binary) file
fid = fopen(strcat(fname,'_encoded.bin'), 'w');
v = 0; lenv = 0; str = "";
for i = 1:length(input_data)
  % add the next code to the current temp string
  input_symbol = input_data(i);
  [~,index] = ismember(input_symbol, symbols, 'rows');
  str = codes{index};
  % and save it in binary
  for b = 1:length(str)
    v=2*v;
    if str(b)=='1'
      v = v+1;
    end
    lenv = lenv+1;
    if lenv==8
      fwrite(fid,v,'uint8');
      v=0; lenv=0;
    end
  end
end
if lenv>0
  for i=lenv+1:8
    v=2*v;
  end
  fwrite(fid,v,'uint8');
end
fclose(fid);

[srows,~] = size(symbols);
%output encoding dictionary as new file 
fid = fopen(strcat(fname, '_dictionary.txt'), 'w');
for i=1:srows  
  fprintf(fid, '%d,%s\r\n', symbols(i), cell2mat(codes(i)));
end
fclose(fid);

toc

%size of source file in bits
fsize_before = (fixed_bits_per_symbol*input_L);
fsize_after = 0;

%evaluates the encoded data size (in bits)
for i=1:length(codes)
  % output size = output size + (bit string lengths * number of appearances)
  fsize_after = fsize_after + (unique_data(i,2)*numel(codes{1,i}));
end

fileinfo_dic = stat(strcat(fname,'_dictionary.txt'));
fsize_dic = (fileinfo_dic.size)*8;

%outputs
compression = ((fsize_after+fsize_dic)/fsize_before)*100;
fprintf(strcat(end_text, ' Fixed-Length File Size: %d bits \n'), fsize_before)
fprintf('Encoded Size: %d bits \n', (fsize_after+fsize_dic))
fprintf('Compression: %.2f%% \n', compression)

endfunction