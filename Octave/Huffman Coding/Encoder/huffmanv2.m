%Huffman Coding Algorithm

input = 'test_data'; %Specify input data
L = length(input); %Length of data

table_store = cell(); %define cell array to store information...

for i = 1:L
  table_store{i, 1} = input(i); %add new row for each char value in "input"
end

table_store = unique(table_store); %store values that are unique

%the problem here is that we create a new row for every character and then condense
%later on. Waste of resources/time? But works.....

[rows, cols] = size(table_store); %find number of rows for next for loop

for i = 1:rows
  table_store(i, 2) = length(strfind(input, table_store{i,1})); % add in the count of each symbol
  table_store(i, 3) = table_store{i,2}/L; % add in the probability of each symbol
end

table_store_iter = cell(); % Cell array to store all processed symbols

while rows>=1 %while the number of rows in the matrix is >=1
  table_store_iter
  prob_vector=cell2mat(table_store(:,3)); %create a new vector from the probabilities (col 3)
  [~,index] = sort(prob_vector); %sort the vector in ascending order
  table_store = table_store(index, :) %rearrange cell array by sorted indexes

  pause %used for debugging...

  [irows, icols] = size(table_store_iter); %find number of rows in iteration cell array
  if rows~=1 %if the number of rows isn't 1
    for i = 1:3 % for columns 1-3
       table_store_iter(irows+1,i)=table_store{1,i}; %copy the 1st row contents
       table_store_iter(irows+2,i)=table_store{2,i}; %copy the 2nd row contents
    end

    table_store(1, 1) = strcat(table_store{1,1}, table_store{2,1}); %concatenate first two symbols
    table_store(1, 2) = table_store{1,2}; % sum occurences
    table_store(1, 3) = table_store{1,3}+table_store{2,3}; %sum probabilities
    table_store(2,:) = []; %delete 2nd row
    
  else %otherwise
    for i = 1:3 %for cols 1-3
      table_store_iter(irows+1,i)=table_store{1,i}; % store the first row
    end
    prob_vector=cell2mat(table_store_iter(:,3)); %create a new vector from the probabilities (col 3)
    [~,index] = sort(prob_vector, 'descend'); %sort the vector in descending order
    table_store_iter = table_store_iter(index, :); %rearrange cell array by sorted indexes
    break %exit loop
  end
  [rows, cols] = size(table_store); %find number of rows for next for loop
end