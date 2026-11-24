//"A" means angle in degrees and "a" means opposite (BC) side.
//1. You can use this module giving only 3 arguments for generate usable triangle, for calculation purposes you can set last variable calc=true, then giving at least two sides and one angle you can pick from SSA and SAS triangles generated in echo() output. AAS calculation is trivial and outputs only one figure or nothing, same with SSS, AAA triangles exists but have any perimeter lenght >0 you wish for, so calculation is used only for generate triangles by two sides and a angle, examples 
//triangle(a=20,b=5,c=4,A=4,B=70,C=30,calc=true); // found 5 triangles: acA abA bcB and two bcC
//triangle(20,5,4,0,70,30,true);//  found 3 triangles: bcB and two bcC
//triangle(20,5,4,0,0,30,true);// only two bcC
//2. You can add this module to project using include<path/to/triangle.scad>;
//3. Module counts all types of values not numbers as 0, and 0 used as undefined value inside, negative numbers will be converted to absolute value. triangle(4,4,4,"",1/0,[[[]]],[]); is same as triangle(a=4,b=4,c=4,A=0,B=0,C=0,calc=false); and triangle(4,4,4);
//4.Module generates a triangle on (x,y)>0 plane for safe mirroring and it's b side will be placed on Y axis for make easy rotate_extrude() calculations. List of usable formulas shown near EOF

module triangle(a,b,c,A,B,C,calc){

//1/0=inf
aa= !is_num(a)?0:abs(a)==(1/0)?0:abs(a);
bb= !is_num(b)?0:abs(b)==(1/0)?0:abs(b);
cc= !is_num(c)?0:abs(c)==(1/0)?0:abs(c);
AA= !is_num(A)?0:abs(A)==(1/0)?0:abs(A);
BB= !is_num(B)?0:abs(B)==(1/0)?0:abs(B);
CC= !is_num(C)?0:abs(C)==(1/0)?0:abs(C);
calculator= is_bool(calc)?calc:false;

//sides and angles counter
boolean_vec=[[!aa?0:1,!bb?0:1,!cc?0:1],
             [!AA?0:1,!BB?0:1,!CC?0:1]]; 
angles_c=boolean_vec[1]*[1,1,1];
sides_s=boolean_vec[0]*[1,1,1];
angles_s= sides_s==3?0:
							(sides_s==2)&&(angles_c>=1)?1:
							(sides_s==1)&&(angles_c==2)?2:0;

angles= calculator?1:angles_s;
sides= calculator?2:sides_s; 

a=aa; b=bb; c=cc;

A= calculator?AA:
   angles_s==1?AA:
   angles_s==2&&(A&&B&&!C)||(A&&C&&!B)?AA:0; 
B= calculator?BB:
   angles_s==1&&!AA?BB:
   angles_s==2&&(A&&B&&!C)||(B&&C&&!A)?BB:0;
C= calculator?CC:
   angles_s==1&&!BB&&!AA?CC:
   angles_s==2&&(B&&C&&!A)||(A&&C&&!B)?CC:0;

//SSS

if (sides==3&&!calculator) {
 A=acos((c*c+b*b-a*a)/(2*c*b));
 B=acos((a*a+c*c-b*b)/(2*a*c));
 C=acos((a*a+b*b-c*c)/(2*a*b));
	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	
 area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);	
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
//AhA=[CAB,[A<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]]; 
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];
//ChC=[ACB,[C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}

//SAA
if ((angles==2)&&(sides==1)&&!calculator){

 A1= A==0?180-C-B:A;
 B1= B==0?180-C-A:B;
 C1= C==0?180-A-B:C;

 a1= (b!=0)?(b*sin(A1)/sin(B1)):(c!=0)?(c*sin(A1)/sin(C1)):a;
 b1= (a!=0)?(sin(B1)*a)/sin(A1):(c!=0)?(c*sin(B1)/sin(C1)):b;
 c1= (a!=0)?(a*sin(C1)/sin(A1)):(b!=0)?(b*sin(C1)/sin(B1)):c;

	s=(a1+b1+c1)/2;
 hA=b1*sin(C1);
 hB=c1*sin(A1);
 hC=a1*sin(B1); 	area=0.5*b1*hB;
 lA=sqrt(b1*c1*(b1+c1+a1)*(b1+c1-a1))/(b1+c1);
 lB=sqrt(a1*c1*(a1+c1+b1)*(a1+c1-b1))/(a1+c1);
 lC=sqrt(a1*b1*(a1+b1+c1)*(a1+b1-c1))/(a1+b1);
 mA=sqrt((2*b1*b1+2*c1*c1-a1*a1)/4);
 mB=sqrt((2*a1*a1+2*c1*c1-b1*b1)/4);
 mC=sqrt((2*b1*b1+2*a1*a1-c1*c1)/4); 
 circumradius=(a1*b1*c1)/(4*area);
 innerradius=area/s;
 su=A1+B1+C1;

if(
			(a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
			(ceil(su)==180||floor(su)==180)&&
			(A1>0&&A1<=90&&B1>0&&B1<180&&C1>0&&C1<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c1*c1-hB*hB)],[0,b1]]);

if(
   (a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
   (ceil(su)==180||floor(su)==180)&&
   (A1>90&&A1<180&&B1>0&&B1<180&&C1>0&&C1<180)&&
   !calculator) 	 
 translate ([0,sqrt(c1*c1-hB*hB)]) polygon([[0,0],[hB,-sqrt(c1*c1-hB*hB)],[0,b1]]); 

CAB=[0,0];
ABC=[hB,sqrt(a1*a1-hB*hB)];
ACB=[0,b1];
BhB=[ABC,[0,C<90?b1-sqrt(c1*c1-hB*hB):b1+sqrt(c1*c1-hB*hB)]];

 echo(str("\rsides: a=CB=",a1,", b=AC=",b1,", c=AB=",c1,
", \rangles: A=",A1,chr(176),CAB,", B=",B1,chr(176),ABC,", C=",C1,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,
", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}


//SAS
if ((angles==1)&&(sides==2)&&((b!=0)&&(c!=0)&&(A!=0))) {

a1= ((b!=0)&&(c!=0)&&(A!=0))?sqrt(c*c+b*b-2*c*b*cos(A)):a;
b1= b;
c1= c;

A1= A; 
B1= acos((a1*a1+c1*c1-b1*b1)/(2*a1*c1)); 
C1= acos((a1*a1+b1*b1-c1*c1)/(2*a1*b1)); 

	s=(a1+b1+c1)/2;
 hA=b1*sin(C1);
 hB=c1*sin(A1);
 hC=a1*sin(B1); 	area=0.5*b1*hB;
 lA=sqrt(b1*c1*(b1+c1+a1)*(b1+c1-a1))/(b1+c1);
 lB=sqrt(a1*c1*(a1+c1+b1)*(a1+c1-b1))/(a1+c1);
 lC=sqrt(a1*b1*(a1+b1+c1)*(a1+b1-c1))/(a1+b1);
 mA=sqrt((2*b1*b1+2*c1*c1-a1*a1)/4);
 mB=sqrt((2*a1*a1+2*c1*c1-b1*b1)/4);
 mC=sqrt((2*b1*b1+2*a1*a1-c1*c1)/4); 
 circumradius=(a1*b1*c1)/(4*area);
 innerradius=area/s;
 su=A1+B1+C1;


if(
			(a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
			(ceil(su)==180||floor(su)==180)&&
			(A1>0&&A1<=90&&B1>0&&B1<180&&C1>0&&C1<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c1*c1-hB*hB)],[0,b1]]);

if(
   (a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
   (ceil(su)==180||floor(su)==180)&&
   (A1>90&&A1<180&&B1>0&&B1<180&&C1>0&&C1<180)&&
   !calculator) 	 
 translate ([0,sqrt(c1*c1-hB*hB)]) polygon([[0,0],[hB,-sqrt(c1*c1-hB*hB)],[0,b1]]); 

CAB=[0,0];
ABC=[hB,sqrt(a1*a1-hB*hB)];
ACB=[0,b1];
BhB=[ABC,[0,C<90?b1-sqrt(c1*c1-hB*hB):b1+sqrt(c1*c1-hB*hB)]];

 echo(str("\rsides: a=CB=",a1,CAB,", b=AC=",b1,ABC,", c=AB=",c1,ACB,
", \rangles: A=",A1,chr(176),", B=",B1,chr(176),", C=",C1,chr(176),
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,
", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}

if ((angles==1)&&(sides==2)&&((a!=0)&&(c!=0)&&(B!=0))) {

a1= a;
b1= sqrt(a*a+c*c-2*a*c*cos(B));
c1= c;

A1= acos((c1*c1+b1*b1-a1*a1)/(2*c1*b1)); 
B1= B; 
C1= acos((a1*a1+b1*b1-c1*c1)/(2*a1*b1)); 

	s=(a1+b1+c1)/2;
 hA=b1*sin(C1);
 hB=c1*sin(A1);
 hC=a1*sin(B1); 	area=0.5*b1*hB;
 lA=sqrt(b1*c1*(b1+c1+a1)*(b1+c1-a1))/(b1+c1);
 lB=sqrt(a1*c1*(a1+c1+b1)*(a1+c1-b1))/(a1+c1);
 lC=sqrt(a1*b1*(a1+b1+c1)*(a1+b1-c1))/(a1+b1);
 mA=sqrt((2*b1*b1+2*c1*c1-a1*a1)/4);
 mB=sqrt((2*a1*a1+2*c1*c1-b1*b1)/4);
 mC=sqrt((2*b1*b1+2*a1*a1-c1*c1)/4); 
 circumradius=(a1*b1*c1)/(4*area);
 innerradius=area/s;
 su=A1+B1+C1;


if(
			(a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
			(ceil(su)==180||floor(su)==180)&&
			(A1>0&&A1<=90&&B1>0&&B1<180&&C1>0&&C1<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c1*c1-hB*hB)],[0,b1]]);

if(
   (a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
   (ceil(su)==180||floor(su)==180)&&
   (A1>90&&A1<180&&B1>0&&B1<180&&C1>0&&C1<180)&&
   !calculator) 	 
 translate ([0,sqrt(c1*c1-hB*hB)]) polygon([[0,0],[hB,-sqrt(c1*c1-hB*hB)],[0,b1]]); 

CAB=[0,0];
ABC=[hB,sqrt(a1*a1-hB*hB)];
ACB=[0,b1];
BhB=[ABC,[0,C<90?b1-sqrt(c1*c1-hB*hB):b1+sqrt(c1*c1-hB*hB)]];

 echo(str("\rsides: a=CB=",a1,CAB,", b=AC=",b1,ABC,", c=AB=",c1,ACB,
", \rangles: A=",A1,chr(176),", B=",B1,chr(176),", C=",C1,chr(176),
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,
", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}

if ((angles==1)&&(sides==2)&&((a!=0)&&(b!=0)&&(C!=0))) {

a1= a;
b1= b;
c1= sqrt(a*a+b*b-2*a*b*cos(C));

A1= acos((c1*c1+b1*b1-a1*a1)/(2*c1*b1)); 
B1= acos((a1*a1+c1*c1-b1*b1)/(2*a1*c1)); 
C1= C; 

	s=(a1+b1+c1)/2;
 hA=b1*sin(C1);
 hB=c1*sin(A1);
 hC=a1*sin(B1); 	area=0.5*b1*hB;
 lA=sqrt(b1*c1*(b1+c1+a1)*(b1+c1-a1))/(b1+c1);
 lB=sqrt(a1*c1*(a1+c1+b1)*(a1+c1-b1))/(a1+c1);
 lC=sqrt(a1*b1*(a1+b1+c1)*(a1+b1-c1))/(a1+b1);
 mA=sqrt((2*b1*b1+2*c1*c1-a1*a1)/4);
 mB=sqrt((2*a1*a1+2*c1*c1-b1*b1)/4);
 mC=sqrt((2*b1*b1+2*a1*a1-c1*c1)/4); 
 circumradius=(a1*b1*c1)/(4*area);
 innerradius=area/s;
 su=A1+B1+C1;


if(
			(a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
			(ceil(su)==180||floor(su)==180)&&
			(A1>0&&A1<=90&&B1>0&&B1<180&&C1>0&&C1<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c1*c1-hB*hB)],[0,b1]]);

if(
   (a1<=(b1+c1))&&(c1<=(a1+b1))&&(b1<=(c1+a1))&&
   (ceil(su)==180||floor(su)==180)&&
   (A1>90&&A1<180&&B1>0&&B1<180&&C1>0&&C1<180)&&
   !calculator) 	 
 translate ([0,sqrt(c1*c1-hB*hB)]) polygon([[0,0],[hB,-sqrt(c1*c1-hB*hB)],[0,b1]]); 

CAB=[0,0];
ABC=[hB,sqrt(a1*a1-hB*hB)];
ACB=[0,b1];
BhB=[ABC,[0,C<90?b1-sqrt(c1*c1-hB*hB):b1+sqrt(c1*c1-hB*hB)]];

 echo(str("\rsides: a=CB=",a1,CAB,", b=AC=",b1,ABC,", c=AB=",c1,ACB,
", \rangles: A=",A1,chr(176),", B=",B1,chr(176),", C=",C1,chr(176),
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,
", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
//SSA 1 solution
if((sides==2&&angles==1)&&//acA
							(((a!=0)&&(c!=0)&&(A!=0))&&
							((A>=90&&a>c)||(A<90&&a>=c)||
							((A<90)&&(a<c)&&(sin(A)==(a/c)))))){

 C=asin(c*sin(A)/a);
 B=180-C-A;
 b=sqrt(a*a+c*c-2*a*c*cos(B));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;


if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}


if((sides==2&&angles==1)&&//abA
       (((a!=0)&&(b!=0)&&(A!=0))&&
       ((A>=90&&a>b)||(A<90&&a>=b)||
							((A<90)&&(a<b)&&(sin(A)==(a/b)))))){

B=  asin((b*sin(A))/a);
C=  180-A-B;
c=  sqrt(a*a+b*b-2*a*b*cos(C));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
  


if ((sides==2&&angles==1)&&//cbB
        (((c!=0)&&(b!=0)&&(B!=0))&&
        ((B>=90&&b>c)||(B<90&&b>=c)||
        ((B<90)&&(b<c)&&(sin(B)==(b/c)))))){

C= asin((c*sin(B))/b);
A= 180-B-C;
a= sqrt(c*c+b*b-2*c*b*cos(A));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
  


if ((sides==2&&angles==1)&&//abB
        (((a!=0)&&(b!=0)&&(B!=0))&&
								((B>=90&&b>a)||(B<90&&b>=a)||
        ((B<90)&&(b<a)&&(sin(B)==(b/a)))))) {

 A=	asin((a*sin(B))/b);
 C=	180-A-B;
 c= sqrt(a*a+b*b-2*a*b*cos(C));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
  


if ((sides==2&&angles==1)&&//acC
        (((a!=0)&&(c!=0)&&(C!=0))&&
        ((C>=90&&c>a)||(C<90&&c>=a)||
        ((C<90)&&(c<a)&&(sin(C)==(c/a)))))) {

 A=	asin((a*sin(C))/c);
 B= 180-A-C;
 b=	sqrt(a*a+c*c-2*a*c*cos(B));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
  


if ((sides==2&&angles==1)&&//cbC
        (((c!=0)&&(b!=0)&&(C!=0))&&
        ((C>=90&&c>b)||(C<90&&c>=b)||
								((C<90)&&(c<b)&&(sin(C)==(c/b)))))){

	B=  asin((b*sin(C))/c);
	A=  180-B-C;
 a=  (sin(A)*b)/sin(B);

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
  


//SSA 2 solutions


if ((sides==2&&angles==1)&&//acA
   ((a!=0)&&(c!=0)&&(A!=0))&&
   ((A<90)&&(a<c)&&(sin(A)<(a/c)))) {

 b=	c*cos(A)-sqrt(a*a-c*c*sin(A)*sin(A));
 b2=c*cos(A)+sqrt(a*a-c*c*sin(A)*sin(A));
 B=	acos((a*a+c*c-b*b)/(2*a*c));
 B2=acos((a*a+c*c-b2*b2)/(2*a*c));
 C=	180-A-B;
 C2=180-A-B2;

 echo(str("\rfound 2 triangles, second values are: \rsides: a=CB=", a,", b=AC=",b2,", c=AB=",c, ", \rangles: A=",A,chr(176),"B=",B2,chr(176),"C=",C2,chr(176),", \rshowing one with smallest perimeter."));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}



if ((sides==2&&angles==1)&&//abA
  	((a!=0)&&(b!=0)&&(A!=0))&&
	  ((A<90)&&(a<b)&&(sin(A)<(a/b)))) {

 c= b*cos(A)-sqrt(a*a-b*b*sin(A)*sin(A));
 c2= b*cos(A)+sqrt(a*a-b*b*sin(A)*sin(A));
 B= acos((a*a+c*c-b*b)/(2*a*c));
 B2= acos((a*a+c2*c2-b*b)/(2*a*c));
 C= 180-A-B;
 C2= 180-A-B2;

 echo(str("\rfound 2 triangles, second values are: \rsides: a=CB=", a,", b=AC=",b,", c=AB=",c2, ", \rangles: A=",A,chr(176),"B=",B2,chr(176),"C=",C2,chr(176),", \rshowing one with smallest perimeter."));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}



if ((sides==2&&angles==1)&&//cbB
        ((c!=0)&&(b!=0)&&(B!=0))&&
        ((B<90)&&(b<c)&&(sin(B)<(b/c)))) {
 a=	 c*cos(B)-sqrt(b*b-c*c*sin(B)*sin(B));
 a2=	c*cos(B)+sqrt(b*b-c*c*sin(B)*sin(B));
 A= 	acos((c*c+b*b-a*a)/(2*c*b));
 A2=	acos((c*c+b*b-a2*a2)/(2*c*b));
 C= 	180-B-A;
 C2=	180-B-A2;

 echo(str("\rfound 2 triangles, second values are: \rsides: a=CB=", a2,", b=AC=",b,", c=AB=",c, ", \rangles: A=",A2,chr(176),"B=",B,chr(176),"C=",C2,chr(176),", \rshowing one with smallest perimeter."));
	
	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
	


if ((sides==2&&angles==1)&&//abB
        ((a!=0)&&(b!=0)&&(B!=0))&&
								((B<90)&&(b<a)&&(sin(B)<(b/a)))) {

 c=  a*cos(B)-sqrt(b*b-a*a*sin(B)*sin(B));
	c2= a*cos(B)+sqrt(b*b-a*a*sin(B)*sin(B));
	A=  acos((c*c+b*b-a*a)/(2*c*b));
	A2= acos((c2*c2+b*b-a*a)/(2*c2*b));
	C=  180-A-B;
	C2= 180-A2-B;
 echo(str("\rfound 2 triangles, second values are: \rsides: a=CB=", a,", b=AC=",b,", c=AB=",c2, ", \rangles: A=",A2,chr(176),"B=",B,chr(176),"C=",C2,chr(176),", \rshowing one with smallest perimeter."));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
	


if ((sides==2&&angles==1)&&//acC
        ((a!=0)&&(c!=0)&&(C!=0))&&
        ((C<90)&&(c<a)&&(sin(C)<(c/a)))){
 
	b=		a*cos(C)-sqrt(c*c-a*a*sin(C)*sin(C));
	b2=	a*cos(C)+sqrt(c*c-a*a*sin(C)*sin(C));
	A=	 acos((c*c+b*b-a*a)/(2*c*b));
	A2=	acos((c*c+b2*b2-a*a)/(2*c*b2));
	B=	 180-A-C;
	B2=	180-A2-C;
 echo(str("\rfound 2 triangles, second values are: \rsides: a=CB=", a,", b=AC=",b2,", c=AB=",c, ", \rangles: A=",A2,chr(176),"B=",B2,chr(176),"C=",C,chr(176),", \rshowing one with smallest perimeter."));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B); 	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
	


if ((sides==2&&angles==1)&&//cbC
        ((c!=0)&&(b!=0)&&(C!=0))&&
	       ((C<90)&&(c<b)&&(sin(C)<(c/b)))){

 a=  b*cos(C)-sqrt(c*c-b*b*sin(C)*sin(C));
	a2= b*cos(C)+sqrt(c*c-b*b*sin(C)*sin(C));
	A=  acos((c*c+b*b-a*a)/(2*c*b));
	A2= acos((c*c+b*b-a2*a2)/(2*c*b));
	B=  180-C-A;
	B2= 180-C-A2;

	echo(str("\rfound 2 triangles, second values are: \rsides: a=CB=", a2,", b=AC=",b,", c=AB=",c, ", \rangles: A=",A2,chr(176),"B=",B2,chr(176),"C=",C,chr(176),", \rshowing one with smallest perimeter."));

	s=(a+b+c)/2;
 hA=b*sin(C);
 hB=c*sin(A);
 hC=a*sin(B);
	area=0.5*b*hB;
 lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
 lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
 lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
 mA=sqrt((2*b*b+2*c*c-a*a)/4);
 mB=sqrt((2*a*a+2*c*c-b*b)/4);
 mC=sqrt((2*b*b+2*a*a-c*c)/4);
 circumradius=(a*b*c)/(4*area);
 innerradius=area/s;
 su=A+B+C;

if(
			(a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
			(ceil(su)==180||floor(su)==180)&&
			(A>0&&A<=90&&B>0&&B<180&&C>0&&C<180)&&
			!calculator) 
 polygon([[0,0],[hB,sqrt(c*c-hB*hB)],[0,b]]);

if(
   (a<=(b+c))&&(c<=(a+b))&&(b<=(c+a))&&
   (ceil(su)==180||floor(su)==180)&&
   (A>90&&A<180&&B>0&&B<180&&C>0&&C<180)&&
   !calculator) 	 
 translate ([0,sqrt(c*c-hB*hB)]) polygon([[0,0],[hB,-sqrt(c*c-hB*hB)],[0,b]]); 

CAB=[0,0];
ABC=[hB,sqrt(a*a-hB*hB)];
ACB=[0,b];
BhB=[ABC,[0,C<90?b-sqrt(c*c-hB*hB):b+sqrt(c*c-hB*hB)]];

 echo(str("\rsides: a=CB=",a,", b=AC=",b,", c=AB=",c,
", \rangles: A=",A,chr(176),CAB,", B=",B,chr(176),ABC,", C=",C,chr(176),ACB,
", \rmedians: A to a=",mA,", B to b=",mB,", C to c=",mC,
", \raltitudes: A to a=",hA,", B to b=",hB,BhB,", C to c=",hC,
", \rbisectors: A to a=",lA,", B to b=",lB,", C to c=",lC,
", \rcircumradius=",circumradius,", \rinnerradius=",innerradius,
", \rarea of the triangle=",area,"\r"));}
  

else if ((sides+angles)<3||(sides==0&&angles==0)) echo ("give at least 3 sides, side and two angles, two sides and angle");
else if (abs(A)+abs(B)+abs(C)>180) echo("summ of given angles are over 180, this is not a valid triangle");
}


//this is small list of usable formulaes, not all of them is checked as safe for work.

//Heron's formula  
//s=(a+b+c)/2;
 
//sides
//a=(2/3)*sqrt(mB*mB+mC*mC-mA*mA);
//a=sqrt(2*(b*b+c*c)-4*mA*mA);
//a=sqrt((b*b)/2-c*c+2*mB*mB);
//a=sqrt((c*c)/2-b*b+2*mC*mC);
//a=sqrt(c*c+b*b-2*c*b*cos(A));
//a=(sin(A)*b)/sin(B);
//a=(sin(A)*c)/sin(C);
//a=hC/sin(B);
//a=hB/sin(C);
//b=(2/3)*sqrt(mA*mA+mC*mC-mB*mB);
//b=sqrt(2*(a*a+c*c)-4*mB*mB);
//b=sqrt((a*a)/2-c*c+2*mA*mA);
//b=sqrt((c*c)/2-a*a+2*mC*mC);
//b=sqrt(a*a+c*c-2*a*c*cos(B));
//b=(sin(B)*a)/sin(A);
//b=(sin(B)*c)/sin(C);
//b=hC/sin(A);
//b=hA/sin(C);
//c=(2/3)*sqrt(mB*mB+mA*mA-mC*mC);
//c=sqrt(2*(b*b+a*a)-4*mC*mC);
//c=sqrt((b*b)/2-a*a+2*mB*mB);
//c=sqrt((a*a)/2-b*b+2*mA*mA);
//c=sqrt(a*a+b*b-2*a*b*cos(C)); 
//c=hA/sin(B);
//c=hB/sin(A);

//angles 
//A+B+C=180;
//A=acos((c*c+b*b-a*a)/(2*c*b));
//A=asin((a*sin(B))/b);
//A=asin((a*sin(C))/c);
//A=asin(hC/b);
//A=asin(hB/c);
//A=180-C-B;
//B=acos((a*a+c*c-b*b)/(2*a*c));
//B=asin((b*sin(A))/a);
//B=asin((b*sin(C))/c);
//B=asin(hC/a);
//B=asin(hA/c);
//B=asin(hA/(hB/sin(A));
//B=180-A-C;
//C=acos((a*a+b*b-c*c)/(2*a*b));
//C=asin((c*sin(B))/b);
//C=asin((c*sin(A))/a);
//C=asin(hA/b);
//C=asin(hB/a);
//C=180-A-B;

//medians
//mA=sqrt((2*b*b+2*c*c-a*a)/4);
//mB=sqrt((2*a*a+2*c*c-b*b)/4);
//mC=sqrt((2*b*b+2*a*a-c*c)/4);

//area of triangle
//area=0.5*a*b*sin(C)
//area=0.5*a*c*sin(B)
//area=0.5*c*b*sin(A)
//area=0.5*a*hA
//area=0.5*b*hB
//area=0.5*c*hC
//area=sqrt(s*(s-a)*(s-b)*(s-c));

//altitude
//hA=b*sin(C);
//hA=c*sin(B);
//hA=(b*c)/(2*circumradius);
//hB=a*sin(C);
//hB=c*sin(A);
//hA=(a*c)/(2*circumradius);
//hC=b*sin(A);
//hC=a*sin(B);
//hA=(b*a)/(2*circumradius);

//angle bisector line lenght
//lA=sqrt(b*c*(b+c+a)*(b+c-a))/(b+c);
//lA=2*sqrt(b*c*s*(s-a))/(b+c);
//lA=(2*b*c*cos(A/2))/(b+c);
//lA=hA/cos((B-C)/2);;
//lB=sqrt(a*c*(a+c+b)*(a+c-b))/(a+c);
//lB=2*sqrt(a*c*s*(s-b))/(a+c);
//lB=(2*a*c*cos(B/2))/(a+c);
//lB=hB/cos((A-C)/2); 
//lC=(с*sin(A)*sin(B))/(sin(A+B)*cos((A-B)/2));
//lC=sqrt(a*b*(a+b+c)*(a+b-c))/(a+b); 
//lC=(2*sqrt(a*b*s*(s-c)))/(a+b);
//lC=(2*a*b*cos(C/2))/(a+b);
//lC=hC/cos((A-B)/2);

//circumradius is a radius of outer triangle circle
//circumradius=a/(2*sin(A));
//circumradius=b/(2*sin(B));
//circumradius=c/(2*sin(C));
//circumradius=(a*b*c)/(4*area);

//inner circle radius 
//innerradius=area/s;
//innerradius=sqrt(((s-a)*(s-b)*(s-c))/s);

//sinus
//a/sin(A)=b/sin(B)=c/sin(C);
//sin(A)=(sin(B)/b)*a;
//sin(A)=(sin(C)/c)*a;
//sin(B)=(sin(C)/c)*b;
//sin(B)=(sin(A)/a)*b;
//sin(C)=(sin(B)/b)*c;
//sin(C)=(sin(A)/a)*c;

//cosinus
//cos(A)=(b*b+c*c-a*a)/2*b*c; 
//cos(B)=(c*c+a*a-b*b)/2*c*a; 
//cos(C)=(a*a+b*b-c*c)/2*a*b; 

//can be solution for
//abc --- SSS
//Abc,Bca,Cab -.- SAS
//CAc,ABa,ABb,BCb,CAa,BCc ..- AAS
//CAb,ABc,CBa .-. AAS
//Bcb,Cca,Aba,Ccb,Aca,Bab .-- ASS
//mAcb,mBac,mCba -m-
//lAcb,lBac,lCba -l-
//hAcb,hBac,hCab -h-
//hACa,hABa,hBAb,hBCb,hCBc,hCAc h!.-
//hAmAa,hBmBb,hCmCc hm!-
//lAAa,lBBb,lCCc l.!-
//mAmBmC mmm
//lAAb,lAAc, lBBa,lBBc, lCCa,lCCb l.-
//mAbc,mBac,mCab -m- 
//mAAb,mAAc,mBBa, mBBc, mCCa, mCCb m.-
//find more byself
//hi b4cksp4ce
//Kivi Reactoplast, 2021 04 02, this is public domain