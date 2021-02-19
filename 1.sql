# standardSQL

WITH t1 AS (
  SELECT
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS page_location,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'web_vitals_measurement_name') AS cwv_type,
    (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'web_vitals_measurement_value') AS cwv_value,
  FROM
    `exmple.analytics_1234567890.events_20210201`
  WHERE
    event_name IN ("FID", "CLS", "LCP")
),

SELECT
  page_location,
  AVG((IF(cwv_type = "LCP", cwv_value, NULL))) AS LCP,
  AVG((IF(cwv_type = "FID", cwv_value, NULL))) AS FID,
  AVG((IF(cwv_type = "CLS", cwv_value, NULL))) AS CLS,
FROM
  t1
GROUP BY
  page_location
