WITH RECURSIVE
  shares(coll_id, coll_name) AS (
    SELECT coll_id, coll_name FROM r_coll_main where coll_name = '/iplant/home/shared'
    UNION ALL
    SELECT c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN shares AS s ON c.parent_coll_name = s.coll_name),
  files AS (
    SELECT DISTINCT d.data_id
      FROM shares AS s JOIN r_data_main AS d ON s.coll_id = d.coll_id)
SELECT COUNT(*)
  FROM files AS f JOIN r_objt_access AS a ON f.data_id = a.object_id
  WHERE a.user_id != ALL(ARRAY(SELECT user_id
                                 FROM r_user_main
                                 WHERE user_type_name = 'rodsadmin'
                                   OR user_name = 'bisque'
                                   OR user_name = 'coge'
                                   OR user_name = 'rodsadmin'));
