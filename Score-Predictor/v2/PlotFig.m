function PlotFig( prdct_G , t_G )
    for i=1:3
        figure(i)
            plot(prdct_G(:,i), '-rs','MarkerFaceColor','r');
            hold on;
            plot(t_G(:,i) , '-go','MarkerFaceColor','g')
            xlabel('Data Set No.')
        if i==1
            ylabel('Score in G1')
        else if i == 2
                ylabel('Score in G2')
            else if i  == 3
                    ylabel('Score in G3')
                end
            end
        end
    end
end

