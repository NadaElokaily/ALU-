module AluMux (z,x,y,mux_ctrl);

output reg [31:0] z;
input [31:0] x,y;
input mux_ctrl; 
always@ (x or y or mux_ctrl)
begin
if (mux_ctrl ==0)
begin z=x; end 

else if (mux_ctrl ==1)
begin z=y; end 

else 
begin z= 32'bx; end 

end
endmodule



module RegisterFile ( rd1, rd2, rr1, rr2, wr, wd, we, clk);
output reg [31:0] rd1,rd2;
input [4:0] rr1,rr2,wr;
input we,clk;
input [31:0] wd;
reg [31:0] rf [7:0];

always@ (posedge clk)
begin

if (we)
begin
rf[wr] <= wd;
end

rd1 = rf[rr1];
rd2 = rf[rr2];

end

endmodule





module Alu( Result, A, B, op, shamount,sign);

output wire [31:0] Result;
input wire sign;
input wire [31:0] A,B;
input wire [3:0] op;
input wire [3:0] shamount;

assign Result = 
 (op == 4'b 0000) ? A+B 
:(op == 4'b 0001) ? A-B 
:(op == 4'b 0010) ? A&B
:(op == 4'b 0011) ? A|B
:(op == 4'b 0100) ? A<<shamount
:(op == 4'b 0101) ? A>>shamount
:(op == 4'b 0110) ? $signed($signed(A) >>> shamount)
:(op == 4'b 0111 && sign == 0) ? ((A>B)? 1:0)
:(op == 4'b 0111 && sign == 1) ? ((A>B)? 0:1)
:(op == 4'b 1000 && sign == 0) ? ((A<B)? 1:0)
:(op == 4'b 1000 && sign == 1) ? ((A<B)? 0:1)
: 32'b0000 ;

  
endmodule



module AluTB;
wire [31:0] Result;
reg [3:0] op,shamount;
reg sign;

//regfile
reg clk,we;
reg [4:0] rr1, rr2 , wr;
wire [31:0] rd1,rd2;
wire [31:0] wd;

//mux
reg mux_ctrl;

reg [31:0] WriteData;


Alu myAlu(Result, rd1, rd2, op, shamount, sign);
AluMux muxx ( wd, WriteData, Result , mux_ctrl);
RegisterFile RF( rd1, rd2, rr1, rr2, wr, wd, we, clk);



initial
begin


clk=0;
mux_ctrl =0;
sign =0;

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = -53;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
op=4'b0000;
#10
$display ("%b  plus %b  =  %b " ,rd1,rd2,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = 5;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
op=4'b0001;
#10
$display ("%b  minus %b  =  %b " ,rd1,rd2,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = 5;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
op=4'b0010;
#10
$display ("%b  and %b  =  %b " ,rd1,rd2,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = 5;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
op=4'b0011;
#10
$display ("%b  or %b  =  %b " ,rd1,rd2,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = 5;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
op=4'b0100;
#10
$display ("%b  shifted left %d  =  %b " ,rd1,shamount,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = 50;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
op=4'b0101;
#10
$display ("%b  shifted right %d  =  %b " ,rd1,shamount,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = -5;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 2;
op=4'b0110;
#10
$display ("%b  shifted right arthimetic %d  =  %b " ,rd1,shamount,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = -5;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
sign =1;
op=4'b0111;
#10
$display ("%b  greater than %b  =  %b " ,rd1,rd2,Result);

#20
we = 1 ;
mux_ctrl =0;
wr = 1 ;
WriteData = -53;
#10
wr = 2 ;
WriteData = 3;
#10
rr1 = 1;
rr2 = 2;
#10
shamount <= 5;
sign =1;
op=4'b1000;
#10
$display ("%b  less than %b  =  %b " ,rd1,rd2,Result);

end

always
begin
#5
clk =~clk;
end



endmodule 