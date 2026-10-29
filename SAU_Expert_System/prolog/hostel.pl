% ============================================================
% SAU HOSTEL POLICY - 2026-27
% ============================================================

hostel_rule(distance,'Candidate should not be residing within 20 km of SAU, New Delhi').
hostel_rule(priority,'Students from SAARC countries other than India are given priority').
hostel_rule(allocation,'Hostel accommodation is subject to merit and availability; admission does not guarantee hostel accommodation').
hostel_rule(registration_minimum,'Eligible 2026-27 candidates may be required to pay a minimum category fee of USD 200 at the acceptance stage').
hostel_rule(provisional,'Hostel offers are provisional and subject to document verification and eligibility compliance at physical registration').
hostel_rule(special_fee_rule,'Candidates from Afghanistan, Bangladesh and Pakistan were not required to pay the hostel fee at the acceptance stage in the 2026-27 hostel notice; fee is payable at physical registration').

hostel_distance_limit(20,km).
hostel_eligible_by_distance(Distance) :- Distance > 20.
hostel_priority(Country,high) :- country_type(Country,saarc), Country \= india.
hostel_priority(india,normal).
hostel_priority(Country,normal) :- country_type(Country,non_saarc).

hostel_status(Distance,eligible) :- hostel_eligible_by_distance(Distance).
hostel_status(Distance,check_policy) :- Distance =< 20.
