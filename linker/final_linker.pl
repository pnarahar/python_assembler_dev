my $line;

#my $path1 = "/home/nandish/linking/code.txt";
#my $path2 = "+>/home/nandish/linking/code_converted.txt";

print "\nGive the absolute path of asm file\n";
my $path_1 = <STDIN>;


print "\nGive the absolute path of file to dump the binaries\n";
my $path_2_in = <STDIN>;

my $path_2 = "+>".$path_2_in;


open (file_1, $path_1);
open (file_2, $path_2);

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
	
	if ($line =~ m|^(SW)|)		#SW rt,rs(imme)
	{
		
		#print ("found $1\n");
		if($line =~ m|^(SW)\s(\w{2,3}),(\w{2,3})\((\d{0,})\)|)
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
			
			$imm = $4;
			$imm_returned = immediate ($imm);
			
			print ("$immediate");
			@instn = (@instn,$imm_returned);
			
			$binaries = join('',@instn);
			print ("$binaries");			
			#print ("\n @instn \n");
			#print (join('',@instn));
			print ("\n");
		}
	}
	
	elsif ($line =~ m|^(LW)|)		#LW rt,rs(imme)
	{
		
		#print ("found $1\n");
		if($line =~ m|^(LW)\s(\w{2,3}),(\w{2,3})\((\d{0,})\)|)
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
			
			$imm = $4;
			$imm_returned = immediate ($imm);
			
			@instn = (@instn,$imm_returned);			
			
			#print ("@instn \n");
			$binaries = join('',@instn);
			print ("$binaries");			
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|^(ADD)|)	#ADD rd,rs,rt
	{
		
		#print ("found $1\n");
		if($line =~ m|^(ADD)\s(\w{2,3}),(\w{2,3}),(\w{2,3})|)
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
			
			$rd = $4;
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}


	elsif ($line =~ m|^(SUB)|)		#SUB rd,rs,rt
	{
		
		#print ("found $1\n");
		if($line =~ m|^(SUB)\s(\w{2,3}),(\w{2,3}),(\w{2,3})|)
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
			
			$rd = $4;
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|^(OR)|)		#OR rd,rs,rt
	{
		
		#print ("found $1\n");
		if($line =~ m|^(OR)\s(\w{2,3}),(\w{2,3}),(\w{2,3})|)
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
			
			$rd = $4;
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			print ("$binaries");							
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}
	
	elsif ($line =~ m|^(AND)|)		#AND rd,rs,rt
	{
		
		#print ("found $1\n");
		if($line =~ m|^(AND)\s(\w{2,3}),(\w{2,3}),(\w{2,3})|)
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
			
			$rd = $4;
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			print ("$binaries");			
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}


	elsif ($line =~ m|^(XNOR)|)	#XNOR rd,rs,rt
	{
		
		#print ("found $1\n");
		if($line =~ m|^(XNOR)\s(\w{2,3}),(\w{2,3}),(\w{2,3})|)
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
			
			$rd = $4;
			$rd_returned = rs_rt_rd ($rd);
			
			@instn = (@instn,$rd_returned);	

			@instn = (@instn,"00000000000");		
			
			$binaries = join('',@instn);
			print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}

	
	
	
	elsif ($line =~ m|^(SHL)|)		#SHL rt,rs(imme)
	{
		
		#print ("found $1\n");
		if($line =~ m|^(SHL)\s(\w{2,3}),(\w{2,3})\((\d{0,})\)|)
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
			print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}


	elsif ($line =~ m|^(ROL)|)			#ROL rt,rs(imme)
	{
		
		#print ("found $1\n");
		if($line =~ m|^(ROL)\s(\w{2,3}),(\w{2,3})\((\d{0,})\)|)
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
			print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|^(SHR)|)			#SHR rt,rs(imme)
	{
		
		#print ("found $1\n");
		if($line =~ m|^(SHR)\s(\w{2,3}),(\w{2,3})\((\d{0,})\)|)
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
			print ("$binaries");						
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}


	elsif ($line =~ m|^(ROR)|)			#ROR rt,rs(imme)
	{
		
		#print ("found $1\n");
		if($line =~ m|^(ROR)\s(\w{2,3}),(\w{2,3})\((\d{0,})\)|)
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
			print ("$binaries");				
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}

	
	elsif ($line =~ m|^(MOV)|)	#MOV rt,rs
	{
		
		#print ("found $1\n");
		if($line =~ m|^(MOV)\s(\w{2,3}),(\w{2,3})|)
		{		
			#print "$1\t $2 \t $3\n";			
			#print ("found instruction $1 \n");
			
			$opcode = "LW";
			$opcode_returned = opcode($opcode);
			@instn = (@instn,$opcode_returned);
			
			$rt = $2;			
			$rs = $3;
				
			$rt_returned = rs_rt_rd ($rt);
			$rs_returned = rs_rt_rd ($rs);
			
			@instn = (@instn,$rs_returned);			
			@instn = (@instn,$rt_returned);	
			
			
			
			@instn = (@instn,"0000000000000000");			
					
			$binaries = join('',@instn);
			print ("$binaries");			
			#print ("@instn \n");
			#print (join('',@instn));
			print ("\n");
			#print ("$4\n");	
		}
	}

	elsif ($line =~ m|^(NOP)|)		#NOP
	{
		
		
			@instn = (@instn,"00000000000000000000000000000000");			
			
			
			$binaries = $instn[0];
			print ("$binaries");			
			#print ("@instn \n");
			#print ("@instn");
			print ("\n");
			#print ("$4\n");	
		
	}


	print file_2 $binaries;
	print file_2 "\n";

	undef $binaries;
	undef @instn;
}
		
			
	


sub rs_rt_rd 
{
	my ($temp_rs) = @_;
	%table = (
		r0 => '00000',		
		r1 => '00001',
		r2 => '00010',				
		r3 => '00011',
		r4 => '00100',	
		r5 => '00101',		
		r6 => '00110',		
		r7 => '00111',		
		r8 => '01000',		
		r9 => '01001',		
		r10 => '01010',		
		r11 => '01011',		
		r12 => '01100',		
		r13 => '01101',
		r14 => '01110',
		r15 => '01111',		


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
		LW => '010010',		
		SW => '100010',
		AND => '110000',				
		OR => '110001',
		ADD => '110010',	
		XNOR => '110100',		
		SUB => '111001',		
		SHL => '000101',		
		ROL => '000110',		
		SHR => '000111',		
		ROR => '001000',		
		MOV => '001001',		
				


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

#lw rt,rs(imm);


close (file_1);
close (file_2);

