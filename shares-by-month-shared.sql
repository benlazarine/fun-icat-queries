WITH RECURSIVE
  shares(coll_id, coll_name) AS (
    SELECT coll_id, coll_name FROM r_coll_main where coll_name = '/iplant/home/shared'
    UNION ALL
    SELECT c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN shares AS s ON c.parent_coll_name = s.coll_name),
  files AS (
    SELECT DISTINCT d.data_id
      FROM shares AS s JOIN r_data_main AS d ON s.coll_id = d.coll_id)
SELECT to_char(to_timestamp(CAST(create_ts AS INT)), 'YYYY-MM') AS share_month,
       COUNT(user_id) AS share_count
  FROM r_objt_access 
  WHERE objecT_id = ANY(ARRAY(SELECT DISTINCT data_id FROM files))
    AND user_id != ALL(ARRAY(SELECT user_id
                               FROM r_user_main
                               WHERE user_type_name = 'rodsadmin'
                                 OR user_name = 'bisque'
                                 OR user_name = 'coge'
                                 OR user_name = 'rodsadmin'))
  GROUP BY share_month
  ORDER BY share_month;
