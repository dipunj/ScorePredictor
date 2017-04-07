
--------------------------------------------------------------------------------
### <center>I.  File List </center>

--------------------------------------------------------------------------------
S.no |	Name			 |	Type		   |		Task									|
-----|-----------------------|----------------------|---------------------------------------------------				|
1.   |Driver.m               |Script                |The main script file containing the main program.				|
2.   |cost.m                 |Function              |Evaluates cost.									|
3.   |expo.m                 |Function              |exponentiate a particular column of a matrix.				|
4.   |import_feature.m       |Function              |import the data from training.csv...Preprocesses the data.			|
5.   |import_target.m        |Function              |Imports the G1 G2 G3 i.e target vectors into a numeric matrix.		|
6.   |PlotFig.m              |Function              |Generates plots for the predicted and actual values for testing purposes	|
7.   |Scaling.m              |Function              |Causes a particular feature in the feature matrix to be Scaled using Normalised mean |
8.   |training.csv           |.csv(comma delimited) |Column 5 has been preprocessed according to preprocessing scheme 		|
9.   |training_set_q1.csv    |.csv(comma delimited) |The original(RAW) training file.						|
10.  |test.csv               |.csv(comma delimited) |Column 5 has been preprocessed according to preprocessing scheme.		|
11.  |test_set_q1_upload.csv |.csv(comma delimited) |The Original(RAW) test cases file.						|
12.  |output.csv             |.csv(comma delimited) |Contains 3 columns G1 predicted, G2 predicted & G3 predicted respectively.|
13.  |classifier.csv         |.csv(comma delimited) |Contains 3 columns containing parameters for G1 , G2 & G3 respectively.	|

--------------------------------------------------------------------------------
### <center>II. System Requirements</center>
--------------------------------------------------------------------------------
Software Requirements : 
	1. MATLAB R2015a or later
	2. CSV file reader (MS Excel, notepad etc)
	3. ASCII text reader
Hardware Requirements : 
	None in Specific



--------------------------------------------------------------------------------
### <center>III. Instructions</center>
--------------------------------------------------------------------------------

RUNNING THE PROGRAM
	
	1. Launch 'Driver.m'
	   Open MATLAB > Navigate to Driver.m and open it.
	2. In the command window type 'run Driver.m' (without the single quotes)
	3. Wait for the program to train the model
	4. After the program finishes to train the model.
	   The command window shall print 'TRAINING FINISHED'.


CUSTOMISING THE PROGRAM

	* Changing the Size of the training sample
	  ------------------------
		Navigate to line# 14 and 17 of the file 'Driver.m' change the last argument

	* Changing the test file
	  -----------------------
		Navigate to line# 63 and 64 of the file 'Driver.m' change the file name 'test.csv' to the file which you intend to check against,
		and set the first numerical argument to the STARTROW and second numerical argument to ENDROW of your file.

	* Changing Lambda
	 ---------------
		========== IMPORTANT =========
		If You intend to use full training set then Reset the value of lambda as follows
		In line 43 of the main script
			- Initially lambda is set to for training set (1:470) - - - - - - - - - - - - - - -: [-10,10,20] 
			- When using full training set, the values of lambda best suited are - - - - - - - -: [-10,-10,20]

	* Getting Comparision Plot
	  -----------------------
		Remove(Or better convert the lines) 82 - 96
		Decomment lines #63, #98 - #105
		make sure you provide the correct target matrix in line 63.

--------------------------------------------------------------------------------
### <center>IV. Variable Description for 'Driver.m'</center>
--------------------------------------------------------------------------------

S.No.	| Variable Name	| Description								| Initialised Value(If Applicable)
-------|--------------------|--------------------------------------------------------------|---------------------------------
1.	|	alpha		|	learning rate 						| 0.001
2.	|	ctr		|	counter							| 1
3.	|	dim		|	Dimensions of the feature matrix				| -
4.	|	feature_X	|	Feature matrix						| -
5. 	|	hypo		|	hypothesis values for each training case			| -
6.	|	i		|	counter variable of for loop				| 1
7.	|	lambda		|	regularisation constant					| -
8.	|	m		|	no. of training cases					| -
9.	|	Mean_Abs_Error|		Contains Value of the mean error			| -
10.	|	myans		|	contains alternating result					| -
11.	|	n		|	No of features in the model					| -
12.	|	prdct_G	|		contains predicted values of subjects		| -
13.	|	t_feat		|	feature matrix for unused test cases			| -
14.	|	size_t_feat	|	size of t_feat						| -
15.	|	t_G		|	target matrix for unused test cases			| -
16.	|	temp		|	temporary variable used for intermediate data handling	| -
17.	|	target_G	|	target matrix for training set				| -
18.	|	theta_G	|		parameter matrix...stores the trained parameters.| -

--------------------------------------------------------------------------------
### <center>V. Preprocessing Scheme</center>
--------------------------------------------------------------------------------

Column No. 	|	Value Input	|	Assigned to 
--------------|--------------------|---------------------
1.		|	NITA		|	1
		|	IIITA		|	0
2.		|	Female		|	1
		|	male		|	0
4.		|	Urban		|	1
		|	Rural		|	0
5.		|	GT3		|	1
		|	LE3		|	0
6.		|	T		|	1
		|	A		|	0
9.		|	other		|	0
		|	at_home	|	1
		|	health		|	2
		|	service	|	3
		|	teacher	|	4
10.		|	other		|	0
		|	at_home	|	1
		|	health		|	2
		|	service	|	3
		|	teacher	|	4
11.		|	other		|	0
		|	course		|	1
		|	home		|	2
		|	reputation	|	3
12.		|	other		|	0
		|	father		|	1
		|	mother		|	2	
16 - 23. 	|	yes		|	1
		|	No		|	0

--------------------------------------------------------------------------------
<center><b>EOF<b></center>

--------------------------------------------------------------------------------
