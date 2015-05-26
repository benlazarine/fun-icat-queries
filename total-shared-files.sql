WITH RECURSIVE
  shares(coll_id, coll_name) AS (
    SELECT coll_id, coll_name FROM r_coll_main where coll_name = '/iplant/home/shared'
    UNION ALL
    SELECT c.coll_id, c.coll_name
      FROM r_coll_main AS c JOIN shares AS s ON c.parent_coll_name = s.coll_name)
SELECT COUNT(DISTINCT d.data_id)
  FROM shares AS s JOIN r_data_main AS d ON s.coll_id = d.coll_id
