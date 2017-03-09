WITH RECURSIVE
  shares(coll_id, coll_name) AS (
    SELECT coll_id, coll_name FROM r_coll_main where coll_name = '/iplant/home/shared'
    UNION ALL
    SELECT c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN shares AS s ON c.parent_coll_name = s.coll_name)
SELECT COUNT(d.data_id), SUM(d.data_size) / 1024 ^ 4
  FROM shares AS s 
    JOIN r_data_main AS d ON s.coll_id = d.coll_id
    JOIN r_objt_access AS o ON o.object_id = d.data_id
  WHERE o.user_id = (SELECT user_id FROM r_user_main WHERE user_name = 'public')
    AND d.data_repl_num = 0;
