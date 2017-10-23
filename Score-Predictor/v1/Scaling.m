function Scaling( input, feature_X , i , m )
    mean_scal = sum(feature_X(:,i))/m;
    div = max(feature_X(:,i)) - min(feature_X(:,i));
    input(:,i) = (input(:,i) - mean_scal)/div;
end

