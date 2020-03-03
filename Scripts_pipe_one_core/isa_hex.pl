#move --> changed to move opcode
#beq --> interchanged rt,rs


#perl isa_hex.pl [hex/bin] [lines]


my $line;

my $path1 = 'C:\Scripts_pipe_one_core\addr_resol_final.txt';
my $path2 = '+>C:\Scripts_pipe_one_core\file_bin_bsort.txt';

#print "\nGive the absolute path of asm file\n";
#my $path_1 = <STDIN>;


#print "\nGive the absolute path of file to dump the binaries\n";
#my $path_2_in = <STDIN>;

#my $path_2 = "+>".$path_2_in;


my $final_value;

open (file_1, $path1);
open (file_2, $path2);

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


while ($line = readline(file_1))
{
	
	if ($line =~ m|(sw)|)		#SW rt,rs(imme)
	{                                  #sw $rt,imme($rs) 
		
		#print ("found xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
		if($line =~ m|(sw)\s(\$\w{1,2}),(\d{0,})\((\$\w{1,2})\)|)
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $4;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
						
			
			$imm = $3;
			$imm_returned = immediate ($imm);
			
			#print ("$immediate");
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$imm_returned);
			
			print ("$opcode_returned \t $rt_returned \t $rs_returned \t $imm_returned \n");
			
			$binaries = join('',@instn);
			#print ("$binaries");			
			#print ("\n @instn \n");
			#print (join('',@instn));
			#print ("\n");
		}
	}
	
	elsif ($line =~ m|(lw)|)		#LW rt,rs(imme)
	{					#lw $rt,imme($rs)
		
		#print ("found $1\n");
		if($line =~ m|(lw)\s(\$\w{1,2}),(\d{0,})\((\$\w{1,2})\)|) 			#m|(lw)\s(\$\w{1,2}),(\d{0,})\((\$\w{1,2})\)|
		{		
			print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $4;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
					
			$imm = $3;
			
			
			$imm_returned = immediate ($imm);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$imm_returned);			
			
			print ("$opcode_returned \t $rt_returned \t $rs_returned \t $imm_returned \n");
			#print ("@instn \n");
			$binaries = join('',@instn);
			#print ("$binaries");	
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}
	elsif ($line =~ m|(ror)|)			#ROL rt,rs(imme)
	{						#rol $rt,$rs,imme
		
		#print ("found zzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n");
		if($line =~ m|(ror)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|)
		{		
		#	print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,"00000");	
			
			$imm = $4;
			$imm_returned = immediate_shift ($imm);
			
			@instn = (@instn,$imm_returned);
	
			@instn = (@instn,"00000");			
			
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(addu)|)	#ADD rd,rs,rt							#m|(add)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|
	{				#add $rd,$rs,$rt	
		
		#print ("found $1\n");
		if($line =~ m|(addu)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|)
		{		
			print "$1\t $2 \t $3\t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;			
			$rs = $3;
			$rt = $4;
			
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			print ("$opcode_returned \t $rd_returned \t $rs_returned \t $rt_returned\n");
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
		
		elsif (($line =~ m|(addu)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|))		#addu $rt,$rs,imme
		{
			print "$1\t $2 \t $3\t $4\n";			
			#print ("found instruction2222222 $1 \n");
			
			$opcode = "addi";
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			#print "$opcode\n";
			$imm = $4;			
			$rs = $3;
			$rt = $2;
			
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$imm_returned = immediate ($imm);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$imm_returned);	
		
			
			
			print ("$opcode_returned \t $rt_returned \t $rs_returned \t $imm\n");
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");
		}
		
		
	}


	elsif ($line =~ m|(subu)|)		#SUB rd,rs,rt
	{					#subu $rd,$rs,$rt	
		
		#print ("found $1\n");
		if($line =~ m|(subu)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|)
		{		
			print "$1\t $2 \t $3\t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;			
			$rs = $3;
			$rt = $4;
			
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			print ("$opcode_returned \t $rt_returned \t $rs_returned \t $imm_returned \n");
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(or)|)		#OR rd,rs,rt
	{					#or $rd,$rs,$rt
		
		#print ("found $1\n");
		if($line =~ m|(or)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|)
		{		
			#print "$1\t $2 \t $3\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;			
			$rs = $3;
			$rt = $4;
			
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$rd_returned);
			
			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			#print ("$binaries");							
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}
	
	elsif ($line =~ m|(and)|)		#AND rd,rs,rt
	{					#and $rd,$rs,$rt
		
		#print ("found $1\n");
		if($line =~ m|(and)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|)
		{		
			#print "$1\t $2 \t $3\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;			
			$rs = $3;
			$rt = $4;
			
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$rd_returned);
			
			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			#print ("$binaries");			
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}


	elsif ($line =~ m|(xnor)|)	#XNOR rd,rs,rt
	{				#xnor $rd,$rs,$rt
		
		#print ("found $1\n");
		if($line =~ m|(xnor)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|)
		{		
			#print "$1\t $2 \t $3\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;			
			$rs = $3;
			$rt = $4;
			
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$rd_returned);
			
			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	
	
	
	elsif ($line =~ m|(sll)|)		#SHL rt,rs(imme)
	{					#sll $rt,$rs,imme	
		
		#print ("found $1\n");
		if($line =~ m|(sll)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|)					#m|(sw)\s(\$\w{1,2}),(\d{0,})\((\$\w{1,2})\)|
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,"00000");	
			
			$imm = $4;
			$imm_returned = immediate_shift ($imm);
			
			@instn = (@instn,$imm_returned);
	
			@instn = (@instn,"00000");			
			
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}


	elsif ($line =~ m|(rol)|)			#ROL rt,rs(imme)
	{						#rol $rt,$rs,imme
		
		#print ("found $1\n");
		if($line =~ m|(rol)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|)
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,"00000");	
			
			$imm = $4;
			$imm_returned = immediate_shift ($imm);
			
			@instn = (@instn,$imm_returned);
	
			@instn = (@instn,"00000");			
			
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(srl)|)			#SHR rt,rs(imme)
	{						#srl $rt,$rs,imme
		
		#print ("found $1\n");
		if($line =~ m|(srl)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|)
		{		
			#print "$1\t $2 \t $3\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,"00000");	
			
			$imm = $4;
			$imm_returned = immediate_shift ($imm);
			
			@instn = (@instn,$imm_returned);
	
			@instn = (@instn,"00000");			
			
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	
	elsif ($line =~ m|(slt)|)			
	{						#slt $rd,$rs,$rt
		
		#print ("found $1\n");
		if($line =~ m|(slt)\s(\$\w{1,2}),(\$\w{1,2}),(\$\w{1,2})|)
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;
			$rt = $4;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			$rd_returned = rs_rt_rd ($rd);
			
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			@instn = (@instn,$rd_returned);
	
			@instn = (@instn,"00000000000");			
			
			$binaries = join('',@instn);
			#print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}
	
	elsif ($line =~ m|(bne)|)			#bne $rt,$rs,imme
	{							
			
		#print ("found $1\n");
		if($line =~ m|(bne)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|)
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			
				
			
			$imm = $4;
			$imm_returned = immediate ($imm);
			
			@instn = (@instn,$rt_returned);
			@instn = (@instn,$rs_returned);				
			@instn = (@instn,$imm_returned);
	
						
			
			$binaries = join('',@instn);
			#print ("$binaries");				
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(beq)|)			#beq $rt,$rs,imme		# changed rs rt position
	{							
			
		#print ("found $1\n");
		if($line =~ m|(beq)\s(\$\w{1,2}),(\$\w{1,2}),(\d{0,})|)
		{		
			#print "$1\t $2 \t $3 \t $4\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			
				
			
			$imm = $4;
			$imm_returned = immediate ($imm);
			
			@instn = (@instn,$rt_returned);			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$imm_returned);
	
						
			
			$binaries = join('',@instn);
			#print ("$binaries");				
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}
	elsif ($line =~ m|(jal)|)			#jal abs addr
	{							
			
		#print ("found xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
		if($line =~ m|(jal)\s(\d{0,})|)
		{		
			#print "$1\t $2 \t\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rs = "\$0";
			$rt = "\$31";
			
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			
	
			
			
			
			$imm = $2;
			$imm_returned = immediate ($imm);
			
			
			@instn = (@instn,$imm_returned);
	
						
			
			$binaries = join('',@instn);
			#print ("$binaries");				
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(li)|)			#li $rt,imme
	{							
			
		#print ("found xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
		if($line =~ m|(li)\s(\$\w{1,2}),(\d{0,})|)
		{		
			#print "$1\t $2 \t $3\t\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rs = "\$0";
			$rt = $2;
			
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			
	
			
			
			
			$imm = $3;
			$imm_returned = immediate ($imm);
			
			
			@instn = (@instn,$imm_returned);
	
						
			
			$binaries = join('',@instn);
			#print ("$binaries");				
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(j)|)			#j abs addr
	{							
			
		#print ("found ddddddddddddddddddddd\n");
		if($line =~ m|(j)\s(\d{0,})|)
		{		
		#	print "$1\t $2 \t\n";			
			#print ("found instruction $1 \n");
			
			$opcode = $1;
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
						
			$imm = $2;
			$imm_returned = immediate_jump ($imm);
			
			
			@instn = (@instn,$imm_returned);
	
						
			
			$binaries = join('',@instn);
			#print ("$binaries");				
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	
	
	
	elsif ($line =~ m|(move)|)	#MOV rd,rs					# not move is implemented as move only, not as addu
	{				#move $rd,$rs
		
		#print ("found $1\n");
		if($line =~ m|(move)\s(\$\w{1,2}),(\$\w{1,2})|)
		{		
			#print "$1\t $2 \t $3\n";			
			#print ("found instruction $1 \n");
			
			$opcode = "move";
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rd = $2;			
			$rs = $3;
				
			$rd_returned = rs_rt_rd ($rd);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);
			@instn = (@instn,$rd_returned);	
			@instn = (@instn,"00000");
			
			
			@instn = (@instn,"00000000000");			
					
			$binaries = join('',@instn);
			#print ("$binaries");			
			#print ("@instn \n");
			#print (join('',@instn));
			#print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|(nop)|)		#NOP
	{					#nop
		
		
			@instn = (@instn,"00000000000000000000000000000000");			
			
			
			$binaries = $instn[0];
			#print ("$binaries");			
			#print ("@instn \n");
			#print ("@instn");
			#print ("\n");
			#print ("$4\n");	
		
	}
	

	$final_value = bin_to_hex ($binaries);
	print file_2 $final_value;
my $temp1 = $ARGV[1];
	if($temp1 eq "lines")
	{
		print file_2 "\n";
	}
	else
	{
		print file_2 " ";	
	}
	
	print $final_value, "\n";          # printing to console

	undef $binaries;
	undef @instn;
}
		
sub bin_to_hex
{
	my ($binary) = @_;
	my $int = unpack("N", pack("B32", substr("0" x 32 . $binary, -32)));	
	my $hex = sprintf("0x%X", $int );	
	my $temp = $ARGV[0];
	if ($temp eq "hex")	
	{
		#print $hex,"\n";
		return ($hex);	
	}
	else
	{
		return ($binary);	
	}	
}			
	


sub rs_rt_rd 
{
	my ($temp_rs) = @_;
	%table = (
		'$0' => '00000',		
		'$1' => '00001',
		'$2' => '00010',				
		'$3' => '00011',
		'$4' => '00100',	
		'$5' => '00101',		
		'$6' => '00110',		
		'$7' => '00111',		
		'$8' => '01000',		
		'$9' => '01001',		
		'$10' => '01010',		
		'$11' => '01011',		
		'$12' => '01100',		
		'$13' => '01101',
		'$14' => '01110',
		'$15' => '01111',		
		'$16' => '10000',
		'$17' => '10001',	
		'$18' => '10010',
		'$19' => '10011',
		'$20' => '10100',
		'$21' => '10101',
		'$22' => '10110',
		'$23' => '10111',
		'$24' => '11000',
		'$25' => '11001',
		'$26' => '11010',
		'$27' => '11011',
		'$28' => '11100',
		'$29' => '11101',
		'$30' => '11110',
		'$31' => '11111',
		
		);	
	my $rs_value = $table{$temp_rs};
	#print "$temp_rs \n";	
	#print("$rs_value\n");
	return ($rs_value);

}

sub opcode 
{
	my ($temp_opcode) = @_;
	%table_opcode = (
		'lw' => '010010',		
		'sw' => '100010',
		'and' => '110000',				
		'or' => '110001',
		'addu' => '110010',	
		'xnor' => '110100',		
		'subu' => '111001',		
		'sll' => '000101',		
		'rol' => '000110',		
		'srl' => '000111',		
		'ror' => '001000',		
		'move' => '001110',		
		'bne' => '001001',
		'beq' => '001010',
		'j' => '001011',
		'jal' => '001100',
		'li' => '001101',
		'addi' => '001111',
		'slt' => '110011',


		);
	my $opcode_value = $table_opcode{$temp_opcode};
	#print "$temp_rs \n";	
	#print("$opcode_value\n");
	return ($opcode_value);

}

sub immediate
{
	
	my ($dec) = @_;
	my $k;
	my @bin;
	undef @bin;
	for(my $c=15;$c>=0;$c--)
	{
		$k = $dec >> $c;
	
		if($k & "1")
		{
			@bin = (@bin,"1");
		
		}
		else 
		{
	
			@bin = (@bin,"0");	
		}
	
	}
	
	$bin = join('',@bin);
	#print ("\n\n$bin\n");	
	return ($bin);
}

sub immediate_shift
{
	
	my ($dec_shift) = @_;
	my $k_shift;
	my @bin_shift;
	undef @bin_shift;
	for(my $z=5;$z>=0;$z--)
	{
		$k_shift = $dec_shift >> $z;
	
		if($k_shift & "1")
		{
			@bin_shift = (@bin_shift,"1");
		
		}
		else 
		{
	
			@bin_shift = (@bin_shift,"0");	
		}
	
	}
	
	$bin_shift = join('',@bin_shift);
	#print ("\n\n$bin\n");	
	return ($bin_shift);
}



sub immediate_jump
{
	
	my ($dec_jump) = @_;
	my $k_jump;
	my @bin_jump;
	undef @bin_jump;
	for(my $x=25;$x>=0;$x--)
	{
		$k_jump = $dec_jump >> $x;
	
		if($k_jump & "1")
		{
			@bin_jump = (@bin_jump,"1");
		
		}
		else 
		{
	
			@bin_jump = (@bin_jump,"0");	
		}
	
	}
	
	$bin_jump = join('',@bin_jump);
	#print ("\n\n$bin\n");	
	return ($bin_jump);
}



close (file_1);
close (file_2);
