clc;clear;

data = "aabbccaabbcabbca"
pos = 1;
data_len = length(data);
matches = [];
match_len = 0;

while pos<=data_len
  
  symbol = data(pos);
  matches(end+1 ,1) = symbol;
  
  %populate matches array
  count = 2;
  if pos>1
    for i = pos-1:-1:1
      if (symbol == data(i))
        matches(end, count) = i-pos;
        count++;
      end
    end
  end
 
  pos++;
end

matches