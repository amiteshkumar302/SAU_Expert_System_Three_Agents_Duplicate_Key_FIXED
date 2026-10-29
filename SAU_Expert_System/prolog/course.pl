programme(btech_cse,'BTech Computer Science and Engineering',undergraduate,engineering,'4 years').
programme(dual_btech_mtech_cse,'Dual Degree BTech-MTech Computer Science and Engineering',undergraduate,engineering,'5 years').
programme(btech_math_computing,'BTech Mathematics and Computing',undergraduate,mathematics,'4 years').
programme(ba_llb,'BA LLB (Honours)',undergraduate,law,'5 years').
programme(bba_llb,'BBA LLB (Honours)',undergraduate,law,'5 years').
programme(integrated_bs_ms,'Integrated BS-MS (Interdisciplinary Sciences)',integrated,science,'5 years').
programme(integrated_bba_mba,'Integrated BBA-MBA',integrated,management,'5 years').
programme(ba_hons_media,'BA (Honours) in Media, Arts and Design',undergraduate,media,'3 years').
programme(msc_applied_math,'MSc Applied Mathematics',postgraduate,mathematics,'2 years').
programme(msc_computer_science,'MSc Computer Science',postgraduate,computer_science,'2 years').
programme(ma_economics,'MA Economics',postgraduate,economics,'2 years').
programme(ma_sociology,'MA Sociology',postgraduate,sociology,'2 years').
programme(ma_international_relations,'MA International Relations',postgraduate,international_relations,'2 years').
programme(llm,'LLM',postgraduate,law,'1 year').
programme(mca,'MCA',postgraduate,computer_science,'2 years').
programme(ma_journalism_digital_media,'MA Journalism and Digital Media',postgraduate,media,'2 years').
programme(ma_communication_sustainable_development,'MA Communication for Sustainable Development',postgraduate,communication,'2 years').
programme(msc_biotechnology,'MSc Biotechnology',postgraduate,biotechnology,'2 years').
programme(ms_climate_change,'MS Climate Change and Sustainability',postgraduate,climate_change,'2 years').
programme(mtech_cse,'MTech Computer Science and Engineering',postgraduate,computer_science,'2 years').
programme(integrated_mtech_cse,'Integrated MTech Computer Science and Engineering',integrated,computer_science,'5 years').
programme(mba,'MBA',postgraduate,management,'2 years').
programme(ms_business_analytics_ai,'MS Business Analytics and Artificial Intelligence',postgraduate,management,'2 years').
programme(phd_biotechnology,'PhD in Biotechnology',doctoral,biotechnology,'5 years').
programme(phd_cse,'PhD in Computer Science and Engineering',doctoral,computer_science,'5 years').
programme(phd_mathematics,'PhD in Mathematics',doctoral,mathematics,'5 years').
programme(phd_physics,'PhD in Physics',doctoral,physics,'5 years').
programme(phd_chemistry,'PhD in Chemistry',doctoral,chemistry,'5 years').
programme(phd_climate_change,'PhD in Climate Change',doctoral,climate_change,'5 years').
programme(phd_economics,'PhD in Economics',doctoral,economics,'5 years').
programme(phd_international_relations,'PhD in International Relations',doctoral,international_relations,'5 years').
programme(phd_legal_studies,'PhD in Legal Studies',doctoral,law,'5 years').
programme(phd_media_arts_design,'PhD in Media, Arts and Design',doctoral,media,'5 years').
programme(phd_sociology,'PhD in Sociology',doctoral,sociology,'5 years').
programme(phd_management,'PhD in Management',doctoral,management,'5 years').
programme(phd_english,'PhD in English',doctoral,english,'5 years').
programme(executive_mba,'Executive MBA',executive,management,'As prescribed').
programme(executive_phd,'Executive PhD',executive,interdisciplinary,'5 years').
programme_by_level(L,List):-findall(N,programme(_,N,L,_,_),List).
programme_by_area(A,List):-findall(N,programme(_,N,_,A,_),List).
all_programmes(List):-findall(N,programme(_,N,_,_,_),List).
phd_programmes(List):-findall(N,programme(_,N,doctoral,_,_),List).
