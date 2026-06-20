module vga_controller (
    input wire clk,
    input wire reset_n,
    output wire hsync,
    output wire vsync,
    output wire [9:0] pixel_x,
    output wire [9:0] pixel_y,
    output wire video_on
);

    // VGA 640x480 @ 60Hz Timing Parameters
    // Pixel Clock: 25.175 MHz

    // Horizontal Timing
    localparam H_DISPLAY = 640;  // Horizontal Display Pixels
    localparam H_FRONT_PORCH = 16; // Horizontal Front Porch
    localparam H_SYNC_PULSE = 96;  // Horizontal Sync Pulse Width
    localparam H_BACK_PORCH = 48;  // Horizontal Back Porch
    localparam H_TOTAL = H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH; // Total Horizontal Pixels (800)

    // Vertical Timing
    localparam V_DISPLAY = 480;  // Vertical Display Lines
    localparam V_FRONT_PORCH = 10; // Vertical Front Porch
    localparam V_SYNC_PULSE = 2;   // Vertical Sync Pulse Width
    localparam V_BACK_PORCH = 33;  // Vertical Back Porch
    localparam V_TOTAL = V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH; // Total Vertical Lines (525)

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    // Horizontal Sync Generation
    assign hsync = (h_counter >= H_DISPLAY + H_FRONT_PORCH) && (h_counter < H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE);

    // Vertical Sync Generation
    assign vsync = (v_counter >= V_DISPLAY + V_FRONT_PORCH) && (v_counter < V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE);

    // Video On Signal
    assign video_on = (h_counter < H_DISPLAY) && (v_counter < V_DISPLAY);

    // Pixel Coordinates
    assign pixel_x = h_counter;
    assign pixel_y = v_counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            h_counter <= 0;
            v_counter <= 0;
        end else begin
            if (h_counter == H_TOTAL - 1) begin
                h_counter <= 0;
                if (v_counter == V_TOTAL - 1) begin
                    v_counter <= 0;
                end else begin
                    v_counter <= v_counter + 1;
                end
            end else begin
                h_counter <= h_counter + 1;
            end
        end
    end

endmodule
