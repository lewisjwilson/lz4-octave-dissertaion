%Huffman Coding v4

clear;clc;


input = "aacccdddd";

freq_vector = cell();

%length of unique(input) string
unique_L = length(unique(input));

%Fill cell array with symbols and frequencies
for i=1:unique_L
  freq_vector(i, 1) = unique(input)(i);
  freq_vector(i, 2) = length(strfind(input, unique(input)(i)));
end

group_order = cell();
prefixes = cell();

[rows, cols] = size(freq_vector);

while rows>1 
  prob_vector=cell2mat(freq_vector(:,2)); %create a new vector from the probabilities (col 2)
  [~,index] = sort(prob_vector); %sort the vector in ascending order
  freq_vector = freq_vector(index, :); %rearrange cell array by sorted indexes
  
  %add to grouping order vector
  group_order(end+1,1) = freq_vector{1,1};
  group_order(end,2) = freq_vector{2,1};
  
  prefixes(end+1,1) = freq_vector{1,1};
  prefixes(end,2) = "0";
  prefixes(end+1,1) = freq_vector{2,1};
  prefixes(end,2) = "1";
  
  
  %concatenate strings and sum frequencies  
  freq_vector(rows+1, 1) = strcat(freq_vector{1,1}, freq_vector{2,1});
  freq_vector(rows+1, 2) = freq_vector{1,2} + freq_vector{2,2};
  
  %delete 1st and 2nd rows
  freq_vector(1:2,:) = [];
  
  [rows, cols] = size(freq_vector);
  
end

prefixes_dup = prefixes(:,:);
node = prefixes_dup{end,1};

%recursive function
function recurse(node, prefixes)
  %set rows to be number of rows in duplicate prefixes vector
  [rows, cols] = size(prefixes);

  %for each row
  for i = 1:rows
    
    %check if number of rows-i is a substring of node
    if rows-i~=0
      subnode_check = length(strfind(node, prefixes{rows-i,1}));
    else
      subnode_check = 0;
    end
    
    %check if the current node is a blob
    blob_check = length(node);
    prefixes
    
    if blob_check>1
      %if the checked string is a substring...
      if subnode_check>0
        
        %set new prefix of rows-i to be the prefix of a higher-class node + prefix of current node
        prefixes(rows-i,2) = strcat(prefixes(end,2),prefixes(rows-i,2));
        
        %set new node string to be the same as before, minus found substring
        prefixes(end,1) = strrep(prefixes(end,1), prefixes(rows-i,1), "");
        

        %if the final row (column 1) is empty
        if isequal(prefixes{end,1},"")
          %delete the final row
          prefixes(end,:) = [];
          
          %set new node as new final row string
          node = prefixes{end,1};
          %recurse
          recurse(node, prefixes)
          
          %break from loop (found all substrings of initial node)
          break
        end
      end
    end
  end

end

recurse(node, prefixes)