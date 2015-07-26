# GACD-Project

## Overall flow
run-analysis() controls the overall flow of the analysis. It starts by downloading the source data files (if necessary). Second, it reads the source data files into memory. Third, it performs transformations on some of the tables in the data set and merges them into a single table. Fourth, it aggregates the table and summarizes the data grouped by subject and activity. Lastly, the summary data is written to disk.

## Acquiring source data
initializeDataFiles() ensures that the source data is available. First it downloads the .zip file from the internet if it is missing. Second it unzips the archive if the uncompressed data is missing.

## Reading source data files
readDataFiles() reads the source data files into data frames in memory. First it reads the meta data files (namely the list of features and the list of activities). Second it reads each of the related data files (namely the x data, the y data, and the subject data) from the "test" and "train" data sets and combines each pair into a single data frame.

## Transforming source data
transformData() cleans up the individual data frames and then combines them into a single table. First, the x table is filtered down to only the columns for the mean and std variables and renames those columns with cleaner names. Second, it replace the integer values for the activity in the y table with a descriptive factor. Third, the information from the y and subject tables in appended to the x table and the y and subject tables are discarded.

## Analysing source data
analyzeData() takes the full data set and aggregates grouped by subject and activity. First, the data is aggregated by mean to the level of subject and activity. Second, the columns are reordered with subject and activity as the first and second columns.