-- Story:
-- A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it.
-- You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. 

select description from crime_scene_report
where date = 20180115 and city like '%SQL City%' and type ='murder'; 

-- Security footage shows that there are 2 witnesses. The first witness lived in the last house on the "Northwest Dr." 
-- The second witness, named Annabel, lives somewhere on "Franklin Ave."

select * from interview 
join person 
on interview.person_id = person.id
where interview.person_id = ( select id  from person 
			                        where address_street_name = 'Northwestern Dr'
			                        order by address_number DESC 
			                        limit 1)
	or interview.person_id = ( select id from person 
			                       where address_street_name = 'Franklin Ave' 
			                       and name like '%Annabel%');

-- WITNESS'S TRANSCRIPT
-- 14887: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
--        The membership number on the bag started with "48Z". 
--        Only gold members have those bags. The man got into a car with a plate that included "H42W".
-- 16371: I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
            
select person_id, transcript from interview
where person_id in ( select person_id from get_fit_now_check_in checkin join get_fit_now_member member
					           on checkin.membership_id = member.id
					           where checkin.check_in_date = 20180109 
					           and member.membership_status ='gold'
		                 		   and member.id like '48Z%');

-- Transcript: I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--             She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

select id, name, license_id, ssn from person 
where id in ( select person_id from facebook_event_checkin
				      where event_name like 'SQL Symphony Concert'
				      and date like '201712%' 
				      group by person_id 
				      having count(person_id) = 3)
and license_id = ( select id from drivers_license 
				      where gender = 'female' and hair_color ='red' and car_make like 'Tesla%' and car_model = 'Model S'
				      and height between 65 and 67);

-- Answer : Miranda Priestly with person id: 99716

/* 
select * from person join income
where person.ssn = income.ssn
and person.id = 99716;
*/


