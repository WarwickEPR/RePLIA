/*  FPGA lock in configuration tool.
 *  gcc -O3 settings.c -o settings -lm
 */

#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>

//Calibration data - should really be in a separate file, but here for now
#define DAC_A_MIN -1.0
#define DAC_A_MAX  1.0
#define DAC_B_MIN -1.0
#define DAC_B_MAX  1.0

#define SET_LOC 0x43C00000 //Memory address of AXI_input in LockIn project
#define FREQ_OFF 0 //Out number of frequency defining output on AXI_input (*4)
#define AVG_OFF 4 //Out number of averaging time defining output (*4)
#define MODE_OFF 8 //Out number of mode defining output (*4)
#define SWEEP_MIN_OFF 12 //Sweep minimum output
#define SWEEP_MAX_OFF 16 //Sweep max output
#define SWEEP_ADD_OFF 20 //Add value for sweep accumulator
#define AMP_MULT_OFF 24 //Value for multiplying amplitude before division
#define DAC_MULT_OFF 28 //Multiplication for dacs (2 16bit values)
#define LEAD_OFF 32  //Phase lead of modulation output offset
#define SAMP_OFF 36 //Sampling rate (to memory) offset

#define SYS_CLOCK 125000000.0 //Nominal clock frequency of the FPGA (in Hz)
#define MOV_AVG_LOG_SAMP 6  //Log2_samples parameter for the moving average
#define PHASE_BITS 32 //Number of bits in the phase for ref generation
#define AVG_BITS 32 //Number of bits in the averaging counter
#define SWEEP_IN_BITS 32 //Number of bits for sweep min/max inputs
#define SWEEP_BITS 40 //Number of bits in the sweep accumulator
#define AMP_DIV_BITS 32 //Number of bits the amplitude is divided by after multiplication
#define DDS_BITS 16 //Number of output bits on sin/cos DDS
#define LEAD_BITS 16 //Number of bits for phase lead calculation
#define SAMP_BITS 32 //Number of bits for sampling rate

#define MAS_VAL 1 //2^ bit number of the master/slave bit in the mode call (e.g. 8 = 3rd bit, counting from 0 - so 4th setting)
#define RES_VAL 8 //2^ bit number of the reset (sync) bit in the mode call (e.g. 8 = 3rd bit, counting from 0 - so 4th setting)

double pow2(int bits);
void display_manual();

int main (int argc, char *argv[])
{
  int mmapfd, i;
  void *set;
  uint32_t val, val1, val2, old_val;
  double input, input1, input2, temp, freq_max_cnt, avg_max_cnt, mov_avg_cnt, samp_max_cnt, freq_step, avg_freq_step, amp_div, sweep_step, sweep_in_step, samp_step, lead_step;
  
  //No parameters, display manual
  if(argc < 2)
  {
    display_manual();
    return 0;
  }
  
  //Open memory access
  if((mmapfd = open("/dev/mem", O_RDWR)) < 0)
  {
    perror("open");
    return 1;
  }
  
  set = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, mmapfd, SET_LOC);
  
  //Convert bit depths into number of counts. Using doubles as bit depth is often 32 and thus won't fit in ints (and maths is on doubles anyway)
  freq_max_cnt = pow2(PHASE_BITS);
  avg_max_cnt = pow2(AVG_BITS);
  mov_avg_cnt = pow2(MOV_AVG_LOG_SAMP);
  amp_div = pow2(AMP_DIV_BITS);
  samp_max_cnt = pow2(SAMP_BITS);
  
  lead_step = 360.0/pow2(LEAD_BITS);
  
  sweep_in_step = (DAC_B_MAX-DAC_B_MIN)/pow2(SWEEP_IN_BITS);
  sweep_step = (DAC_B_MAX-DAC_B_MIN)/pow2(SWEEP_BITS);
  
  freq_step = SYS_CLOCK/freq_max_cnt;
  samp_step = SYS_CLOCK/samp_max_cnt;
  avg_freq_step = (SYS_CLOCK/avg_max_cnt)/mov_avg_cnt;
  
  for(i = 1; i < argc; i++)
  {
    switch(argv[i][0])
    {
      case 'f': //Frequency in Hz
        i++;
        if(i >= argc)
        {
          printf("No frequency given!\n");
        }
        else
        {
          input = atof(argv[i]);
          val = (uint32_t)(input/freq_step);
          *((uint32_t *)(set + FREQ_OFF)) = val;
          printf("Setting reference frequency to %G Hz.\n", input);
          printf("Using phase incremement of %u.\n", val);
        }
        break;
      case 't': //Averaging period
        i++;
        if(i >= argc)
        {
          printf("No time given!\n");
        }
        else
        {
          input = atof(argv[i]);
          temp = 1./input;
          val = (uint32_t)(temp/avg_freq_step);
          *((uint32_t *)(set + AVG_OFF)) = val;
          printf("Setting averaging period to %G s.\n", input);
          printf("Using count incremement of %u.\n", val);
        }
        break;
      case 'm': //Operating mode
        i++;
        if(i >= argc)
        {
          printf("No mode given!\n");
        }
        else
        {
          val = (uint32_t)strtol(argv[i], NULL, 2);
          //Deal with reset/sync - in logic reset is done when it changes the bit value, but want the user to enter 1 to send a sync. Master unit only
          if((val & RES_VAL) > 0 && ((~val) & MAS_VAL) == 1)
          {
            old_val = *((uint32_t *)(set + MODE_OFF));
            //Check value currently in memory
            if((old_val & RES_VAL) > 0)
            {
              val -= RES_VAL;
            }
          }
          *((uint32_t *)(set + MODE_OFF)) = val;
          printf("Switching modes!\n");
        }
        break;
      case 's': //Sweep paramaters, with 3 values
        i+=3;
        if(i >= argc)
        {
          printf("Not enough parameters!\n");
        }
        else
        {
          input = atof(argv[i-2]);
          input1 = atof(argv[i-1]);
          input2 = atof(argv[i]);
          //Sweep minimum
          val = (uint32_t)((input-DAC_B_MIN)/sweep_in_step);
          val = val == 0 ? 1 : val; //avoid default value
          *((uint32_t *)(set + SWEEP_MIN_OFF)) = val;
          //Sweep maximum
          val1 = (uint32_t)((input1-DAC_B_MIN)/sweep_in_step);
          *((uint32_t *)(set + SWEEP_MAX_OFF)) = val1;
          //SWeep step
          val2 = (uint32_t)(((input1-input)/(input2*SYS_CLOCK))/sweep_step);
          *((uint32_t *)(set + SWEEP_ADD_OFF)) = val2;
          printf("Setting sweep to %G V to %G V over %G s.\n", input, input1, input2);
          printf("Using parameters of %u, %u, %u.\n", val, val1, val2);
        }
        break;
      case 'a': //Amp mod amplitude
        i++;
        if(i >= argc)
        {
          printf("No amplitude given!\n");
        }
        else
        {
          input = atof(argv[i]);
          val = (uint32_t)((input/(DAC_B_MAX-DAC_B_MIN))*amp_div);
          *((uint32_t *)(set + AMP_MULT_OFF)) = val;
          printf("Setting sweep sine modulation amp to %G V.\n", input);
          printf("Using multiplication of %u.\n", val);
        }
        break;
      case 'd': //Output multipliers, with 2 values
        i+=2;
        if(i >= argc)
        {
          printf("Need two multipliers!\n");
        }
        else
        {
          val1 = (uint32_t)strtol(argv[i-1], NULL, 10);
          val2 = (uint32_t)strtol(argv[i], NULL, 10);
          val = (val2 << 16) + val1;
          *((uint32_t *)(set + DAC_MULT_OFF)) = val;
          printf("Setting DAC multipliers to %u and %u.\n", val1, val2);
        }
        break;
      case 'p': //Phase lead
        i++;
        if(i >= argc)
        {
          printf("No phase lead given!\n");
        }
        else
        {
          input = atof(argv[i]);
          input1 = fmod(input,360.0);
          if(input1 < 0){
            input1 += 360.0;
          }
          val = (uint32_t)(input1/lead_step);
          *((uint32_t *)(set + LEAD_OFF)) = val;
          printf("Setting modulation phase lead to %G deg.\n", input1);
          printf("Using offset of %u.\n", val);
        }
        break;
      case 'r': //Sampling rate in Hz
        i++;
        if(i >= argc)
        {
          printf("No rate given!\n");
        }
        else
        {
          input = atof(argv[i]);
          val = (uint32_t)(input/samp_step);
          *((uint32_t *)(set + SAMP_OFF)) = val;
          printf("Setting sampling frequency to %G Hz.\n", input);
          printf("Using counter incremement of %u.\n", val);
        }
        break;
      case 'x': //standalone sync command
        //Deal with reset/sync - in logic reset is done when it changes the bit value, but want the user to enter 1 to send a sync. Master unit only
        old_val = *((uint32_t *)(set + MODE_OFF));
        //Bit flip the mode bit for syncing
        val = old_val^RES_VAL;
        *((uint32_t *)(set + MODE_OFF)) = val;
        printf("Sending sync command!\n");
        printf("Old value: %u, new value: %u\n", old_val, val);
        break;
      case 'h': //Manual
        display_manual();
        break;
      default:
        printf("Unrecognised setting \"%c\"! See \"%s h\" for available commands.\n", argv[i][0], argv[0]);
    }
  }
  return 0;
}

double pow2(int bits)
{
  int i;
  double out = 1.;
  
  for(i = 0; i < bits; i++)
  {
    out*=2.;
  }
  
  return out;
}

void display_manual()
{
  FILE *file;
  int c;
  file = fopen("manual.txt","r");
  if(file)
  {
    while((c=getc(file)) != EOF)
    {
      putchar(c);
    }
  }
  fclose(file);
  printf("\n");
}