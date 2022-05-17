%==========================LZ4 Decoder v2=======================================

%Read file into an array
fid = fopen("Poem.lz4", 'r');
data = fread(fid, 'uint8');
fclose(fid);

%Checking the file is a valid LZ4 file
if(data(1:4)==[4 34 77 24]')
  fprintf("LZ4 File Detected\n\n")
end

%Checking Frame Descriptor
fprintf("FLG byte:\n")
bit_pos = 1;
bit_str = dec2bin(data(5));
content_flag = 0;

%FLG byte
%Version
if(bit_str(bit_pos)=="1")
  fprintf("Valid Version...\n")
end

bit_pos++;

%Independence
if(bit_str(bit_pos)=="1")
  fprintf("Independent Blocks...\n")
else
  fprintf("Dependent Blocks...\n")
end

bit_pos += 1;

%Block Checksum
if(bit_str(bit_pos)=="1")
  fprintf("Block Checksum Present...\n")
else
  fprintf("Block Checksum not Present...\n")
end

bit_pos++;

%Content Size
if(bit_str(bit_pos)=="1")
  fprintf("Content Size flag present...\n")
  content_flag = 1;
else
  fprintf("Content Size flag not present...\n")
end

bit_pos++;;

%Content Checksum
if(bit_str(bit_pos)=="1")
  fprintf("Content Checksum appended after EndMark...\n")
else
  fprintf("No Content Checksum...\n")
end

bit_pos++;

%Reserved Bits
if((bit_str(bit_pos)=="0")&&(bit_str(bit_pos+1)=="0"))
  fprintf("Reserved Bits validated...\n\n")
else
  fprintf("Reserved Bits Incorrect!...\n\n")
end

%BD byte
fprintf("BD byte:\n")
bit_pos = 1;
bit_str = dec2bin(data(6));

%MaxSize
switch(substr(bit_str, 1, 3))
  case "111"
    fprintf("Max Block Size = 4MB...\n")
  case "110"
    fprintf("Max Block Size = 1MB...\n")
  case "101"
    fprintf("Max Block Size = 256KB...\n")
  case "100"
    fprintf("Max Block Size = 64KB...\n")
  otherwise
    fprintf("Max Block Size invalid...\n") 
endswitch

bit_pos = 4;

%Reserved Bits
if((bit_str(bit_pos)=="0")&&(bit_str(bit_pos+1)=="0")&&(bit_str(bit_pos+2)=="0")&&(bit_str(bit_pos+3)=="0"))
  fprintf("Reserved Bits validated...\n\n")
else
  fprintf("Reserved Bits Incorrect!...\n\n")
end


%Skipping to 12th byte (unsure of data in the middle)

%Data blocks
pos = 12;
hi_token = bin2dec(substr(dec2bin(data(12)), 1, 4))
lo_token = bin2dec(substr(dec2bin(data(12)), -4))

pos++;
decoded_arr = cell();
decoded_arr = char(data(pos:pos+hi_token-1))

pos = pos+hi_token;
offset = 0;
