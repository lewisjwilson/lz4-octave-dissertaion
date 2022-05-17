%Huffman Coding Algorithm v3

input = "aaabbbcccddd";

iter_vector = cell();

%length of unique(input) string
unique_L = length(unique(input));

%Fill cell array with symbols and frequencies
for i=1:unique_L
  iter_vector(i, 1) = unique(input)(i);
  iter_vector(i, 2) = length(strfind(input, unique(input)(i)));
end

%store all symbols in a symbol vector
symbol_vector = iter_vector(:,1);

[rows, cols] = size(iter_vector);

%Create root node - such as (a(t(cd)))
while rows>1 
  prob_vector=cell2mat(iter_vector(:,2)); %create a new vector from the probabilities (col 2)
  [~,index] = sort(prob_vector); %sort the vector in ascending order
  iter_vector = iter_vector(index, :); %rearrange cell array by sorted indexes
  
  symbol_vector(end+1, 1) = strcat(iter_vector{1,1}, iter_vector{2,1});
  
  %concatenate strings and sum frequencies  
  iter_vector(rows+1, 1) = strcat("(", iter_vector{1,1}, iter_vector{2,1}, ")");
  iter_vector(rows+1, 2) = iter_vector{1,2} + iter_vector{2,2};
  
  %delete 1st and 2nd rows
  iter_vector(1:2,:) = [];
  
  [rows, cols] = size(iter_vector);
end


%output bracketed string
bracketed_string = iter_vector(1,1){1};
bracketL = length(bracketed_string);

symbol = symbol_vector{1,1};




%recursive function
function Huffman(bracketed_string, symbol)
  
  %a(bc) case
  if bracketed_string(1)~="("
    "Focus on Left"
    lbracket_pos = strfind(bracketed_string, "(")(1)
    Lblob = bracketed_string(1:lbracket_pos-1)
  
  elseif (bracketed_string(1)=="(")&&(bracketed_string(end)==")")
    "Focus on Left"
    lbracket_pos = strfind(bracketed_string, "(")(1)
    Lblob = bracketed_string(1:lbracket_pos-1)
  
  %(ec)(b(da)) case
  elseif (bracketed_string(2)~="(")&&(bracketed_string(end-1)==")")
    "Focus on Left"
    lbracket_pos = strfind(bracketed_string, "(")(1)
    rbracket_pos = strfind(bracketed_string, ")")(1)
    Lblob = bracketed_string(lbracket_pos+1:rbracket_pos-1)
  
  %((ec)b)(da) case
  elseif (bracketed_string(2)=="(")&&(bracketed_string(end-1)~=")")
    "Focus on Right"
    
  %(ab)c case
  elseif bracketed_string(end)~=")"
    "Focus on Right"
    rbracket_pos = strfind(bracketed_string, ")")(end)
    Rblob = bracketed_string(rbracket_pos+1:end)
     
  end
  
  
  bracketL = length(bracketed_string);
  
end

bracketed_string = bracketed_string(2:end-1);
Huffman(bracketed_string, symbol)