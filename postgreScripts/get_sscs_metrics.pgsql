DROP FUNCTION get_sscs_metrics(date);

CREATE OR REPLACE FUNCTION get_sscs_metrics (IN start_date date)
RETURNS TABLE(DateForMetric date, Service varchar, TypeID varchar, CaseRef varchar, SMS varchar, EMAIL varchar, Region varchar, BenefitType varchar, BenefitCode varchar, HearingType varchar, VenueName varchar) as $BODY$
BEGIN RETURN QUERY
	SELECT 
		start_date as DateForMetric,
		'SSCS'::varchar as Service,
		cd.case_type_id::varchar as TypeID,
		(cd.data->>'caseReference')::varchar as CaseRef,
		(cd.data->'subscriptions'->'appellantSubscription'->>'subscribeSms')::varchar as SMS,
		(cd.data->'subscriptions'->'appellantSubscription'->>'subscribeEmail')::varchar as EMAIL,
		(cd.data->>'region')::varchar as Region,
		(cd.data->'appeal'->'benefitType'->>'description')::varchar as BenefitType,
		(cd.data->'appeal'->'benefitType'->>'code')::varchar as BenefitCode,
		(cd.data->'appeal'->>'hearingType')::varchar as HearingType,
		(jsonb_array_elements(cd.data->'hearings')->'value'->'venue'->>'name')::varchar as VenueName
	FROM case_data cd
	WHERE 
		(cd.jurisdiction='SSCS') AND
		(cd.created_date::timestamp > start_date::timestamp) AND
		(cd.created_date::timestamp < (start_date + interval '1 day')::timestamp);
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

SELECT * from get_sscs_metrics('2018-03-26');