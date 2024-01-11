module flopre #(parameter N = 64)(
    input logic enable,
    input logic clk, reset,
    input logic [N-1:0] d,
    output logic [N-1:0] q
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 'b0;
        end else 
            if (enable == 1) begin
                q <= d; // actualizar valor.
            end
        end

endmodule