// MIT License

// Copyright (c) 2020 William Won (william.won@gatech.edu)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CrossbarSwitch::*;


typedef Bit#(32) TestInt;
TestInt maxSimulationCycles = 10000;


(* synthesize *)
module mkCrossbarSwitchTest();
    // Unit under test
    // 32 x 16 crossbar (4bit output destination address), each driving 64 bits
    CrossbarSwitch#(32, 16, Bit#(4), Bit#(64)) uut <- mkCrossbarSwitch;

    // Testbench variables
    Reg#(TestInt) cycle <- mkReg(0);

    rule runSimulation;
        cycle <= cycle + 1;
    endrule

    rule finishSimulation if (cycle >= maxSimulationCycles);
        $display("[SIM] Simulation done at cycle %d", cycle);
        $finish(0);
    endrule

    rule put if (cycle == 0);
        uut.ingressPort[0].put(0, 3);
        uut.ingressPort[2].put(2, 15);
        uut.ingressPort[17].put(17, 13);
        uut.ingressPort[23].put(23, 5);
        uut.ingressPort[31].put(31, 7);
    endrule

    for (Integer i = 0; i < 16; i = i + 1) begin
        rule print;
            $display("[Cycle: %d] [Port: %d] Received %d", cycle, i, uut.egressPort[i].get);
        endrule
    end
endmodule
