%Huffman Coding Algorithm

input = 'test_data'; %Specify input data
L = length(input); %Length of data

symbols = struct(); %Initialise an empty structure (to act as a dictionary)

for i = 1:L %Traverse through the input string
  if(isfield(symbols, input(i))==1) %if the key already exists;
    symbols.(input(i))=symbols.(input(i))+1 %make the key equal to the stored value + 1
  else
    symbols.(input(i))=1 % otherwise create a key and give it the value 1
  end
end

num_keys = length(fieldnames(symbols)) % Number of struct keys
symbols_prob = struct(); % set new struct for probabilities

%populate symbols_prob with keys from symbols struct (BAD O(n)=n^2!)
for i = 1:num_keys
  for fn = fieldnames(symbols)
    symbols_prob.(fn{i}) = symbols.(fn{i}) %duplicate struct
    symbols_prob.(fn{i}) = symbols_prob.(fn{i})/L; %set key values as probabilities
  end
end

