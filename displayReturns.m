function displayReturns(pret0, pret, qret)
fprintf('                                   %6s    %6s\n','Gross','Net');
fprintf('Initial Portfolio Return           %6.2f %%  %6.2f %%\n',100*pret0,100*pret0);
fprintf('Return of Minimum Efficient Portfolio %6.2f %%  %6.2f %%\n',100*pret(1),100*qret(1));
fprintf('Return of Maximum Efficient Portfolio %6.2f %%  %6.2f %%\n',100*pret(2),100*qret(2));
end
