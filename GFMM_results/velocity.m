function c = velocity(Img)
 [gx, gy] = gradient(Img);
 N = length(Img);
 c = zeros(N+2,N+2);
 c(2:end-1,2:end-1) = 1.0./(sqrt(gx.^2+gy.^2));
 %c(2:end-1,2:end-1) = (254-Img)./(sqrt(gx.^2+gy.^2));
end

