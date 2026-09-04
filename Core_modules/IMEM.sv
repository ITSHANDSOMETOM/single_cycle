module IMEM (
    input  logic [31:0] pc_i,
    output logic [31:0] instruction_o
);

    // Khai báo bộ nhớ: 2048 phần tử, mỗi phần tử rộng 32-bit (tổng cộng 8KB)
    logic [31:0] memory [0:2047];

    // Khởi tạo nội dung bộ nhớ từ file hex
    initial begin
        // Thay đường dẫn này bằng đường dẫn thực tế tới file isa_4b.hex của bạn trong thư mục mô phỏng
        $readmemh("isa_4b.hex", memory); 
    end

    //=======================================================
    // LOGIC ĐỌC LỆNH (FETCH INSTRUCTION)
    //=======================================================
    // Giải thích: RISC-V dùng Byte-addressing (PC tăng 0, 4, 8, 12...)
    // Nhưng mảng 'memory' của ta là Word-addressing (Index tăng 0, 1, 2, 3...)
    // Do đó, ta phải chia PC cho 4 (tương đương bỏ đi 2 bit cuối [1:0] của PC) 
    // để ánh xạ đúng vào Index của mảng.
    
    wire [29:0] word_addr = pc_i[31:2];

    // Gán tín hiệu ngõ ra (kèm điều kiện bảo vệ để tránh đọc ngoài vùng nhớ sinh ra lỗi X)
    always_comb begin
        if (word_addr < 2048) begin
            instruction_o = memory[word_addr];
        end else begin
            instruction_o = 32'h00000000; // Trả về lệnh rỗng (NOP hoặc giá trị mặc định) nếu PC văng ra ngoài
        end
    end

endmodule