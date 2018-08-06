CREATE OR REPLACE FUNCTION get_cmc_metrics (IN start_date date)
RETURNS TABLE(DateForMetric date, Service text, Metric text, Count bigint) AS $BODY$
BEGIN
RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service, 
		'Mediation Requested Count'::text as Metric,
		Count(*)
	FROM case_data cd
	WHERE
		(cd.jurisdiction='CMC')  AND
		(cd.data->'response' ? 'freeMediationOption') AND
		(cd.data->'response'->>'freeMediationOption' = 'YES') AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Claim Submitted Count'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Claim Responded Count'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'respondedAt') AND 
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Claim Submitted Count 19 days ago'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND
		(start_date::timestamp = (cd.data->>'submittedOn')::timestamp + interval '19 days');
		
RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'CCJ Request is 19 days old'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'countyCourtJudgmentRequestedAt') AND
		(start_date::timestamp = (cd.data->>'countyCourtJudgmentRequestedAt')::timestamp + interval '19 days') AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);
		
RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'CCJ Request is 19 days and more time was requested'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'countyCourtJudgmentRequestedAt') AND
		(start_date::timestamp = (cd.data->>'countyCourtJudgmentRequestedAt')::timestamp + interval '19 days') AND
		(cd.data ? 'moreTimeRequested') AND (cd.data->>'moreTimeRequested' = 'YES') AND 
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'CCJ Request is 19 days and response made'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'response') AND
		(cd.data ? 'countyCourtJudgmentRequestedAt') AND
		(start_date::timestamp = (cd.data->>'countyCourtJudgmentRequestedAt')::timestamp + interval '19 days') AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);
		
RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'CCJ Request more than 33 days'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'countyCourtJudgmentRequestedAt') AND
		(start_date::timestamp > (cd.data->>'countyCourtJudgmentRequestedAt')::timestamp + interval '33 days') AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);		

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Defendent requested more time'::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'moreTimeRequested') AND
		(cd.data->>'moreTimeRequested' = 'YES') AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Number of cases with responses of type '::text || (cd.data->'response'->>'responseType')::text as Metric,
		COUNT(*)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'response') AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp)
	GROUP BY cd.data->'response'->>'responseType';

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Number of cases settled through mediation platform'::text as Metric,
		COUNT(*)
	FROM case_event ce
	WHERE 
		(ce.event_id='OfferAcceptedByClaimant') AND 
		((ce.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((ce.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Claims where Responded, age of claim for type '::text || (cd.data->'response'->>'responseType')::text as Metric,
		count(EXTRACT( epoch from (cd.data->>'respondedAt')::timestamp - (cd.data->>'submittedOn')::timestamp )::bigint)
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'respondedAt') AND 
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp)
	GROUP BY cd.data->'response'->>'responseType';

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Age of settled claim '::text as Metric,
		((cd.data->>'settlementReachedAt')::date - (cd.data->>'submittedOn')::date )::bigint
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'settlementReachedAt') AND 
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
		'CMC'::text as Service,
		'Total fees collected '::text as Metric,
		sum(round(jsonb_extract_path_text(cd.data->'claimData', 'feeAmountInPennies')::DECIMAL / 100, 2) )::bigint
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='CMC') AND 
		(cd.data ? 'claimData') AND (cd.data->'claimData' ? 'feeAmountInPennies') AND 
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp);

RETURN QUERY
	SELECT start_date as DateForMetric,
	'CMC'::text as Service,
	'Number of resolved claims aged '::text || ((cd.data->>'submittedOn')::date-(cd.data->>'respondedAt')::date)::text || ' days',
	count(*)
	FROM case_data cd
	WHERE
		(cd.jurisdiction='CMC') AND 
		(
			(cd.data ? 'countyCourtJudgmentRequestedAt' AND (cd.data->>'countyCourtJudgmentRequestedAt')::date=start_date::date) OR 
			(cd.data ? 'settlementReachedAt' AND (cd.data->>'settlementReachedAt')::date=start_date::date) OR
			(cd.data ? 'respondedAt' AND (cd.data->>'respondedAt')::date=start_date::date) 
		) AND
		((cd.data->>'submittedOn')::timestamp >= start_date::timestamp) AND
		((cd.data->>'submittedOn')::timestamp < (start_date + interval '1 day')::timestamp)
	GROUP BY (cd.data->>'submittedOn')::date-(cd.data->>'respondedAt')::date;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

SELECT * from get_cmc_metrics('2018-05-16'::date);