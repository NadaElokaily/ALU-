
module TwoOneMux (output /*reg*/ z, input x,y,sel);

not(w1 ,sel);
and(w2,w1,x);
and(w3,sel,y);
or(z,w2,w3);

/*   assign z =(~sel *~y*x)+(~sel*y*x)+(sel*y*x)+(sel*y*x);*/

/*always@ (x or y or sel)
begin
if (sel ==0)
begin
z=x;

end 

else if (sel ==1)
begin 
z=y;

end 

else 
begin
z= 1'bx;

end 

end */
endmodule

module OurTwoOneTestbench;
reg x, y,sel;
wire z;
initial
begin
$monitor ("%b %b %b %b", x, y, sel, z);
#5 
sel =0;
x=0;
y=1;

#5 
x=1;
y=0;

#5 
sel = 1;

#5
x=0;
y=1;



end 

TwoOneMux M1(z,x,y,sel);
endmodule 

