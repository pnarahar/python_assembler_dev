#Set the paths below, before executing this file. Change the path until G:\coding_599, the file names to remain intact.
#The requirement for this code is that, all the sw-regs should end with 'sw' and all the hw-regs should end with 'hw'. The HDL code should be in the file hdl.txt.Running this code will give two files hdl_testing_sw.txt and hdl_testing_hw.txt. Copy and paste the contents of these two files appropriately. Also pipeline_processor.xml is also generated.



my $path1 = 'C:\Users\Pradeep\Desktop\perl\hdl.txt';
my $path2 = '+>C:\Users\Pradeep\Desktop\perl\hdl_testing.txt';
my $path3 = '+>C:\Users\Pradeep\Desktop\perl\hdl_testing_sw.txt';
my $path4 = '+>C:\Users\Pradeep\Desktop\perl\hdl_testing_hw.txt';
my $path5 = '+>C:\Users\Pradeep\Desktop\perl\pipeline_processor.xml';


open (file_1, $path1) || die "cant open file_1\n";
open (file_2, $path2) || die "cant open file_2\n";
open (file_3, $path3) || die "cant open file_3\n";
open (file_4, $path4) || die "cant open file_4\n";
open (file_5, $path5) || die "cant open file_5\n";

my $count = 1;
while($line  = readline(file_1))    #this loop extracts ALL the wires in the code
{
    
    if($line =~ m~^\s{0,}wire~) #m~^wire \[\d{0,}:\d{0,}\]|\s{0,}~
    {
        print file_2 $line;
        #chomp($line);
        #print ("$line at line no. $count\n\n");
       
    }
    $count++;
}

######################################################################

my $starting_part = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<nf:module xmlns:nf=\"http://www.NetFPGA.org/NF2_register_system\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.NetFPGA.org/NF2_register_system NF2_register_system.xsd \">
	<nf:name>pipeline_processor</nf:name>
	<nf:prefix>pipeline_processor</nf:prefix>
	<nf:location>udp</nf:location>
	<nf:description>Registers for Processor</nf:description>
	<nf:blocksize>1024</nf:blocksize>
	<nf:registers>\n";
        
my $ending_part = "	</nf:registers>
</nf:module>\n";

print file_5 $starting_part;







######################################################################

seek(file_2,0,SEEK_SET); 	# go to the start of file_2
my $concat = ".software_regs({";
$count = 1;
$occurence = 0;
my @arr_sw_regs;

while($line = readline(file_2))     #this loop takes care of only sw-regs
{
    if($line =~ m~wire\s(\[(\d{0,}):\d{0,}\]\s)?(.{0,}sw)~)   #$2 is the number 31 or 63
    {                                                       #$3    
        chomp($line);
        print ("$line at line no. $count\n");
        print("$1\t$2\t$3\n");
        if ($2 == 63)
        {
            print file_3 ("wire [31:0] $3_high_reg;\n");
            print file_3 ("wire [31:0] $3_low_reg;\n");
            print file_3 ("assign\t$3={$3_high_reg,$3_low_reg};\n\n");     
            $concat = "$concat"."$3_high_reg,"."$3_low_reg,";
            $occurence = $occurence + 2;
            @arr_sw_regs = ("$3_high_reg",@arr_sw_regs);
            @arr_sw_regs = ("$3_low_reg",@arr_sw_regs);
            
            
        }
        else
        {
            print file_3 ("wire [31:0] $3reg;\n");
            if ($1)
            {
                print file_3 ("assign\t$3$1= $3reg$1;\n\n");
            }
            else
            {
                print file_3 ("assign\t$3= $3reg[0];\n\n");
            }
            
            $concat = "$concat"."$3reg,";
            @arr_sw_regs = ("$3reg",@arr_sw_regs);
            $occurence = $occurence + 1;
        }
        
        
        
         
    }
    $count++;
}

my $j;
for ($j = 0 ; $j< $#arr_sw_regs + 1 ; $j++)
{
	sw_reg_template($arr_sw_regs[$j]);
	#print file_3 ($arr_sw_regs[$j]);
        #print file_3 ("\n");
	
}
print file_3 ("\n\n\n\n");



chop($concat); #to remove the last comma.
$concat = "$concat"."})";
print file_3 ("$concat\n\n\n");

print file_3 ("Number of software registers is:$occurence\n\n");


print"\n No of occurences of sw-regs is $occurence\n\n\n";



########################################################################

seek(file_2,0,SEEK_SET); 	# go to the start of file_2
$concat = ".hardware_regs({";
$count = 1;
$occurence = 0;

my @arr_hw_regs;

while($line = readline(file_2))     #this loop takes care of only hw-regs
{
    if($line =~ m~wire\s(\[(\d{0,}):\d{0,}\]\s)?(.{0,}hw)~)   #$2 is the number 31 or 63
    {                                                       #$3    
        chomp($line);
        print ("$line at line no. $count\n");
        print("$1\t$2\t$3\n");
        if ($2 == 63)
        {
            print file_4 ("wire [31:0] $3_high_reg;\n");
            print file_4 ("wire [31:0] $3_low_reg;\n");
            print file_4 ("assign\t$3_high_reg= $3 [63:32];\n");
            print file_4 ("assign\t$3_low_reg= $3 [31:0];\n\n");
            $concat = "$concat"."$3_high_reg,"."$3_low_reg,";
            $occurence = $occurence + 2;
            @arr_hw_regs = ("$3_high_reg",@arr_hw_regs);
            @arr_hw_regs = ("$3_low_reg",@arr_hw_regs);
            
        }
        else
        {
            print file_4 ("wire [31:0] $3reg;\n");
            if ($1)
            {
                print file_4 ("assign\t$3reg$1= $3$1;\n\n");
            }
            else
            {
                print file_4 ("assign\t$3reg[0]= $3;\n\n");
            }
            $concat = "$concat"."$3reg,";
            @arr_hw_regs = ("$3reg",@arr_hw_regs);
            $occurence = $occurence + 1;
        
        }
        
        
        
        
    }
    $count++;
}

for ($j = 0 ; $j< $#arr_hw_regs + 1 ; $j++)
{
	
	hw_reg_template($arr_hw_regs[$j]);
        #print file_4 ($arr_hw_regs[$j]);
        #print file_4 ("\n");
	
}
print file_4 ("\n\n\n\n");





chop($concat); #to remove the last comma.
$concat = "$concat"."})";
print file_4 ("$concat\n\n\n");
print file_4 ("Number of hardware registers is:$occurence\n\n");


print"\n No of occurences of hw-regs is $occurence\n\n\n";

############################################################################
print file_5 $ending_part;





sub sw_reg_template
{
    my ($reg_name) = @_;
    print file_5 ("\t<nf:register>\n");
    print file_5 ("\t\t<nf:name>"."$reg_name"."</nf:name>\n");
    print file_5 ("\t\t<nf:description>32 bits</nf:description>\n");
    print file_5 ("\t\t<nf:type>generic_software32</nf:type>\n");
    print file_5 ("\t</nf:register>\n");    
}


sub hw_reg_template
{
    my ($reg_name) = @_;
    print file_5 ("\t<nf:register>\n");
    print file_5 ("\t\t<nf:name>"."$reg_name"."</nf:name>\n");
    print file_5 ("\t\t<nf:description>32 bits</nf:description>\n");
    print file_5 ("\t\t<nf:type>generic_hardware32</nf:type>\n");
    print file_5 ("\t</nf:register>\n");    
}






close (file_1);
close (file_2);
close (file_3);
close (file_4);
close (file_5);
