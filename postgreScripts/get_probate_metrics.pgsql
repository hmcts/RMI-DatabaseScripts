CREATE OR REPLACE FUNCTION get_probate_metrics (IN start_date date)
RETURNS TABLE(RunDate date, Service text, Metric text, Count bigint) AS $BODY$
BEGIN
RETURN QUERY 
    SELECT start_date AS RunDate,
		'PROBATE'::text AS Service,
        'Count of cases submitted in hour ' || date_part('hour',last_modified) AS Metric,
        count(*) 
    FROM case_data cd
    WHERE jurisdiction='PROBATE' AND 
        state='CaseCreated' AND 
        last_modified::timestamp>=start_date::timestamp AND 
        last_modified::timestamp < (start_date::timestamp + interval '1 day')::timestamp
    GROUP BY date_part('hour',last_modified);

RETURN QUERY 
    SELECT start_date AS RunDate,
		'PROBATE'::text AS Service,
        'Count of cases taking longer than 1 day to print'::text as Metric,
        count(*) 
    FROM case_data cd
    WHERE cd.jurisdiction='PROBATE' AND 
        cd.state='CasePrinted' AND 
        DATE_PART('day',cd.last_modified-cd.created_date)>1 AND
        last_modified::timestamp>=start_date::timestamp AND 
        last_modified::timestamp < (start_date::timestamp + interval '1 day')::timestamp;

RETURN QUERY 
    SELECT start_date AS RunDate,
		'PROBATE'::text AS Service,
        'Count of cases in location '::text || (cd.data->>'registryLocation')::text as Metric,
        count(*) 
    FROM case_data cd
    WHERE cd.jurisdiction='PROBATE' AND 
        cd.state='CasePrinted' AND 
		cd.data ? 'registryLocation' AND
        last_modified::timestamp>=start_date::timestamp AND 
        last_modified::timestamp < (start_date::timestamp + interval '1 day')::timestamp
    GROUP BY cd.data->>'registryLocation';

RETURN QUERY
	SELECT start_date AS RunDate,
		'PROBATE'::text AS Service,
        'Cases per state -'|| state ||'-'|| date_part('hour',last_modified) AS Metric,
        count(*) 
    FROM case_data cd
    WHERE jurisdiction='PROBATE' AND        
        last_modified::timestamp>=start_date::timestamp AND 
        last_modified::timestamp < (start_date::timestamp + interval '1 day')::timestamp
    GROUP BY state, date_part('hour',last_modified);

RETURN QUERY
		SELECT start_date AS RunDate,
		'PROBATE'::text AS Service,
        'Cases per state -'|| state ||'-'|| date_part('hour',last_modified) AS Metric,
        count(*) 
    FROM case_data cd
    WHERE jurisdiction='PROBATE' AND        
        last_modified::timestamp>=start_date::timestamp AND 
        last_modified::timestamp < (start_date::timestamp + interval '1 day')::timestamp
    GROUP BY state, date_part('hour',last_modified);
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

SELECT * from get_probate_metrics('2018-06-05'::date);