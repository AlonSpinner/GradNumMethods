<<<<<<< HEAD
function P=ForwardKinematics(T)
c1=cos(T(1)); s1=sin(T(1));
c2=cos(T(2)); s2=sin(T(2));
c23=cos(T(2)+T(3)); s23=sin(T(2)+T(3));
l1=330;
l2=88;
l3=400;
l4=40;
l5=405;
A=(l2+l5*c23+l4*s23+l3*s2);
x=c1.*A;
y=s1.*A;
z=l1+l4*c23-l5*s23+l3*c2;
=======
function P=ForwardKinematics(T)
c1=cos(T(1)); s1=sin(T(1));
c2=cos(T(2)); s2=sin(T(2));
c23=cos(T(2)+T(3)); s23=sin(T(2)+T(3));
l1=330;
l2=88;
l3=400;
l4=40;
l5=405;
A=(l2+l5*c23+l4*s23+l3*s2);
x=c1.*A;
y=s1.*A;
z=l1+l4*c23-l5*s23+l3*c2;
>>>>>>> 1f5bacd0751b62c2d4ce454f2ea5112f9a054f74
P=[x y z];