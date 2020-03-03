my $line;

my $path1 = '+<C:\Scripts_pipe_one_core\test_on_netfpga.txt';
my $path2 = '+>C:\Scripts_pipe_one_core\addr_resol_intermediate_1.txt';
my $path3 = '+>C:\Scripts_pipe_one_core\addr_resol_intermediate_2.txt';
my $path4 = '+>C:\Scripts_pipe_one_core\addr_resol_final.txt';

#print "\nGive the absolute path of asm file\n";
#my $path_1 = <STDIN>;


#print "\nGive the absolute path of file to dump the binaries\n";
#my $path_2_in = <STDIN>;

#my $path_2 = "+>".$path_2_in;


my $final_value;

open (file_1, $path1);
open (file_2, $path2);
open (file_3, $path3);
open (file_4, $path4);

my $binaries;
my $opcode;
my $opcode_returned;
my $imm;
my $imm_returned;

my @instn;

my $rs_returned;
my $rt_returned;
my $rd_returned;

my $rs;
my $rt;
my $rd;

my $count = 0;
my %symtable;
my @writeline;

while($line = readline(file_1))			#first pass to put nop after every lw  
{
	
	@writeline = $line;
	
	if ($line =~ m|(lw)|)		#LW rt,rs(imme)
	{					#lw $rt,imme($rs)
		
		#print ("found $1\n");
		if($line =~ m|(lw)\s(\$\w{1,2}),(\d{0,})\((\$\w{1,2})\)|) 			#m|(lw)\s(\$\w{1,2}),(\d{0,})\((\$\w{1,2})\)|
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			#@writeline = (@writeline,"\n");
			@writeline = (@writeline,"\tnop\n"); #@writeline will already having \n
			#@writeline = (@writeline,"\n");
				
		}
	}
	
	
	
	print file_2 @writeline;         #write the instn to file_2
        undef @writeline;
}

seek(file_2,0,SEEK_SET);        #go to start of file_2

while ($line = readline(file_2))		#second pass to create the address resolution table
{
	$count = $count + 1;
        #print $line, "\n";
	if ($line =~ m|:|)		
        {
            chomp($line);			#remove the \n 	
            chop($line);                	#remove the : symbol
            $symtable{"$line"} = $count;        #create the hash table	$Lable => line_no
            print $line ,"\n";
            print "line no is $count\n\n";
        }
        
        
        
        
}

my $size = scalar keys %symtable;
print "Hash size : $size\n";

#print %symtable;

print "\n";

foreach $label (keys %symtable)		#key => value;	$Lable => line_no
{
    print "$label is $symtable{$label}\n";
}


seek(file_2,0,SEEK_SET);        #go to start of file_2



my $offset_addr;
$count = 0;

while($line = readline(file_2))		#third pass to resolve the address
{
        $count = $count + 1;
	@writeline = $line;		# selective modify the @writeline as needed to resolver the addr
        if ($line =~ m|(bne)|)			#bne rt,rs,$Label
	{							
			
		#print ("found $1\n");
		if($line =~ m~(bne)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{0,})~)
		{		
			print "\n\n$1\t $2 \t $3 \t $4\n";			
			print "found at $count \n";
			#print ("found instruction $1 \n");
			#print length($4),"\n";
                        if(exists($symtable{$4}))
                        {
                            #print "$4 is in line $symtable{$4}\n";
                            
                            for (my $i = 0; $i<=length($4);$i++)
                            {
                                #print $i;
                                chop($line);			#remove the $Lable for the bne instn
                                
                            }
                            
                            @writeline = $line;             #chopped line
                            if (($symtable{$4} - $count) < 0)
			    {
				$offset_addr = 65535 + ($symtable{$4} - $count);
			    }
			    else
			    {
				$offset_addr = ($symtable{$4} - $count);
			    }
			    @writeline = (@writeline,$offset_addr);      #line to be used
			    @writeline = (@writeline,"\n");		#put the \n bcoz we had removed it earlier.	
                            delete $symtable{$4};			#delete the resolved addr entry from hash table.
                
                        }
			
		}
                
             print @writeline,"\n";   
                
                
        }
        
        elsif($line =~ m~(j)~)         #j $Label
        {
                #print("found $1\n");
                if($line =~ m~(j)\s(\$\w{0,})~)
                {
                        print "\n\n$1\t $2 \n";			
			print "found at $count \n";
			#print ("found instruction $1 \n");
			#print length($4),"\n";
                        if(exists($symtable{$2}))
                        {
                            #print "$2 is in line $symtable{$2}\n";
                            
                            for (my $i = 0; $i<=length($2);$i++)
                            {
                                #print $i;
                                chop($line);
                                
                            }
                            
                            @writeline = $line;             #chopped line
                            $offset_addr = $symtable{$2};	# no need to take the difference of the address, as this is absolute jump
			    @writeline = (@writeline,$offset_addr);      #line to be used
			    @writeline = (@writeline,"\n");		#put the \n bcoz we had removed it earlier.	
                            delete $symtable{$2};			#delete the resolved addr entry from hash table.
                        }
                    
                }
             print @writeline,"\n";
            
        }
        
        elsif ($line =~ m|(beq)|)			#beq rt,rs,$Label
	{							
			
		#print ("found $1\n");
		if($line =~ m~(beq)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{0,})~)
		{		
			print "\n\n$1\t $2 \t $3 \t $4\n";			
			print "found at $count \n";
			#print ("found instruction $1 \n");
			#print length($4),"\n";
                        if(exists($symtable{$4}))
                        {
                            #print "$4 is in line $symtable{$4}\n";
                            
                            for (my $i = 0; $i<=length($4);$i++)
                            {
                                #print $i;
                                chop($line);
                                
                            }
                            
                            @writeline = $line;             #chopped line
                            if (($symtable{$4} - $count)< 0)
			    {
				$offset_addr = 65535 + ($symtable{$4} - $count);
			    }
			    else
			    {
				$offset_addr = ($symtable{$4} - $count);
			    }
                            @writeline = (@writeline,$offset_addr);      #line to be used
			    @writeline = (@writeline,"\n");		#put the \n bcoz we had removed it earlier.	
                            delete $symtable{$4};			#delete the resolved addr entry from hash table.
                
                        }
			
		}
                
             print @writeline,"\n";   
                
                
        }
        
       
        
        print file_3 @writeline;         #write the instn to file_2
        undef @writeline;
        
        
        
}


print "\n\n";

foreach $label (keys %symtable)
{
    print "$label is $symtable{$label}\n";
}

seek(file_3,0,SEEK_SET);        #go to start of file_3
while($line = readline(file_3))			#fourth pass to put nop after every $Lable
{
	
	@writeline = $line;
	
        #print $line, "\n";
	if ($line =~ m|:|)		
        {
			#@writeline = (@writeline,"\n");
			undef @writeline;
			@writeline = "\tnop\n";
			#@writeline = (@writeline,"\n");
	            
        }
	
	
	print file_4 @writeline;         #write the instn to file_2
        undef @writeline;
}


close(file_1);
close(file_2);
close(file_3);
close(file_4);