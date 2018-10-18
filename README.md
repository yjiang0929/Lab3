# CompArch Lab 3: Single Cycle CPU

The goal of this lab is to design, create, and test a 32-bit single cycle CPU.

You will work in groups of 2-3. You may shuffle teams if you so choose.

## Work Plan ##

Draft a work plan for this lab, breaking down the work in to small portions. For each portion estimate how long it will take (in hours) and when it will be done by (date). 

We strongly suggest you include a mid-point check in with course staff in your plan. One good thing to do at this check-in or earlier would be to review your block diagram.

Use your work plan reflections from the previous labs to help with this task. You will reflect on your actual path vs. the work plan at the end of the lab.

Submit by pushing `work_plan.txt` to GitHub and submitting a link on Canvas (Markdown/PDF format also OK). Include team member names in your work plan, especially if you have reshuffled.


## Processor ##

Create a 32-bit MIPS-subset CPU that supports (at least) the following instructions:

	LW, SW, J, JR, JAL, BEQ, BNE, XORI, ADDI, ADD, SUB, SLT
    
Every module of Verilog you write must be **commented and tested**.  Running assembly programs only tests the system at a high level – each module needs to be unit tested on its own with a Verilog test bench. Include a master script that runs your entire test suite.


## Programs ##

You will write, assemble and run a set of programs on your CPU that act as a high-level test-bench.  These programs need to exercise all of the portions of your design and give a clear pass/fail response.

We will work on one test program (Fibonacci) in class. In addition, you must write (at least) one test assembly program of your own. We will collect these test programs and redistribute them to all teams, so that you have a richer variety of assembly tests for your processor.

### Submitting your test program ###

Submit your assembly test(s) by GitHub pull request.

In addition to your actual test assembly code, write a short README with:
 - Expected results of the test
 - Any memory layout requirements (e.g. `.data` section)
 - Any instructions used outside the basic required subset (ok to use, but try to submit at least one test program everyone can run)

Submit the test program and README by submitting a pull request to the main course repository. Code should be in `/asmtest/<your-team-name>/` (you may use subfolders if you submit multiple tests).

After submitting your test program, you may use any of the programs written by your peers to test your processor.



## Deliverables ##

Push to GitHub and submit a link on Canvas. You should include:
 - Verilog and test benches for your processor design
 - Assembly test(s) with README 
 - Any necessary scripts
 - Report (PDF or MarkDown), including:
   - Written description and block diagram of your processor architecture. Consider including selected RTL to capture how instructions are implemented.
   - Description of your test plan and results
   - Some performance/area analysis of your design. This can be for the full processor, or a case study of choices made designing a single unit. It can be based on calculation, simulation, Vivado synthesis results, or a mix of all three.
   - Work plan reflection


Each team will also demo their work in class.
 

## Notes/Hints ##

### Design Reuse ###
You may freely reuse code created for previous labs, even code written by another team or the instructors. Reusing code does not change your obligation to understand it and provide appropriate test benches.

**Each example of reuse should be documented.** 

### Organization ###
This is a big project, and you'll benefit from (1) a well-organized repository, and (2) good scripting, expecially for testing. We'll provide an example project in class showing how to automate build and testing tasks.

### Synthesis ###
You are **not** required to implement your design on FPGA. You may want to synthesize your design (or parts of it) with Vivado to collect performance/area data.

### Assembling ###
[MARS](http://courses.missouristate.edu/kenvollmar/mars/) is a very nice assembler. It allows you to see the machine code (actual bits) of the instructions, which is useful for debugging. 


### Psuedo-Instructions ###
There are many instructions supported by MARS that aren’t "real" MIPS instructions, but instead map onto other instructions. Your processor should only implement instructions from the actual MIPS ISA (see the [Instruction Reference sheet](https://sites.google.com/site/ca16fall/resources/mips) for a complete listing).

### Initializing Memory ###
You can initialize a memory (e.g. data memory or instruction memory) from a file with `$readmemb` or `$readmemh`.  This will make your life very much easier!

For example, you could load a program into your data memory by putting your machine code in hexadecimal format in a file named `file.dat` and using something like this for your instruction memory.  

```verilog
module memory
(
  input clk, regWE,
  input[9:0] Addr,
  input[31:0] DataIn,
  output[31:0]  DataOut
);
  
  reg [31:0] mem[1023:0];  
  
  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
    end
  end
  
  initial $readmemh(“file.dat”, mem);
    
  assign DataOut = mem[Addr];
endmodule
```

You may need to fiddle with the `Addr` bus to make it fit your design, depending on how you handle the "address is always a multiple of 4" (word alignment) issue.

This memory initialization only works in simulation; it will be ignored by Vivado (which is ok).

### Memory Configuration ###

In MARS, go to "Settings -> Memory Configuration".  Changing this to "Compact, Text at Address 0" will give you a decent memory layout to start with.  This will put your program (text) at address `0`, your data at address `0x1000`, and your stack pointer will start at `0x3ffc`.

You will need to manually set your stack pointer in your Verilog simulation.  This is done automatically for you in MARS.

