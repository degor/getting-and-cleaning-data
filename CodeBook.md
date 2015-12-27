CodeBook

## Input

The input data containts the following data files:

1. activity_labels.txt - information about activities.
2. features.txt - information about features.

3. subject_train.txt - contains information on the subjects for training.
4. subject_test.txt - contains information on the subjects for testing.

5. y_train.txt - activities for X_train.txt.
6. y_test.txt - activities for X_test.txt.

7. X_train.txt - features intended for training.
8. X_test.txt - features intended for testing.

##Modification

subjectJoined  - join result of subbject_train.txt and  subject_test.txt.
"Subject" - is the sole column name of subjectJoined.

xJoined - joined result of X_train.txt X_test.txt.
columns for x are taken from xJoined.

yJoined - joned result from  y_train.txt and y_test.txt.
"Activity" - is the sole colum name of yJoined.

joinedData - result of joining three sets subjectJoined, xJoined and yJoined.

trimmedData - result of taking filterning only columns that are contain mean and std values.

trimmedData - values of activity in final result are set to proper activities names from activity_labels.txt.
columns that start from t are modifeed to start with Time noun.
columns that start with f are modified to start with Frequency noutn.

-x -y -z in the end are update to have "on x axis", "on y axis", "on z axis" accordingly.

finally data is aggregated based on Subject and Activity columns.

##Output

The result is file tidy.txt that contains cleaned and tidy data with updated column names.