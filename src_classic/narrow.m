% Etant donné un champ de points acceptés
% Renvoi la narrow bandwidth
% en entrée on a deja une grille paddée

function NB = narrow(AP); 
	s = size(AP); 
	nb = zeros(s);

	for i = 2:s(1)-1
		for j = 2: s(2)-1
				if (AP(i,j) == 1)
						if (AP(i+1,j) ~= 1) nb(i+1,j) = 1; end;
						if (AP(i,j+1) ~= 1) nb(i,j+1) = 1; end;
						if (AP(i-1,j) ~= 1) nb(i-1,j) = 1; end;
						if (AP(i,j-1) ~= 1) nb(i,j-1) = 1; end;
			end												
		end
	end
	% on a juste a remettre des zeros dans le sbordures de NB
	NB = zeros(s);
	NB(2:end-1,2:end-1) = nb(2:end-1,2:end-1);
end