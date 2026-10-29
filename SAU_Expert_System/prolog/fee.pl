% ============================================================
% SAU FEE STRUCTURE - ACADEMIC SESSION 2026-27
% ============================================================

academic_year(2026_2027).

currency_rate(usd,inr,91,'Monsoon Semester 2026-27').

general_fee(registration,20,usd,one_time,'non-refundable').
general_fee(admission,200,usd,one_time,'non-refundable').
general_fee(security_deposit,200,usd,one_time,'refundable; 25% deducted as SAU Alumni Fee upon refund').
general_fee(student_aid_fund,10,usd,per_semester,'student aid fund').
general_fee(hostel,'as applicable',usd,per_semester,'subject to hostel category/policy').

% Semester fees for 2026-27.
semester_fee(btech_cse,1500,usd).
semester_fee(dual_btech_mtech_cse,1500,usd).
semester_fee(btech_math_computing,1500,usd).
semester_fee(ba_llb,1500,usd).
semester_fee(bba_llb,1500,usd).
semester_fee(integrated_bs_ms,800,usd).
semester_fee(integrated_bba_mba,1000,usd).
semester_fee(ba_hons_media,600,usd).

semester_fee(msc_applied_math,600,usd).
semester_fee(msc_computer_science,600,usd).
semester_fee(ma_economics,600,usd).
semester_fee(ma_sociology,600,usd).
semester_fee(ma_international_relations,600,usd).
semester_fee(llm,600,usd).
semester_fee(mca,600,usd).
semester_fee(ma_journalism_digital_media,600,usd).
semester_fee(ma_communication_sustainable_development,600,usd).
semester_fee(msc_biotechnology,800,usd).
semester_fee(ms_climate_change,800,usd).
semester_fee(mtech_cse,800,usd).
semester_fee(integrated_mtech_cse,800,usd).
semester_fee(mba,1500,usd).
semester_fee(ms_business_analytics_ai,1500,usd).

semester_fee(phd_biotechnology,800,usd).
semester_fee(phd_cse,800,usd).
semester_fee(phd_mathematics,800,usd).
semester_fee(phd_physics,800,usd).
semester_fee(phd_chemistry,800,usd).
semester_fee(phd_climate_change,800,usd).
semester_fee(phd_economics,600,usd).
semester_fee(phd_international_relations,600,usd).
semester_fee(phd_legal_studies,600,usd).
semester_fee(phd_media_arts_design,600,usd).
semester_fee(phd_sociology,600,usd).
semester_fee(phd_management,600,usd).
semester_fee(phd_english,600,usd).

semester_fee(executive_mba,2000,usd).
semester_fee(executive_phd,1200,usd).

% Direct PhD mode has 75% concession.
direct_phd_fee_concession(75,percent).
direct_phd_fee(Programme,200,usd,per_semester) :-
    member(Programme,[phd_biotechnology,phd_cse,phd_mathematics,phd_physics,phd_chemistry,phd_climate_change]).
direct_phd_fee(Programme,150,usd,per_semester) :-
    member(Programme,[phd_economics,phd_international_relations,phd_legal_studies,phd_media_arts_design,phd_sociology,phd_management,phd_english]).

non_saarc_fee_status('Non-SAARC fee structure differs and is notified separately; do not infer it from SAARC fees').

programme_fee(Programme, Fee, Currency, Period) :- semester_fee(Programme,Fee,Currency), Period=per_semester.
programme_fee(Programme, Fee, Currency, Period) :- direct_phd_fee(Programme,Fee,Currency,Period).
