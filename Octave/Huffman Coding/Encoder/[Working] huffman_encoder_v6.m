%=========================Huffman Encoder v6====================================
clear;clc;

input = "Lewis Wilson";
freq_vector = cell();

%length of unique(input) string
unique_L = length(unique(input));

%calculate size before encoding, using ceiling of log2(number of unique values)
fixed_bits_per_symbol = ceil(log2(unique_L));
size_before_encoding = length(input)*fixed_bits_per_symbol;

%Fill cell array with symbols and frequencies
for i=1:unique_L
  freq_vector(i, 1) = unique(input)(i);
  freq_vector(i, 2) = length(strfind(input, unique(input)(i)));
end


%create cell arrays for grouping order, symbols and blobs
group_order = cell();
symbols = cell();
blobs = cell();

[rows, cols] = size(freq_vector);

while rows>1 
  prob_vector=cell2mat(freq_vector(:,2)); %create a new vector from the probabilities (col 2)
  [~,index] = sort(prob_vector); %sort the vector in ascending order
  freq_vector = freq_vector(index, :); %rearrange cell array by sorted indexes
  
  %add to grouping order vector
  group_order(end+1,1) = freq_vector{1,1};
  group_order(end,2) = freq_vector{2,1};
    
  %if the first frequency vector value is a symbol (rather than a blob)
  %then add it to the symbol vector, otherwise add it to the blob vector
  if length(freq_vector{1,1})==1
    symbols(end+1,1) = freq_vector{1,1};
    symbols(end,2) = "0";
    symbols(end,3) = freq_vector{1,2};
  else
    blobs(end+1,1) = freq_vector{1,1};
    blobs(end,2) = "0";
  end
  
  %if the 2nd frequency vector value is a symbol (rather than a blob)
  %then add it to the symbol vector, otherwise add it to the blob vector
  if length(freq_vector{2,1})==1
    symbols(end+1,1) = freq_vector{2,1};
    symbols(end,2) = "1";
    symbols(end,3) = freq_vector{2,2};
  else
    blobs(end+1,1) = freq_vector{2,1};
    blobs(end,2) = "1";
  end
 
  
  %concatenate strings and sum frequencies  
  freq_vector(rows+1, 1) = cstrcat(freq_vector{1,1}, freq_vector{2,1});
  freq_vector(rows+1, 2) = freq_vector{1,2} + freq_vector{2,2};
  
  %delete 1st and 2nd rows
  freq_vector(1:2,:) = [];
  
  [rows, cols] = size(freq_vector);
  
end


%calculate the blob and symbol vector row counts
[blob_rows, blob_cols] = size(blobs);
[symbols_rows, symbols_cols] = size(symbols);


%while the blobs vector exists
while blob_rows>0
  
  %check if current blob has a blob substring
  for i = 2:blob_rows
    subnode_check = length(strfind(blobs{end,1}, blobs{end-i+1,1}));
    
    if subnode_check>0
      blobs(end-i+1, 2) = strcat(blobs{end, 2}, blobs{end-i+1 ,2});
      blobs(end,1) = strrep(blobs(end,1), blobs(end-i+1,1), "");
    end
  end
  
  %check if current blob has a symbol substring
  for i = 1:symbols_rows
    subnode_check = length(strfind(blobs{end,1}, symbols{end-i+1,1}));

    if subnode_check>0
      symbols(end-i+1,2) = strcat(blobs{end, 2}, symbols{end-i+1,2});
      blobs(end,1) = strrep(blobs(end,1), symbols(end-i+1,1), "");
    end  
  end
  
  %if the final blob value is null, remove the row
  if isequal(blobs{end,1},"")
    blobs(end,:) = [];
    [blob_rows, blob_cols] = size(blobs);
  end
  
end

[srows, ~] = size(symbols);
size_after_encoding = 0; %initiaise

%iterate through symbols cell array, multiplyinng length of bits with freq
for i = 1:srows
  size_after_encoding = size_after_encoding + (cellfun('length', symbols(i,2))*cell2mat(symbols(i,3)));
end

%outputs
compression = (size_after_encoding/size_before_encoding)*100;
fprintf('Size before encoding: %d bits \n', size_before_encoding)
fprintf('Size after encoding: %d bits \n', size_after_encoding)
fprintf('Compression: %.2f%% \n', compression)


%add a new column to the symbols vector with decimal representation of the binary values
for i = 1:srows
  symbols(i,4)=bin2dec(symbols(i,2));
end

prob_vector=cell2mat(symbols(:,4)); %create a new vector from the probabilities (col 4)
[~,index] = sort(prob_vector); %sort the vector in ascending order
symbols = symbols(index, :); %rearrange cell array by sorted indexes

%convert symbols to ascii to avoid issues in output with space etc.
for i = 1:srows
  symbols(i,1) = double(char(symbols(i,1)));
end


%output encoding dictionary as new file
fid = fopen('dictionary.txt', 'w');
for i=1:srows  
  fprintf(fid, '%d,%s\r\n', symbols{i,1}, char(symbols(i,2)))
end

fclose(fid);

%output encoded data as new file
fid2 = fopen('encoded_data.txt', 'w');
for i = 1:length(input)
  input_symbol = input(i);
  %row index of symbol in symbols cellarray
  index = find(ismember(char(symbols{:,1}),input_symbol));
  fprintf(fid2, '%s',char(symbols(index,2)))
end
fclose(fid2);
