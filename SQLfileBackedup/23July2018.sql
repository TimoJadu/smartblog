SELECT id, idd, longitude, latitude, altitude, "time", "Speed", "DateTime", "TimeDiff", "DistanceCovered", "DeltaElev", "GeoPointsDist", "Angle", "fileName"
	FROM public.restapp_summarytable;
    
    select * from "restapp_gpxcontenttable";
    select * from restapp_summarytable;
    select * from gpxfilescharacteristics;
    select * from summarytable;
    
    drop table summarytable;
    drop table restapp_summarytable;
    
    
    with CTE(
        select 
                case 
                    when max(rst.id) is null then 2
                    else max(rst.id)+2
                end
        	from restapp_summarytable as rst
    )
    insert into restapp_summarytable(id, id_gist, longitude, latitude, altitude, "time", "Speed", "DateTime", "TimeDiff", "DistanceCovered", "DeltaElev", "GeoPointsDist", "Angle", "fileName")
    select 
    	(select 
                case 
                    when max(rst.id) is null then 1
                    else max(rst.id)+1
                end
        	from restapp_summarytable as rst),
        id_gist, longitude, latitude, altitude, "time", speed, "DateTime", "TimeDiff", "DistanceCovered", "DeltaElev", "GeoPointsDist", "Angle", filename from summarytable as st;
    
    
    
    -------------------------------------------------
    delete from summarytable where id_gist is null;
    
    insert into restapp_summarytable(id, id_gist, longitude, latitude, altitude, "time", "Speed", "DateTime", "TimeDiff", "DistanceCovered", "DeltaElev", "GeoPointsDist", "Angle", "fileName")
    select 
    	(ROW_NUMBER() over (order by filename)),
        id_gist, longitude, latitude, altitude, "time", speed, "DateTime", "TimeDiff", "DistanceCovered", "DeltaElev", "GeoPointsDist", "Angle", filename from summarytable as st;
        
    --------------------------------------------------
    select * from restapp_summarytable;
    
    select *,ROW_NUMBER() over (order by id_gist) from summarytable;
    select * from summarytable;
    
    delete from restapp_summarytable;

    delete from restapp_gpxcontenttable;
    insert into restapp_summarytable(id_gist, longitude, latitude,altitude,time)
    select id,longitude, latitude,altitude,time from summarytable;
    
    
    SELECT id, app, name, applied
	FROM public.django_migrations;
    
    delete from public.django_migrations where id in (21,22);
    
    
    select * from gpxcontent;
    
    select st_asgeojson(r.Route) from (SELECT St_MakeLine(point) as Route, tab.filename
FROM (SELECT point, CAST(time As date) as Data_obs, filename
		FROM gpxcontent as gc
			ORDER BY gc.time) tab group by tab.filename) as r;
            
            --------------------------
            
            insert into restapp_gpxJson (id, "fileName", "lineString") select (ROW_NUMBER() over (order by r.filename)), r.fileName, st_asgeojson(r.Route) from (SELECT St_MakeLine(point) as Route, tab.filename
FROM (SELECT point, CAST(time As date) as Data_obs, filename
		FROM gpxcontenttable as gc
			ORDER BY gc.time) tab group by tab.filename) as r;
            
            select * from gpxcontenttable;
            
            select * from restapp_gpxJson;
            drop table restapp_gpxJson;