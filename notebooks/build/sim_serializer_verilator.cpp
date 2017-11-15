#include "Vserializer.h"
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
    Vserializer* top = new Vserializer;
    top->I = 0b0000000000000111000000000000011000000000000001010000000000000100;
    top->eval();
    check("O", top->O, 0b0000000000000100, 0);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000000011000000000000001000000000000000010000000000000000;
    top->eval();
    check("O", top->O, 0b0000000000000101, 1);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000000111000000000000011000000000000001010000000000000100;
    top->eval();
    check("O", top->O, 0b0000000000000110, 2);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000001011000000000000101000000000000010010000000000001000;
    top->eval();
    check("O", top->O, 0b0000000000000111, 3);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000000011000000000000100000000000000100000000000000001010;
    top->eval();
    check("O", top->O, 0b0000000000001010, 4);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000000011000000000000001000000000000000010000000000000000;
    top->eval();
    check("O", top->O, 0b0000000000010000, 5);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000000111000000000000011000000000000001010000000000000100;
    top->eval();
    check("O", top->O, 0b0000000000001000, 6);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000001011000000000000101000000000000010010000000000001000;
    top->eval();
    check("O", top->O, 0b0000000000000011, 7);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
    top->I = 0b0000000000000111000000000000011000000000000001010000000000000100;
    top->eval();
    check("O", top->O, 0b0000000000000100, 8);
    top->CLK = 0;
    top->eval();
    top->CLK = 1;
    top->eval();
}
