module spi_master (
    input wire clk,          // System clock
    input wire rst_n,        // Active low reset
    input wire start,        // Start transfer signal
    input wire [7:0] data_in, // Data to send to the slave
    output reg [7:0] data_out, // Data received from the slave
    output reg done,         // Transfer complete signal
    output wire sclk,        // SPI clock
    output reg mosi,         // Master Out Slave In
    input wire miso,         // Master In Slave Out
    output reg cs            // Chip Select
);

// State definition
localparam IDLE = 2'b00,
           TRANSFER = 2'b01,
           DONE = 2'b10;

// SPI clock generation
reg [7:0] clk_div;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) clk_div <= 0;
    else clk_div <= clk_div + 1;
end
assign sclk = clk_div[7]; // Generate SPI clock, adjust divisor as needed

// SPI controller state machine
reg [1:0] state;
reg [2:0] bit_count; // To track the bits transferred

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cs <= 1'b1; // Deactivate slave
        done <= 1'b0;
        bit_count <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    cs <= 1'b0; // Activate slave
                    state <= TRANSFER;
                    bit_count <= 0;
                    done <= 1'b0;
                end
            end
            TRANSFER: begin
                if (clk_div == 8'd255) begin // SPI clock edge
                    mosi <= data_in[7 - bit_count]; // Send MSB first
                    if (bit_count != 7) begin
                        bit_count <= bit_count + 1;
                        data_out <= {data_out[6:0], miso}; // Shift in MISO
                    end else begin
                        state <= DONE;
                    end
                end
            end
            DONE: begin
                done <= 1'b1;
                cs <= 1'b1; // Deactivate slave
                state <= IDLE;
            end
        endcase
    end
end

endmodule