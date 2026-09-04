module d_ff_clr_pre (
    input  logic en_i,
    input  logic clk_i,
    input  logic d_i,
    input  logic clear_i,  
    input  logic preset_i, 
    output logic q_o
);
    always_ff @(posedge clk_i or negedge clear_i or negedge preset_i) begin
        if (!clear_i) begin
            q_o <= 1'b0;
        end
        else if (!preset_i) begin
            q_o <= 1'b1;
        end
        else if (en_i) begin
            q_o <= d_i;  // Nếu en_i = 1, cho phép ghi dữ liệu mới
        end
    end
endmodule