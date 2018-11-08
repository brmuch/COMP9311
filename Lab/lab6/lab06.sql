create function totRating1() returns trigger
as $$
declare
    emp  RECORD;
begin
	For emp in select beer,sum(score) as totRating, count(*) as nRating from Ratings group by beer
	LOOP
	    update Beer  
		set totRating = emp.totRating, nRatings = emp.nRating, rating = emp.totRating / emp.nRating
		where emp.beer = Beer.id;
    END LOOP;
	return new;
end;
$$ language plpgsql;

create trigger totRating 
before insert or delete or update on Ratings
for each row execute procedure totRating1();
