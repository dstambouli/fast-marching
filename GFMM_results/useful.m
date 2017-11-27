function U = useful(NB,theta)
    s = size(theta);
    U = zeros(s);
    
    for i = 1:s(1)
        for j = 1:s(2)
            if (NB(i,j) == 1) 
                if theta(i,j) == -theta(i+1,j)
                    U(i+1,j) = 1;
                elseif theta(i,j) == -theta(i-1,j)
                    U(i-1,j) = 1;
                elseif theta(i,j) == -theta(i,j+1)
                    U(i,j+1) = 1;   
                elseif theta(i,j) == -theta(i,j-1)
                    U(i,j-1) = 1;   
                end
            end
        end
    end
end

