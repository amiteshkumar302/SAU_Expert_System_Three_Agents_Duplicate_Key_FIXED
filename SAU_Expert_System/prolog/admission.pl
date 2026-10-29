% ============================================================
% SAU ADMISSION POLICY KNOWLEDGE BASE - 2026-27
% ============================================================

admission_mode(entrance_test, 'SAU Entrance Test Mode').
admission_mode(direct, 'Direct Admission Mode without SAU Entrance Test').
admission_mode(executive, 'Executive Programme Admission').

entrance_test_format(india, 'Center-based online test').
entrance_test_format(other_saarc, 'Proctored online test').

direct_basis(india, 'National-level tests such as JEE/CUET/NEET/CAT/CLAT/NET/GATE, as applicable to the programme').
direct_basis(other_saarc, 'National-level test scores or qualifying examination results from recognized institutions').
direct_basis(non_saarc, 'Scores obtained in the qualifying examination').

executive_admission('Executive PhD and Executive MBA use programme-specific eligibility, relevant professional experience and interview performance').
phd_direct_application('PhD Direct Mode applications follow the current admission notice and programme-specific eligibility').
phd_entrance_cycle('PhD Entrance Mode is normally conducted once a year; applicants should check the current notice').
executive_phd_eligibility('Executive PhD requires a recognised Master degree and at least 10 years of significant professional experience, subject to current SAU guidelines').

% -------------------------
% BACHELOR / BTECH
% -------------------------
bachelor_programme(btech_cse).
bachelor_programme(dual_btech_mtech_cse).
bachelor_programme(btech_math_computing).

bachelor_eligibility(btech_cse, 'Passed Class 12 / Higher Secondary or equivalent in Science stream with Mathematics and Physics as mandatory subjects').
bachelor_eligibility(btech_cse, 'Minimum 65% marks in aggregate').
bachelor_eligibility(btech_cse, 'Must satisfy the applicable SAU admission mode requirements').

bachelor_eligibility(dual_btech_mtech_cse, 'Passed Class 12 / Higher Secondary or equivalent in Science stream with Mathematics and Physics as mandatory subjects').
bachelor_eligibility(dual_btech_mtech_cse, 'Minimum 65% marks in aggregate').
bachelor_eligibility(dual_btech_mtech_cse, 'Must satisfy the applicable SAU admission mode requirements').

bachelor_eligibility(btech_math_computing, 'Passed Class 12 / Higher Secondary or equivalent in Science stream with Mathematics and Physics as mandatory subjects').
bachelor_eligibility(btech_math_computing, 'Minimum 65% marks in aggregate').
bachelor_eligibility(btech_math_computing, 'Must satisfy the applicable SAU admission mode requirements').

% -------------------------
% MASTER / POSTGRADUATE
% -------------------------
master_programme(Programme) :- programme(Programme, _, postgraduate, _, _).

% Programme-specific requirements that are explicitly represented.
master_eligibility(mca, 'Recognised Bachelor degree under 10+2+3 or 10+2+4 pattern').
master_eligibility(mca, 'Minimum 55% marks or equivalent grade').
master_eligibility(mca, 'Mathematics must have been studied at Bachelor level or at 10+2 level').

master_eligibility(msc_computer_science, 'Recognised 3-year or 4-year Bachelor degree in Computer Science or a relevant area').
master_eligibility(msc_computer_science, 'Minimum 55% marks or equivalent grade').
master_eligibility(msc_computer_science, 'Mathematics must have been studied at Bachelor level or at 10+2 level').

master_eligibility(msc_applied_math, 'Recognised Bachelor degree under the applicable 10+2+3 or 10+2+4 pattern').
master_eligibility(msc_applied_math, 'Minimum 55% marks or equivalent grade').
master_eligibility(msc_applied_math, 'Required Mathematics coursework must satisfy the programme-specific requirement').

master_eligibility(mtech_cse, 'Recognised 4-year BTech/BE/BSc(Engg)/BS in Computer Science or relevant area, or an eligible relevant Master degree').
master_eligibility(mtech_cse, 'Minimum 55% marks or equivalent grade').

master_eligibility(mba, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(mba, 'Must satisfy the programme-specific admission requirements and applicable national-level test requirement for Direct Mode').

% The remaining postgraduate programmes are explicitly represented too.
% Where a precise percentage/subject rule is not verified in this KB,
% the system tells the student to consult the current programme notice.
master_eligibility(ma_economics, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(ma_economics, 'Programme-specific subject/background and minimum marks must be checked in the current SAU admission notice').

master_eligibility(ma_sociology, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(ma_sociology, 'Programme-specific subject/background and minimum marks must be checked in the current SAU admission notice').

master_eligibility(ma_international_relations, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(ma_international_relations, 'Programme-specific subject/background and minimum marks must be checked in the current SAU admission notice').

master_eligibility(llm, 'Recognised qualifying law degree or equivalent qualification').
master_eligibility(llm, 'Programme-specific minimum marks and other requirements must be checked in the current SAU admission notice').

master_eligibility(ma_journalism_digital_media, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(ma_journalism_digital_media, 'Programme-specific academic/background requirements must be checked in the current SAU admission notice').

master_eligibility(ma_communication_sustainable_development, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(ma_communication_sustainable_development, 'Programme-specific academic/background requirements must be checked in the current SAU admission notice').

master_eligibility(msc_biotechnology, 'Recognised Bachelor degree in Biotechnology, Life Sciences or another relevant area, subject to programme-specific requirements').
master_eligibility(msc_biotechnology, 'Programme-specific minimum marks and prerequisite subjects must be checked in the current SAU admission notice').

master_eligibility(ms_climate_change, 'Recognised Bachelor degree in a relevant discipline or equivalent qualification').
master_eligibility(ms_climate_change, 'Programme-specific minimum marks and prerequisite subjects must be checked in the current SAU admission notice').

master_eligibility(ms_business_analytics_ai, 'Recognised Bachelor degree or equivalent qualification').
master_eligibility(ms_business_analytics_ai, 'Programme-specific quantitative/background requirements and minimum marks must be checked in the current SAU admission notice').

% -------------------------
% PHD
% -------------------------
phd_programme(Programme) :- programme(Programme, _, doctoral, _, _).

phd_eligibility(Programme, '12 years of regular schooling plus at least a 3-year Bachelor degree and postgraduate education leading to MA/MSc/MCA/MS/MTech/LLM from a recognised institution') :- phd_programme(Programme).
phd_eligibility(Programme, 'Minimum 50% marks or equivalent grade for Social Sciences and Law; minimum 55% for Science subjects') :- phd_programme(Programme).
phd_eligibility(Programme, 'Integrated Bachelor-Master candidates are eligible if they have at least 5 years of college/university education leading to a Master degree after 12 years of schooling') :- phd_programme(Programme).
phd_eligibility(Programme, 'Candidates with a four-year Bachelor degree may be considered on a case-by-case basis') :- phd_programme(Programme).
phd_eligibility(Programme, 'Programme/faculty-specific requirements must also be satisfied') :- phd_programme(Programme).

% -------------------------
% ADMISSION MODES BY LEVEL
% -------------------------
admission_mode_for(Programme, entrance_test) :- programme(Programme, _, _, _, _).
admission_mode_for(Programme, direct) :- programme(Programme, _, _, _, _).
admission_mode_for(executive_mba, executive).
admission_mode_for(executive_phd, executive).

% -------------------------
% DOCUMENTS
% -------------------------
required_document(application_form).
required_document(academic_certificates).
required_document(academic_marksheets_transcripts).
required_document(identity_document).
required_document(recent_photograph).

international_required_document(passport).
international_required_document(visa_or_immigration_document).

% -------------------------
% QUERY HELPERS
% -------------------------
all_requirements(Programme, Requirements) :-
    findall(R, eligibility(Programme, R), Requirements).

eligibility(Programme, R) :- bachelor_eligibility(Programme, R).
eligibility(Programme, R) :- master_eligibility(Programme, R).
eligibility(Programme, R) :- phd_eligibility(Programme, R).

all_admission_modes(Programme, Modes) :-
    findall(Mode, admission_mode_for(Programme, Mode), Raw),
    sort(Raw, Modes).

country_admission_rule(Country, Rule) :-
    country_type(Country, saarc), Country \= india,
    Rule = 'Other SAARC applicants may use the SAU Entrance Test and applicable Direct Mode routes under the current notice'.
country_admission_rule(india, 'Indian applicants may use SAU Entrance Test or applicable Direct Mode national-level tests').
country_admission_rule(Country, 'Non-SAARC applicants are considered under the applicable international/qualifying-examination rules') :- country_type(Country, non_saarc).
