#include "VSDRAMController.h"
#include "verilated.h"
#include <iostream>
#include <fstream>
#include <verilated_vcd_c.h>
#include <sys/types.h>
#include <sys/stat.h>

// Based on https://www.veripool.org/projects/verilator/wiki/Manual-verilator#CONNECTING-TO-C
vluint64_t main_time = 0;       // Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus.  You can also use a double, if you wish.

double sc_time_stamp () {       // Called by $time in Verilog
    return main_time;           // converts to double, to match
                                // what SystemC does
}

#if VM_TRACE
VerilatedVcdC* tracer;
#endif

void my_assert(
    unsigned int got,
    unsigned int expected,
    int i,
    const char* port) {
  if (got != expected) {
    std::cerr << std::endl;  // end the current line
    std::cerr << "Got      : 0x" << std::hex << got << std::endl;
    std::cerr << "Expected : 0x" << std::hex << expected << std::endl;
    std::cerr << "i        : " << std::dec << i << std::endl;
    std::cerr << "Port     : " << port << std::endl;
#if VM_TRACE
    // Dump one more timestep so we see the current values
    main_time++;
    tracer->dump(main_time);
    tracer->close();
#endif
    exit(1);
  }
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  VSDRAMController* top = new VSDRAMController;

#if VM_TRACE
  Verilated::traceEverOn(true);
  tracer = new VerilatedVcdC;
  top->trace(tracer, 99);
  mkdir("logs", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
  tracer->open("logs/SDRAMController.vcd");
#endif

  top->RESET = 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->RESET = 0;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->RESET = 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 6, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 7, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 9, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 10, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 12, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 13, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 15, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 16, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 18, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 19, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 21, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 22, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 24, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 25, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 27, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 28, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 30, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 31, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 33, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 34, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 36, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 37, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 39, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 40, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 42, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 43, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 45, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 46, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 48, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 49, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 8 & 31, 51, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 52, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 9 & 31, 54, "SDRAMController.state");
  my_assert(top->cmd, 145 & 255, 55, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 5 & 31, 57, "SDRAMController.state");
  my_assert(top->cmd, 184 & 255, 58, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  my_assert(top->state, 10 & 31, 60, "SDRAMController.state");
  my_assert(top->cmd, 136 & 255, 61, "SDRAMController.cmd");
  top->eval();
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif
  top->CLK ^= 1;
  top->eval();
  main_time++;
  #if VM_TRACE
  tracer->dump(main_time);
  #endif


#if VM_TRACE
  tracer->close();
#endif
}
