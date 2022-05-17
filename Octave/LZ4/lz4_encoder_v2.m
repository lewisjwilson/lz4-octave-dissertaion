data = "abbccaabbccabbca";

pos = 1;
increment = 0;
literals = "";
offsets = [];
tokens = cell();

offsets(end+1, 1) = data(pos);
pos++;

%finding the literal matches
while pos<=length(data)
  
  symbol = data(pos);
  offsets(end+1 ,1) = symbol;
  count = 2;
  
  %for each previous character in the data string...
  for i = pos-1:-1:1
    
    %until a break occurs...
    while 1==1
      
      %if the incemented position does not exceed the length of the data string
      if (pos+increment)<=length(data)
       
        %if there is a symbol match
        if data(i+increment)==data(pos+increment)
          
          %append the symbol to the literals string
          literals = strcat(literals, data(i+increment));
          increment++;
          
        else
          %display literal build-up and add offsets where lit_len>4
          if length(literals)>=4
            literals
            offsets(end, count) = i-pos;
            %append desired information to tokens array
            
            %match length
            lo_token = length(literals);
            
            tokens(end+1, 1:3) = {pos, literals, offsets(end, count)};
            count++;            
          end
         
          %reset the literals string
          literals = "";
          increment=0;
          %break from while loop when matches stop occuring
          break;
        end
      else
        %break while loop if incremented position exceeds data string length
        break;
      end
    end
  end
  pos++;

end

offsets
tokens