select * from gpxcontent;
select count(*),filename from gpxcontent group by filename;
truncate table gpxcontent;

drop table gpxcontent;

CREATE EXTENSION postgis;
----*************
ALTER TABLE gpxcontent ADD COLUMN Point geometry(Point,4326);
update gpxcontent as gc set point=(SELECT ST_MakePoint(gc.longitude, gc.latitude));

SELECT ST_MakePoint(gc.longitude, gc.latitude) as p from gpxcontent as gc;
--**********to make make the required geometry point field
UPDATE gpxcontent SET point = ST_SetSRID(ST_MakePoint(longitude::double precision, latitude::double precision), 4326) where latitude <> '' and longitude <> '';

select st_astext(point),* from gpxcontent;

CREATE TABLE lines as
SELECT us.name as state, r.datetosort as date,
  ST_MakeLine(r.geom ORDER BY r.datereal) as geom 
FROM gpxcontent AS r INNER JOIN us ON st_intersects(us.geom,r.geom) 
GROUP BY us.state, date 
ORDER BY date;

select filename from gpxcontent group by filename;

select * from lines;
--making the line string
SELECT St_MakeLine(point) as Route, tab.filename
FROM (SELECT point, CAST(time As date) as Data_obs, filename
		FROM gpxcontent as gc
			ORDER BY gc.time) tab group by tab.filename;

select ST_Asgeojson();

select st_asgeojson(r.Route) from (SELECT St_MakeLine(point) as Route, tab.filename
FROM (SELECT point, CAST(time As date) as Data_obs, filename
		FROM gpxcontent as gc
			ORDER BY gc.time) tab group by tab.filename) as r;
            
            
            
            SELECT COUNT(*)
		FROM information_schema.tables
		WHERE table_name='gpxcontent'



