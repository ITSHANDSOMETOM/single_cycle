module mux_32to1(
    input  logic [31:0] d,
    input  logic [4:0]  sel,
    input  logic        en,
    output logic        y
);

    // Rút 'en' ra ngoài làm nhân tử chung cho toàn bộ 32 trường hợp
    assign y = en & (
        // Nhóm 0 - 3 (sel[4:3] = 00)
        (d[0]  & ~sel[4] & ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0]) |
        (d[1]  & ~sel[4] & ~sel[3] & ~sel[2] & ~sel[1] &  sel[0]) |
        (d[2]  & ~sel[4] & ~sel[3] & ~sel[2] &  sel[1] & ~sel[0]) |
        (d[3]  & ~sel[4] & ~sel[3] & ~sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 4 - 7
        (d[4]  & ~sel[4] & ~sel[3] &  sel[2] & ~sel[1] & ~sel[0]) |
        (d[5]  & ~sel[4] & ~sel[3] &  sel[2] & ~sel[1] &  sel[0]) |
        (d[6]  & ~sel[4] & ~sel[3] &  sel[2] &  sel[1] & ~sel[0]) |
        (d[7]  & ~sel[4] & ~sel[3] &  sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 8 - 11 (sel[4:3] = 01)
        (d[8]  & ~sel[4] &  sel[3] & ~sel[2] & ~sel[1] & ~sel[0]) |
        (d[9]  & ~sel[4] &  sel[3] & ~sel[2] & ~sel[1] &  sel[0]) |
        (d[10] & ~sel[4] &  sel[3] & ~sel[2] &  sel[1] & ~sel[0]) |
        (d[11] & ~sel[4] &  sel[3] & ~sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 12 - 15
        (d[12] & ~sel[4] &  sel[3] &  sel[2] & ~sel[1] & ~sel[0]) |
        (d[13] & ~sel[4] &  sel[3] &  sel[2] & ~sel[1] &  sel[0]) |
        (d[14] & ~sel[4] &  sel[3] &  sel[2] &  sel[1] & ~sel[0]) |
        (d[15] & ~sel[4] &  sel[3] &  sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 16 - 19 (sel[4:3] = 10)
        (d[16] &  sel[4] & ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0]) |
        (d[17] &  sel[4] & ~sel[3] & ~sel[2] & ~sel[1] &  sel[0]) |
        (d[18] &  sel[4] & ~sel[3] & ~sel[2] &  sel[1] & ~sel[0]) |
        (d[19] &  sel[4] & ~sel[3] & ~sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 20 - 23
        (d[20] &  sel[4] & ~sel[3] &  sel[2] & ~sel[1] & ~sel[0]) |
        (d[21] &  sel[4] & ~sel[3] &  sel[2] & ~sel[1] &  sel[0]) |
        (d[22] &  sel[4] & ~sel[3] &  sel[2] &  sel[1] & ~sel[0]) |
        (d[23] &  sel[4] & ~sel[3] &  sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 24 - 27 (sel[4:3] = 11)
        (d[24] &  sel[4] &  sel[3] & ~sel[2] & ~sel[1] & ~sel[0]) |
        (d[25] &  sel[4] &  sel[3] & ~sel[2] & ~sel[1] &  sel[0]) |
        (d[26] &  sel[4] &  sel[3] & ~sel[2] &  sel[1] & ~sel[0]) |
        (d[27] &  sel[4] &  sel[3] & ~sel[2] &  sel[1] &  sel[0]) |

        // Nhóm 28 - 31
        (d[28] &  sel[4] &  sel[3] &  sel[2] & ~sel[1] & ~sel[0]) |
        (d[29] &  sel[4] &  sel[3] &  sel[2] & ~sel[1] &  sel[0]) |
        (d[30] &  sel[4] &  sel[3] &  sel[2] &  sel[1] & ~sel[0]) |
        (d[31] &  sel[4] &  sel[3] &  sel[2] &  sel[1] &  sel[0])  
        // Dòng cuối cùng không có dấu |
    );

endmodule