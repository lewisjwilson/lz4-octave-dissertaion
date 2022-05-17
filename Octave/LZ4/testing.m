data = "aabbccaabbcabbca"

pos = 2
increment = 0;
literals = "";

%finding the literal matches
while pos<=length(data)
  
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
          %display literal build-up
          if length(literals)>=4
            literals
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