SELECT COUNT(*) 
  FROM r_user_main 
  WHERE user_type_name = 'rodsuser' 
    AND zone_name = 'iplant' 
    AND user_name != 'bisque' AND user_name != 'coge';
