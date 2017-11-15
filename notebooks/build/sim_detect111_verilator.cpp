#include "Vdetect111.h"
#include "verilated.h"
#include <cassert>
#include <iostream>

void check(const char* port, int a, int b, int cycle) {
    if (!(a == b)) {
        std::cerr << "Got      : " << a << std::endl;
        std::cerr << "Expected : " << b << std::endl;
        std::cerr << "Cycle    : " << cycle << std::endl;
        std::cerr << "Port     : " << port << std::endl;
        exit(1);
    }
}

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    Vdetect111* top = new Vdetect111;
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 0);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 1);
    top->I = 0;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 2);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 3);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 4);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 1, 5);
    top->I = 0;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 6);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 7);
    top->I = 0;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 8);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 9);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 0, 10);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 1, 11);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 1, 12);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 1, 13);
    top->I = 1;
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->eval();
    check("O", top->O, 1, 14);
}
