module Branch_control_unit(
  input  logic [2:0]  funct3_i,
  input  logic [31:0] a_i,
  input  logic [31:0] b_i,
  input  logic        branch_en_i,
  output logic        branch_o
);
  logic branch_internal;
  logic zero_i;
  logic less_i;
  logic less_u_i;

  // 1. So sánh bằng (BEQ / BNE)
  assign zero_i = ~|(a_i ^ b_i);
  
  // 2. Mạch so sánh không dấu (BLTU / BGEU) chạy từ MSB (31) xuống LSB (0)
  logic [32:0] u_chain;
  assign u_chain[32] = 1'b0; // Khởi tạo điểm bắt đầu ở phía trên bit cao nhất
  
  genvar i; 
  generate 
    for(i = 31; i >= 0; i = i - 1) begin: u_comp
      // Logic lan truyền từ bit cao xuống bit thấp:
      // a < b nếu tại bit i (a=0, b=1) HOẶC (a==b và các bit cao hơn đã quyết định a<b)
      assign u_chain[i] = (~a_i[i] & b_i[i]) | ((~(a_i[i] ^ b_i[i])) & u_chain[i+1]);
    end 
  endgenerate

  assign less_u_i = u_chain[0];
  
  // 3. Mạch so sánh có dấu (BLT / BGE) thuần túy bit-level
  logic diff_sign;
  assign diff_sign = a_i[31] ^ b_i[31];
  
  // - Khác dấu: Lấy trực tiếp bit dấu của a (a âm thì nhỏ hơn b dương)
  // - Cùng dấu: Kết quả chính là kết quả không dấu (less_u_i)
  assign less_i    = diff_sign ? a_i[31] : less_u_i;

  // 4. Bộ giải mã điều kiện rẽ nhánh
  always_comb begin
    case(funct3_i)  
      3'b000:  branch_internal = zero_i;
      3'b001:  branch_internal = ~zero_i;
      3'b100:  branch_internal = less_i;
      3'b101:  branch_internal = ~less_i;
      3'b110:  branch_internal = less_u_i;
      3'b111:  branch_internal = ~less_u_i;
      default: branch_internal = 1'b0;
    endcase
  end
  
  assign branch_o = branch_internal & branch_en_i;
endmodule