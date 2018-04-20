module positiveComparator (A,B, CompareResult);
input wire [3:0] A,B;
output wire [1:0] CompareResult;

assign CompareResult =
   (A[3] > B[3]) ? 2'b01: (A[3] < B[3])? 2'b10
 : (A[2] > B[2]) ? 2'b01: (A[2] < B[2])? 2'b10
 : (A[1] > B[1]) ? 2'b01: (A[1] < B[1])? 2'b10
 : 2'b00;

endmodule

module SecAlu( Result, overflow, A, B, mode, op);

output wire [3:0] Result;
output wire overflow;

input wire [3:0] A,B;
input wire [2:0] op;
input mode;
//mode=0 unsigned mode=1 signed

wire [1:0] CompareResult;
positiveComparator pc (A,B, CompareResult);

wire [3:0] B_negated;
assign B_negated=-B;

assign Result = 
 (op == 3'b 000) ? A+B 
:(op == 3'b 001) ? A-B 
:(op == 3'b 010) ? A<<1
:(op == 3'b 011) ? A>>1
:(op == 3'b 100) ? A>>>1
:(op == 3'b 101) ? -A
:(op == 3'b 110) ? (/*{2{1'b0}},*/CompareResult)
: 3'b000 ;
assign overflow = 
  (mode == 1'b1 && op==3'b000 && A[3] == B[3] && Result[3] ==~A[3])? 1'b1 //+
: (mode == 1'b1 && op==3'b001 && A[3] == B_negated[3] &&Result[3] == ~A[3])? 1'b1  //-
: 1'b0;  
  

endmodule 

module AluTestBench;
reg [3:0] A,B;
reg [2:0] op;
reg mode ;
wire overflow;
wire [3:0] Result;

initial
begin
mode=1;
A<=-3;
B<=7;
op=3'b000;
$monitor ("%b %b %b %b %b" ,A,B,op,Result, overflow);
#5
op =3'b 001;
#5
B<=7;

end
SecAlu myAlu( Result, overflow, A, B, mode, op);



endmodule 