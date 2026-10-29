saarc_country(afghanistan,'Afghanistan').
saarc_country(bangladesh,'Bangladesh').
saarc_country(bhutan,'Bhutan').
saarc_country(india,'India').
saarc_country(maldives,'Maldives').
saarc_country(nepal,'Nepal').
saarc_country(pakistan,'Pakistan').
saarc_country(sri_lanka,'Sri Lanka').
non_saarc_country(usa,'USA').
non_saarc_country(uk,'United Kingdom').
non_saarc_country(canada,'Canada').
non_saarc_country(australia,'Australia').
non_saarc_country(germany,'Germany').
non_saarc_country(france,'France').
non_saarc_country(japan,'Japan').
non_saarc_country(china,'China').
non_saarc_country(south_korea,'South Korea').
non_saarc_country(singapore,'Singapore').
non_saarc_country(malaysia,'Malaysia').
non_saarc_country(uae,'UAE').
non_saarc_country(saudi_arabia,'Saudi Arabia').
country_type(C,saarc):-saarc_country(C,_).
country_type(C,non_saarc):-non_saarc_country(C,_).
student_category(C,'SAARC'):-saarc_country(C,_).
student_category(C,'Non-SAARC'):-non_saarc_country(C,_).
list_saarc_countries(L):-findall(N,saarc_country(_,N),L).
