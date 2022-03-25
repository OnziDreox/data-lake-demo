spark-submit --jars /usr/lib/spark/external/lib/spark-avro.jar,/usr/lib/hudi/hudi-utilities-bundle.jar \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 2g \
    --executor-memory 4g \
    --conf spark.sql.catalogImplementation=hive \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --class org.apache.hudi.utilities.deltastreamer.HoodieDeltaStreamer /usr/lib/hudi/hudi-utilities-bundle.jar \
    --table-type COPY_ON_WRITE \
    --source-ordering-field __source_ts_ms \
    --props "s3://bri-data-lake-demo/hudi/config/cdc_events_deltastreamer_s3.properties" \
    --source-class org.apache.hudi.utilities.sources.JsonDFSSource \
    --target-base-path "s3://bri-data-lake-demo/hudi/cdc-events/" \
    --target-table datalake.cdc_events \
    --schemaprovider-class org.apache.hudi.utilities.schema.FilebasedSchemaProvider \
    --enable-sync \
    --min-sync-interval-seconds 5 \
    --continuous \
    --op UPSERT

spark-submit --jars /usr/lib/spark/external/lib/spark-avro.jar,/usr/lib/hudi/hudi-utilities-bundle.jar \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 2g \
    --executor-memory 2g \
    --num-executors 1 \
    --conf spark.sql.catalogImplementation=hive \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --class org.apache.hudi.utilities.deltastreamer.HoodieDeltaStreamer /usr/lib/hudi/hudi-utilities-bundle.jar \
    --table-type COPY_ON_WRITE \
    --source-ordering-field __source_ts_ms \
    --props "s3://bri-data-lake-demo/hudi/config/cdc_events_deltastreamer_s3-simple.properties" \
    --source-class org.apache.hudi.utilities.sources.JsonDFSSource \
    --target-base-path "s3://bri-data-lake-demo/hudi/cdc-events-simple/" \
    --target-table datalake.cdc_events_simple \
    --schemaprovider-class org.apache.hudi.utilities.schema.FilebasedSchemaProvider \
    --enable-hive-sync \
    --min-sync-interval-seconds 5 \
    --continuous \
    --op UPSERT

aws emr add-steps \
  --cluster-id j-H3L12IB2BR0K \
  --steps file://hudi/steps/cdc-events-simple.json \
  --region ap-southeast-2

# {
#     "StepIds": [
#         "s-1590JCHMD8JJ1"
#     ]
# }