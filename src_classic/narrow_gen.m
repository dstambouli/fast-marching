function NB = narrow_gen(theta)
    s = size(theta);
    NB = zeros(s);
    for i = 2:s(1)-1
        for j = 2:s(2)-1
            if theta(i,j) == -1 && (theta(i,j) == -theta(i+1,j) || theta(i,j) == -theta(i-1,j) || theta(i,j) == -theta(i,j+1) || theta(i,j) == -theta(i,j-1))
                NB(i,j) = 1;
            end
        end
    end

end

