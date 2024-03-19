classdef imagini < hgsetget
    properties
        img_1;
        img_2;
        img_3;
        img_4;
        img_5;
        img_6;
        img_7;
        img_8;
        img_mina;
        img_flag;
        img_unopenedsq;
    end

    methods %constructor
        function obj=imagini()
            obj.img_1=imread('Images/unu32x32.png');
            obj.img_2=imread('Images/doi32x32.png');
            obj.img_3=imread('Images\trei32x32.png');
            obj.img_flag=imread("Images\redflag32x32.png");
            obj.img_mina=imread('Images\minesweeperbomb32x32.png');
            obj.img_4=imread('Images\patru32x32.png');
            obj.img_5=imread('Images\cinci32x32.png');
            obj.img_6=imread('Images\sase32x32.png');
            obj.img_7=imread('Images\sapte32x32.png');
            obj.img_8=imread('Images\opt32x32.png');
        end
    end
end

