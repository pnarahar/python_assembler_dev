#!/usr/bin/perl -w
use lib "/usr/local/netfpga/lib/Perl5";
use strict;
use POSIX;
use Time::HiRes qw(usleep nanosleep);
#We write Instruction memory in Hex and Data memory in Decimal

my $INSTR_MEM_WREN_SWREG          =0x200040c;
my $INSTR_MEM_SEL_SWREG           =0x2000410;
my $INSTR_MEM_DATA_HANDLE_SWREG   =0x2000414;
my $INSTR_MEM_ADDR_SWREG          =0x2000418;
my $DATAMEM_WEN_SWREG             =0x200041c;
my $DATAMEM_WEN_SEL_SWREG		  =0x2000420;
my $DATAMEM_DATA_SW_HIGH_REG      =0x2000428;
my $DATAMEM_DATA_SW_LOW_REG       =0x2000424;
my $DATAMEM_DATA_SEL_SWREG		  =0x200042c;
my $DATAMEM_ADDR_SWREG            =0x2000430;
my $DATAMEM_ADDR_SEL_SWREG		  =0x2000434;
my  $PIPE_START_SEL_SWREG		  =0x2000408;
my $INSTR_MEM_OUTPUT_HW           =0x200043c;
my $DATA_MEM_OUTPUT_HW_LOW        =0x2000440;
my $DATA_MEM_OUTPUT_HW_HIGH       =0x2000444;
my  $RESET_SWREG				  =0x2000400;
my  $PIPE_START_SWREG			  =0x2000404;
my  $PIPE_START_READ_HW			  =0x2000438;

my $j=0;
my $i =0;
my $r =0 ;
sub regwrite {

   my( $addr, $value ) = @_;
   my $cmd = sprintf( "regwrite $addr 0x%08x", $value );
   my $result = `$cmd`;
   
   #print "Ran command '$cmd' and got result '$result'\n";
}

sub regread {
      
   my( $addr ) = @_;
   my $cmd = sprintf( "regread $addr" );
   my @out = `$cmd`;
   my $result = $out[0];
   if ( $result =~ m/Reg (0x[0-9a-f]+) \((\d+)\):\s+(0x[0-9a-f]+) \((\d+)\)/ ) {
      $result = $3;
   }
   
    
   return $result;
   
}
sub usage {
   print " Usage: yoda <cmd> <cmd options>\n";
   print " We write Instruction memory in Hex and Data memory in Decimal\n";
   print " Commands:\n";
   print " ReadDM <No of Entries>                        Reads the specified no of Enteries from Data from the data memory\n";
   print " ReadDMHEX <No of Entries>                        Reads the specified no of Enteries from Data from the data memory\n";
   print " ReadIM <No of Entries>                        Reads the specified no of Enteries from Instruction Memory \n";
   print " WriteIM <address> <Instr>                     Write into Data memory at the specified location \n";
   print " WriteIMM <instr1> <instr2> <instr3>           Write into Instruction memory\n";
   print " WriteIMMEND                                   Fill Instruction Memory with End Instructions\n";
   print " WriteDM <address> <Upper32Bits> <Lower32Bits> Write into Data memory at the specified location \n";
   print " WriteDMM <Upper32Bits> <Lower32Bits> ..       Write multiple enteries into Data Memory\n";
   print " ClearIM                                       Clears the instruction memory\n";
   print " ClearDM			                 Clears Datamem\n";
   print " Run                                           To run the Processor Check results in Data Memory\n";
   print " Reset                                         To reset the program Counter\n";
}

my $numargs = $#ARGV + 1;
if( $numargs < 1 ) {
   usage();
   exit(1);
}
my $cmd = $ARGV[0];
if ($cmd eq "reset")
{
   
}
elsif ($cmd eq "WriteIM")
{
	regwrite($INSTR_MEM_SEL_SWREG,1);
	regwrite($INSTR_MEM_WREN_SWREG,0);
   	regwrite($INSTR_MEM_ADDR_SWREG,$ARGV[1]);
   	my $k =  hex($ARGV[2]);
	regwrite($INSTR_MEM_DATA_HANDLE_SWREG,$k);
   	regwrite($INSTR_MEM_WREN_SWREG,1);
	nanosleep(100);
   	regwrite($INSTR_MEM_WREN_SWREG,0);
	regwrite($INSTR_MEM_SEL_SWREG,0); 
   	print "INSTRUCTION LOADED SUCCESSFULLY WITH INSTRUCTIONS\n\n";
    
}
elsif ($cmd eq "WriteIMM") #WRITING INTO THE INSTRUCTION MEMORY
{  

 regwrite($INSTR_MEM_SEL_SWREG,1); 
 for(my $i=0; $i<$numargs-1; $i++)
 {
   
   print "no of arguments \t $numargs \n";
   regwrite($INSTR_MEM_WREN_SWREG,0);
   regwrite($INSTR_MEM_ADDR_SWREG,$i);
   print " argument",($i+1)," is \t $ARGV[$i+1]\n";
   $j =  hex($ARGV[$i+1]);
   regwrite($INSTR_MEM_DATA_HANDLE_SWREG,$j);
   regwrite($INSTR_MEM_WREN_SWREG,1); 
   nanosleep(100);   
   print "Writing 0x$j into Instruction Memory @ $i..........\n";
 }
 regwrite($INSTR_MEM_WREN_SWREG,0);
 regwrite($INSTR_MEM_SEL_SWREG,0); 
 
 print "INSTRUCTION MEMORY LOADED SUCCESSFULLY WITH INSTRUCTIONS\n\n";
    
}
elsif ($cmd eq "WriteIMMEND") #WRITING INTO THE INSTRUCTION MEMORY
{  

 regwrite($INSTR_MEM_SEL_SWREG,1); 
 for(my $i=0; $i<512; $i++)
 {
   
   #print "no of arguments \t $numargs \n";
   regwrite($INSTR_MEM_WREN_SWREG,0);
   regwrite($INSTR_MEM_ADDR_SWREG,$i);
   #print " argument",($i+1)," is \t $ARGV[$i+1]\n";
   $j =  hex("0xFC000000");
   regwrite($INSTR_MEM_DATA_HANDLE_SWREG,$j);
   regwrite($INSTR_MEM_WREN_SWREG,1); 
   nanosleep(100);   
   print "Writing 0x$j into Instruction Memory @ $i..........\n";
 }
 regwrite($INSTR_MEM_WREN_SWREG,0);
 regwrite($INSTR_MEM_SEL_SWREG,0); 
 
 print "INSTRUCTION MEMORY LOADED SUCCESSFULLY WITH INSTRUCTIONS\n\n";
    
}
elsif ($cmd eq "WriteDM") #WRITE DATA INTO THE A PARTICULAR ADDRESS OF THE DATA MEMORY
{ 
regwrite($PIPE_START_SEL_SWREG,1);
 regwrite($PIPE_START_SWREG,1);
regwrite($DATAMEM_ADDR_SEL_SWREG,1);
regwrite($DATAMEM_DATA_SEL_SWREG,1);
regwrite($DATAMEM_WEN_SEL_SWREG,1);
 $i = $ARGV[1]; 
 $j = $ARGV[2];
 $r = $ARGV[3];
 regwrite($DATAMEM_DATA_SW_HIGH_REG,$j);
 regwrite($DATAMEM_DATA_SW_LOW_REG,$r);
   regwrite($DATAMEM_ADDR_SWREG,$i);
  regwrite($DATAMEM_WEN_SWREG,1);
sleep 1;
 regwrite($DATAMEM_WEN_SWREG,0);
 # regwrite($PIPE_START_SEL_SWREG,0);
 # regwrite($PIPE_START_SWREG,0);
regwrite($DATAMEM_ADDR_SEL_SWREG,0);
regwrite($DATAMEM_DATA_SEL_SWREG,0);
regwrite($DATAMEM_WEN_SEL_SWREG,0); 
 print " DATA MEMORY LOADED at location $i\n\n";    
}

# elsif ($cmd eq "ClearDM")
# {

	# regwrite($PIPE_START_SEL_SWREG,1);
	 # regwrite($PIPE_START_SWREG,1);
	# regwrite($DATAMEM_ADDR_SEL_SWREG,1);
	# regwrite($DATAMEM_DATA_SEL_SWREG,1);
	# regwrite($DATAMEM_WEN_SEL_SWREG,1);
 # for(my $i=0; $i<256; $i = $i+1)
 # {
   
   # print " i", $i,"\n";
   # regwrite($DATAMEM_WEN_SWREG,0);
   # regwrite($DATAMEM_ADDR_SWREG,$i);  
   # regwrite($DATAMEM_DATA_SW_HIGH_REG,0);
   # regwrite($DATAMEM_DATA_SW_LOW_REG,0);
   # regwrite($DATAMEM_WEN_SWREG,1); 
 # }
 # regwrite($DATAMEM_WEN_SWREG,0);
  # regwrite($PIPE_START_SEL_SWREG,0);
   # regwrite($PIPE_START_SWREG,0);
# regwrite($DATAMEM_ADDR_SEL_SWREG,0);
# regwrite($DATAMEM_DATA_SEL_SWREG,0);
# regwrite($DATAMEM_WEN_SEL_SWREG,0); 
 # print "DATA MEMORY Cleared\n\n";  
# }
# elsif ($cmd eq "ClearIM")
# { 
 # regwrite($INSTR_MEM_SEL_SWREG,1); 
  # for(my $i=0; $i<512; $i++)
 # {
   # regwrite($INSTR_MEM_WREN_SWREG,0);
   # regwrite($INSTR_MEM_ADDR_SWREG,$i);
   # regwrite($INSTR_MEM_DATA_HANDLE_SWREG,0);
   # regwrite($INSTR_MEM_WREN_SWREG,1);   
 # }
 # regwrite($INSTR_MEM_WREN_SWREG,0);
 # regwrite($INSTR_MEM_SEL_SWREG,0);
 # print "INSTRUCTION MEMORY CLEARED\n\n";    
# }
elsif ($cmd eq "ReadIM")
{  
   regwrite($INSTR_MEM_SEL_SWREG,1);   #Enabling the Instruction Memory Address Select Line
   print "\nTHE INSTRUCTION MEMORY DATA \n";
   print "---------------------------\n";   
   my $limit = $ARGV[1];
   for(my $i=0; $i<$limit; $i++)
   {	  
      regwrite($INSTR_MEM_ADDR_SWREG,$i);
	  my $instruction = regread($INSTR_MEM_OUTPUT_HW );
	  print $i, ": ";
	  print $instruction, "\n";
	  
   }
   regwrite($INSTR_MEM_SEL_SWREG,0); 
   print "\n";
}
elsif ($cmd eq "ReadDMHEX")
{   
	regwrite($PIPE_START_SEL_SWREG,1);
	 regwrite($PIPE_START_SWREG,1);
	regwrite($DATAMEM_ADDR_SEL_SWREG,1);
	regwrite($DATAMEM_DATA_SEL_SWREG,1);
	regwrite($DATAMEM_WEN_SEL_SWREG,1);
   print "\nTHE DATA MEMORY DATA \n";
   print "-----------------------\n"; 
   my $limit = $ARGV[1];
   for(my $i=0; $i<$limit; $i++)
   {	  
      regwrite($DATAMEM_ADDR_SWREG,$i);
   	  my $data_hi = regread($DATA_MEM_OUTPUT_HW_HIGH);
	  my $data_lo = regread($DATA_MEM_OUTPUT_HW_LOW);	 
	  print $i, ": ";
	  print hex($data_hi),hex($data_lo),"\n";	  
	  print "\n";
   }
   print "\n";
     # regwrite($PIPE_START_SEL_SWREG,0);
	 # regwrite($PIPE_START_SWREG,0);
regwrite($DATAMEM_ADDR_SEL_SWREG,0);
regwrite($DATAMEM_DATA_SEL_SWREG,0);
regwrite($DATAMEM_WEN_SEL_SWREG,0); 
} 
elsif ($cmd eq "TestProc")
{
regwrite($INSTR_MEM_SEL_SWREG,1); 
  for(my $i=0; $i<512; $i++)
 {
   regwrite($INSTR_MEM_WREN_SWREG,0);
   regwrite($INSTR_MEM_ADDR_SWREG,$i);
   regwrite($INSTR_MEM_DATA_HANDLE_SWREG,0);
   regwrite($INSTR_MEM_WREN_SWREG,1);   
 }
 regwrite($INSTR_MEM_WREN_SWREG,0);
 regwrite($INSTR_MEM_SEL_SWREG,0);
 print "INSTRUCTION MEMORY CLEARED\n\n";
 sleep(1);
regwrite($PIPE_START_SEL_SWREG,1);
regwrite($PIPE_START_SWREG,1);
regwrite($DATAMEM_ADDR_SEL_SWREG,1);
regwrite($DATAMEM_DATA_SEL_SWREG,1);
regwrite($DATAMEM_WEN_SEL_SWREG,1);
 for(my $i=0; $i<256; $i = $i+1)
 {
   
   print " i", $i,"\n";
   regwrite($DATAMEM_WEN_SWREG,0);
   regwrite($DATAMEM_ADDR_SWREG,$i);  
   regwrite($DATAMEM_DATA_SW_HIGH_REG,0);
   regwrite($DATAMEM_DATA_SW_LOW_REG,0);
   regwrite($DATAMEM_WEN_SWREG,1);
regwrite($PIPE_START_SEL_SWREG,0);
regwrite($PIPE_START_SWREG,0);   
}
}
elsif ($cmd eq "ReadDM")
{   
	regwrite($PIPE_START_SEL_SWREG,1);
	 regwrite($PIPE_START_SWREG,1);
	regwrite($DATAMEM_ADDR_SEL_SWREG,1);
	regwrite($DATAMEM_DATA_SEL_SWREG,1);
	regwrite($DATAMEM_WEN_SEL_SWREG,1);
   print "\nTHE DATA MEMORY DATA \n";
   print "-----------------------\n"; 
   my $limit = $ARGV[1];
   for(my $i=0; $i<$limit; $i++)
   {	  
      regwrite($DATAMEM_ADDR_SWREG,$i);
   	  my $data_hi = regread($DATA_MEM_OUTPUT_HW_HIGH);
	  my $data_lo = regread($DATA_MEM_OUTPUT_HW_LOW);	 
	  print $i, ": ";
	  print $data_hi,$data_lo,"\n";	  
	  print "\n";
   }
   print "\n";
     # regwrite($PIPE_START_SEL_SWREG,0);
	 # regwrite($PIPE_START_SWREG,0);
regwrite($DATAMEM_ADDR_SEL_SWREG,0);
regwrite($DATAMEM_DATA_SEL_SWREG,0);
regwrite($DATAMEM_WEN_SEL_SWREG,0); 
} 
elsif ($cmd eq "Run")
{
   #Give a handler to clockEnable and Set it here...
   #regwrite($PC_EN,1);
   regwrite($RESET_SWREG,0);
   regwrite($PIPE_START_SEL_SWREG,1);
   regwrite($PIPE_START_SWREG,1);
   #sleep(1);
   
  #regwrite($PC_EN,0);
   #regwrite($PC_RESET,1);
   #Disable ClockEnable ...   
} 
elsif ($cmd eq "Reset")
{
   #Give a handler to clockEnable and Set it here...
   #regwrite($PC_EN,0);
   regwrite($RESET_SWREG,1);  
	#sleep(1);
   #regwrite($RESET_SWREG,0);
   #Disable ClockEnable ...   
} 
 else 
{
   print "Unrecognized command $cmd\n";
   usage();
   exit(1)
}
