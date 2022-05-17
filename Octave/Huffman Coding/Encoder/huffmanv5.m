%Huffman Coding  - Encoder v5

clear;clc;

input = "aaabb bbbcdd";

freq_vector = cell();

%length of unique(input) string
unique_L = length(unique(input));

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
  else
    blobs(end+1,1) = freq_vector{1,1};
    blobs(end,2) = "0";
  end
  
  %if the 2nd frequency vector value is a symbol (rather than a blob)
  %then add it to the symbol vector, otherwise add it to the blob vector
  if length(freq_vector{2,1})==1
    symbols(end+1,1) = freq_vector{2,1};
    symbols(end,2) = "1";
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

%output symbols vector
symbols
