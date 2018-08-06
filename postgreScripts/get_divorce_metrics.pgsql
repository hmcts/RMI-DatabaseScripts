CREATE OR REPLACE FUNCTION get_divorce_metrics (IN start_date date)
RETURNS TABLE(DateForMetric date, Service text, Metric text, Count bigint) AS $BODY$
BEGIN
RETURN QUERY
    SELECT 
        start_date AS DateForMetric,
        'Divorce'::text AS Service,
        ('Case Status '::text) || (cd.state::text) || ' in ' || (data->>'D8DivorceUnit'::text) AS Metric,
        count(*) AS Count
    FROM case_data AS cd
    WHERE 
        jurisdiction='DIVORCE' AND
        (cd.created_date::timestamp >= start_date::timestamp) AND
        (cd.created_date::timestamp < (start_date + interval '1 day')::timestamp)
    GROUP BY 
        cd.state,data->>'D8DivorceUnit';
RETURN QUERY
    SELECT 
        start_date AS RunDate,
        'Divorce'::text AS Service,
        ('Contact Details Status '::text) || (data->>'D8PetitionerContactDetailsConfidential'::text) || ' in ' || (data->>'D8DivorceUnit'::text) AS Metric,
        count(*) AS Count
    FROM case_data AS cd
    WHERE 
        jurisdiction='DIVORCE' AND
        (cd.created_date::timestamp >= start_date::timestamp) AND
        (cd.created_date::timestamp < (start_date + interval '1 day')::timestamp)
    GROUP BY 
        data->>'D8PetitionerContactDetailsConfidential',data->>'D8DivorceUnit';

RETURN QUERY
    SELECT 
        start_date AS DateForMetric,
        'Divorce'::text AS Service,
        ('Financial Order YES '::text) || ' in ' || (data->>'D8DivorceUnit'::text) AS Metric,
        count(*) AS Count
    FROM case_data AS cd
    WHERE 
        jurisdiction='DIVORCE' AND
        state='Submitted' AND
        cd.data->>'D8FinancialOrder'='YES' AND
        (cd.created_date::timestamp >= start_date::timestamp) AND
        (cd.created_date::timestamp < (start_date + interval '1 day')::timestamp)
    GROUP BY 
        data->>'D8DivorceUnit';
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

SELECT * FROM get_divorce_metrics('2018-02-27'::date);