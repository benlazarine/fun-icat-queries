WITH RECURSIVE
  svcs AS (
    SELECT user_id 
      FROM r_user_group 
      WHERE group_user_id IN (SELECT user_id FROM r_user_main WHERE user_name = 'rodsadmin')
    UNION 
    SELECT user_id from r_user_main WHERE user_name = 'bisque' OR user_name = 'coge'),
  homes(user_id, coll_id, coll_name) AS (
    SELECT u.user_id, c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN r_user_main AS u ON c.coll_name = '/iplant/home/' || u.user_name
      WHERE u.user_type_name = 'rodsuser'
        AND u.zone_name = 'iplant'
        AND u.user_name != ALL(ARRAY(SELECT user_name 
                                       FROM r_user_main 
                                       WHERE user_id IN (SELECT * FROM svcs)))
    UNION ALL
    SELECT h.user_id, c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN homes AS h ON c.parent_coll_name=h.coll_name),
  files AS (
    SELECT DISTINCT h.user_id, d.data_id
      FROM homes AS h JOIN r_data_main AS d ON h.coll_id = d.coll_id)
SELECT
  (SELECT CAST(COUNT(DISTINCT f.data_id) AS REAL)
     FROM files AS f JOIN r_objt_access AS a ON f.data_id = a.object_id
     WHERE f.user_id != a.user_id AND a.user_id != ALL(ARRAY(SELECT * FROM svcs)))
  / (SELECT CAST(COUNT(*) AS REAL) FROM files);
