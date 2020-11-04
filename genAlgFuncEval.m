function funcEval = genAlgFuncEval(i,varval)
%funcEval=20+varval(1,i).^2-10*cos(2*pi*varval(1,i))+varval(2,i).^2-10*cos(2*pi*varval(2,i));
funcEval=-varval(1,i)*sin(sqrt(abs(varval(1,i))))-varval(2,i)*sin(sqrt(abs(varval(2,i))));
end
