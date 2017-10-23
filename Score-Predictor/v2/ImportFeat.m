function feature_X = ImportFeat( file , startrow , endrow )
    feature_X = import_feature(file,startrow,endrow);
    size_feature = size(feature_X);
    % Originally the training set contained 30 features (x1 through x30)
    % Adding a zero-feature(x0) column in the features vector
    feature_X = [ones(size_feature(1,1),1),feature_X];
    % Now the Feature vector contains x0(=1) through xp i.e p+1 features
end

