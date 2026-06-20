`timescale 1ns / 1ps

module vga_controller_tb;

    // Parameters
    parameter CLK_PERIOD = 40; // 25.175 MHz clock period (1/25.175MHz ~ 39.7ns, rounded to 40ns for simplicity)

    // Inputs
    reg clk;
    reg reset_n;

    // Outputs
    wire hsync;
    wire vsync;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_on;

    // Instantiate the Unit Under Test (UUT)
    vga_controller uut (
        .clk(clk),
        .reset_n(reset_n),
        .hsync(hsync),
        .vsync(vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on)
    );

    // Clock generation
    always begin
        clk = 1'b0;
        #(CLK_PERIOD / 2);
        clk = 1'b1;
        #(CLK_PERIOD / 2);
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset_n = 1'b0;
        #100; // Wait a bit for initial conditions

        // Release reset
        reset_n = 1'b1;
        # (CLK_PERIOD * 100000); // Run for a significant number of clock cycles to observe VGA timing

        $display("Simulation finished.");
        $stop;
    end

    // Optional: Monitor signals (for waveform viewing)
    initial begin
        $dumpfile("vga_controller.vcd");
        $dumpvars(0, vga_controller_tb);
    end

endmodule
