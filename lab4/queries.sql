-- COMP9311 18s2 Lab 04 Exercises

-- Q1. What beers are made by Toohey's?

create or replace view Q1 as
select beers.name
from   brewers,beers
where  brewers.id=beers.brewer and brewers.name ='Toohey''s'
;

-- Q2. Show beers with headings "Beer", "Brewer".

create or replace view Q2(Beer,Brewer) as
select beers.name, brewers.name
from   brewers,beers
where  brewers.id=beers.brewer
;

-- Q3. Find the brewers whose beers John likes.

create or replace view Q3  as
select brewers.name
from   brewers,likes,drinkers,beers
where  drinkers.name = 'John' and drinkers.id = likes.drinker and likes.beer = beers.id and beers.brewer= brewers.id
;

-- Q4. How many different beers are there?

create or replace view Q4(beers) as
select count(*)
from beers
;

-- Q5. How many different brewers are there?

create or replace view Q5 as
select count(*)
from   brewers
;

-- Q6. Find pairs of beers by the same manufacturer
--     (but no pairs like (a,b) and (b,a), and no (a,a))

create or replace view Q6 (beer1,beer2)as
select br1.name, br2.name
from   beers as br1,beers as br2
where  br1.name > br2.name and br1.brewer = br2.brewer
;

-- Q7. How many beers does each brewer make?

create or replace view Q7(brewer,nbeers) as
select brewers.name, count(*) from brewers,beers where beers.brewer= brewers.id group by brewers.name order by brewers.name;
;

-- Q8. Which brewer makes the most beers?

create or replace view Q8 as
select brewer from q7 where nbeers = (select max(nbeers) from q7);
;

-- Q9. Beers that are the only one by their brewer.
create view test(name, num) as 
select brewers.name, count(*) from brewers,beers where beers.brewer= brewers.id group by brewers.name order by brewers.name;
create or replace view Q9 as
select beers.name from beers,test,brewers where test.name=brewers.name and brewers.id=beers.brewer and test.num = 1
;

-- Q10. Beers sold at bars where John drinks.

create or replace view Q10 as
select beers.name from beers, drinkers, bars,frequents,sells where drinkers.name = 'John' and drinkers.id = frequents.drinker and frequents.bar= bars.id and bars.id = sells.bar and sells.beer = beers.id group by beers.name order by beers.name;
;

-- Q11. Bars where either Gernot or John drink.

create or replace view Q11 as
select bars.name from bars, drinkers, frequents where (drinkers.name = 'Gernot'or drinkers.name = 'John') and drinkers.id = frequents.drinker and frequents.bar = bars.id group by bars.name order by bars.name;
;

-- Q12. Bars where both Gernot and John drink.

create view John(bar) as 
select bars.name from bars, drinkers, frequents where drinkers.name = 'John' and drinkers.id = frequents.drinker and frequents.bar = bars.id group by bars.name order by bars.name;
create view Gernot(bar) as
select bars.name from bars, drinkers, frequents where drinkers.name = 'Gernot'  and drinkers.id = frequents.drinker and frequents.bar = bars.id group by bars.name order by bars.name;
create view Q12 as
select John.bar from John, Gernot where John.bar = Gernot.bar;
;

-- Q13. Bars where John drinks but Gernot doesn't

create or replace view Q13 as
select John.bar from John where John.bar not in (select * from Gernot)
;

-- Q14. What is the most expensive beer?

create or replace view Q14 as
select beers.name from beers, sells where beers.id = sells.beer and sells.price = (select max(price) from sells)
;

-- Q15. Find bars that serve New at the same price
--      as the Coogee Bay Hotel charges for VB.

create view price as
select sells.price 
from beers, bars, sells 
where beers.name = 'Victoria Bitter' 
      and beers.id = sells.beer 
      and sells.bar = bars.id 
      and bars.name = 'Coogee Bay Hotel';

create view Q15 as
select bars.name 
from bars,beers,sells 
where beers.name = 'New' 
      and beers.id = sells.beer 
      and sells.bar = bars.id 
      and sells.price = (select * from price);
;

-- Q16. Find the average price of common beers
--      ("common" = served in more than two hotels).

create view common(beer,nbeers) as 
select beer, count(*) from sells group by beer;

create view q16(beer,AvePrice) as
select beers.name, avg(sells.price)::numeric(5,2) from beers,sells where beers.id = sells.beer and sells.beer in (select beer from common where nbeers > 2) 
group by beers.name order by beers.name;
;

-- Q17. Which bar sells 'New' cheapest?

create or replace view Q17 as
create view Q17_price(bar,price) as 
select bars.name, sells.price from bars, sells, beers where beers.name = 'New' and beers.id = sells.beer and sells.bar = bars.id;
create view Q17 as
select Q17_price.bar from Q17_price where Q17_price.price = (select min(price) from Q17_price)
;

-- Q18. Which bar is most popular? (Most drinkers)

create or replace view Q18 as
select ...
from   ...
where  ...
;

-- Q19. Which bar is least popular? (May have no drinkers)

create or replace view Q19 as
select ...
from   ...
where  ...
;

-- Q20. Which bar is most expensive? (Highest average price)

create or replace view Q20 as
select ...
from   ...
where  ...
;

-- Q21. Which beers are sold at all bars?

create or replace view Q21 as
select ...
from   ...
where  ...
;

-- Q22. Price of cheapest beer at each bar?

create or replace view Q22 as
select ...
from   ...
where  ...
;

-- Q23. Name of cheapest beer at each bar?

create or replace view Q23 as
select ...
from   ...
where  ...
;

-- Q24. How many drinkers are in each suburb?

create or replace view Q24 as
select ...
from   ...
where  ...
;

-- Q25. How many bars in suburbs where drinkers live?
--      (Must include suburbs with no bars)

create or replace view Q25 as
select ...
from   ...
where  ...
;