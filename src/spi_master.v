module spi_master(
    input clk,
    input rst,
    input en,
    output sclk,
    output mosi,
    input miso,
    output cs,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    reg [3:0] count = 0;
    reg [7:0] shift_reg = 0;
    reg state = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            shift_reg <= 0;
            state <= 0;
            data_out <= 0;
        end else if (en) begin
            case (state)
                0: begin  // Idle state
                    cs <= 1;
                    if (count == 0) begin
                        count <= 7;
                        shift_reg <= data_in;
                        state <= 1;
                        cs <= 0;
                    end else begin
                        count <= count - 1;
                    end
                end
                1: begin  // Shift data out
                    sclk <= 0;
                    shift_reg <= {shift_reg[6:0], 1'b0};
                    state <= 2;
                end
                2: begin  // Sample data in
                    sclk <= 1;
                    data_out <= {data_out[6:0], miso};
                    if (count == 0) begin
                        state <= 0;
                    end else begin
                        count <= count - 1;
                    end
                end
            endcase
        end
    end

    assign mosi = shift_reg[7];

endmodule