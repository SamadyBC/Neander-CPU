module Counter (
    output reg [2:0] Count,
    input wire Clock, Reset 
);
    always @ (posedge Clock or posedge Reset)
        begin
            if (Reset)
                Count <= 0;
            else
                Count <= Count + 1;
        end
endmodule


