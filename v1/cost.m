function mycost = cost( mytheta , mytarget , feature , lambda )
    hypo = feature*mytheta;
    temp = size(feature);
    m = temp(:,1);
    mycost = (sum((hypo - mytarget).^2))/(2*m);
    
    %% ============ For regularisation ============== %%
    mytemp = size(mytheta);
    mytheta = mytheta(2:mytemp)';
    mytheta = sum(mytheta.^2);
    mycost = mycost + mytheta*lambda/m;
end

