WITH RECURSIVE
  homes(user_id, coll_id, coll_name) AS (
    SELECT u.user_id, c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN r_user_main AS u ON c.coll_name = '/iplant/home/' || u.user_name
      WHERE u.user_type_name = 'rodsuser'
        AND u.zone_name = 'iplant'
        AND u.user_name != 'bisque' AND u.user_name != 'coge'
    UNION ALL
    SELECT h.user_id, c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN homes AS h ON c.parent_coll_name=h.coll_name),
  files AS (
    SELECT DISTINCT h.user_id, d.data_id
      FROM homes AS h JOIN r_data_main AS d ON h.coll_id = d.coll_id)
SELECT to_char(to_timestamp(CAST(a.create_ts AS INT)), 'YYYY-MM') AS share_month,
       COUNT(a.user_id) AS share_count
  FROM files AS f JOIN r_objt_access AS a ON f.data_id = a.object_id
  WHERE f.user_id != a.user_id
    AND a.user_id != ALL(ARRAY(SELECT user_id
                                 FROM r_user_main
                                 WHERE user_type_name = 'rodsadmin'
                                   OR user_name = 'bisque'
                                   OR user_name = 'coge'
                                   OR user_name = 'rodsadmin'))
  GROUP BY share_month
  ORDER BY share_month;
