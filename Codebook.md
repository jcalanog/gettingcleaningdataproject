The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

The logic behind:
=================
In order to make sense of the above datasets, this has to be approached as if the files were done in separate tables of a database. From there, everything starts to come together, and implementation of merge datasets (or in SQL, through JOINs). To better organize and promote this thought, files are loaded into R by scope - subject, activity. 

The difficult part of this is where the features would have applied in the overall scheme of things. But that becomes apparent later on once we get the full picture. 

The steps needing to be done: 
=============================
This project is a lot harder than expected, mainly attributing it how the data files are organized. Once that is figured out, however, it is rather straight-forward and complexity only starts to happen again with the column search as well as the final aggregation calculation needing to be done. 

In itself, this code is not in its best form, and could be optimized later if needed. 

Here are the steps :
1. EVALUATE AND ANALYZE THE FILE ORGANIZATION. 
I figured this would be the most important step in doing the project. This is actually the part where I took the longest while doing this project. 

2. LOAD ALL THE FILES ACCORDING TO PERCEIVED ORGRANIZATION LOGIC. 
Self-explanatory. 

3. MERGE THE DATASETS AND RENAME COLUMNS AS NECESSARY. 
Once files are loaded into memory, now we can merge datasets and organize them accordingly to how we need them. In this step, we also needed to identify what are our primary columns are as well rename the columns that we needed. 

4. PERFORM DATASET SUBSETTING TO LIMIT VIEW AND THEN PERFORM COLUMN SEARCHES FOR COLUMNS INTENDED. 
Implement the primary column subsetting and search for string pattern search through gsub (or grep) for column names. 

5. AGGREGATE COLUMNS' VALUES ACCORDING TO ACTIVITY AND SUBJECT. 
Implement the use of aggregate() function. 

6. PERSIST THE CALCULATION.
Save the calculations to file, tidy_data.txt. 