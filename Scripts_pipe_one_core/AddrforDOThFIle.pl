use POSIX;
my $h_file = 'C:\Users\Pradeep\Desktop\perl\reg_defines_fifo8.h'; # Location of thwe .h file
my $reg_aaddr_file = '+>C:\Users\Pradeep\Desktop\perl\reg_addr.txt'; # Location to dump the list of address and coresponding variable to be used in yoda.pl
open(file_handle1,$h_file);
open(file_handle2,$reg_aaddr_file);


while($line = readline(file_handle1))
      {
        if($line =~ m~(#define\s)PIPELINE_PROCESSOR_(\w+)_REG\s+0x(\w+)~)
        {
            
            print file_handle2 ("my  \$$2\t\t=0x$3;\n");
        }
      }


