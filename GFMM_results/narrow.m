function NB = narrow(theta,c)
    s = size(theta);
    NB = zeros(s);
    tmp = theta.*c;
    for i = 2:s(1)-1
        for j = 2:s(2)-1
            if tmp(i,j) < 0 && (theta(i,j) == -theta(i+1,j) || theta(i,j) == -theta(i-1,j) || theta(i,j) == -theta(i,j+1) || theta(i,j) == -theta(i,j-1))
                NB(i,j) = 1;
            end
        end
    end

end