function [w,h,x,y] = dimension(data,a,pic_name)


img=imread(pic_name);
row=size(img,1); column=size(img,2);

X=[data.Var2(a),data.Var4(a),data.Var6(a),data.Var8(a)];
min_x=min(X);
max_x=max(X);
Y=[data.Var3(a),data.Var5(a),data.Var7(a),data.Var9(a)];
min_y=min(Y);
max_y=max(Y);
%calculate width of the gate from the corners coordinates
w=(max_x-min_x);
%Impose an offset to the left corner so that if includes the blue frame
%from the gate, considering how close or how far the gate is from the
%camera ( bigger width, closer gate, bigger offset)
%Scale the width and height so that for each gate, the frame gets included
%in its totality
if w>165
    w=floor(1.25*(max_x-min_x));
    h=floor(1.25*(max_y-min_y));
    x=min_x-20;
    y=min_y-20;
elseif w>80
    w=floor(1.25*(max_x-min_x));
    h=floor(1.25*(max_y-min_y));
    x=min_x-10;
    y=min_y-10;
else
    w=floor(1.25*(max_x-min_x));
    h=floor(1.25*(max_y-min_y));
    x=min_x-5;
    y=min_y-5;
end

%pick the left top corner, considering it has to be inside the image size
 x= max(1,x);
 y=max(1,y);
 %After scaling the width and height, it is necessary to make sure the
 %dimensions are within the image size
 if x+w> column
     w=column-x;
 end
 if y+h> row
     h=row-y;
 end
 
end

