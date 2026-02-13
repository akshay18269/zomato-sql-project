CREATE DATABASE ZOMATO
USE ZOMATO
select * from Zomato_dataset
select * from [Country-Code]

--q1. overall statistcs for the indian restaurant

select count(*) total_restaurants,
       count (distinct city) as total_cities,
       avg(Rating) as average_rating,
       avg(Average_cost_for_two) avg_cost
from Zomato_Dataset zd
inner join [Country-Code] cd
on zd.[CountryCode] = cd.Country_Code
where Country ='India'


--q2. top 10 indian cities with number of restaurants,average rating,average cost

select top 10 city,
count(*) restaurant_count,
avg(Rating) avg_rating,
avg(Average_Cost_for_two) avg_cost
from Zomato_Dataset zd
inner join [Country-Code] cd
on cd.Country_Code=zd.CountryCode
where Country ='India'
group by city
order by 2 desc

--q3. understand pricing segments and their relationship with ratings in india

select Price_range,
count(*) as restaurant_count,
avg(Rating) avg_rating,
count(*) * 100 / (select count (*) from Zomato_Dataset where CountryCode =1) percentage,
min(Average_Cost_for_two) min_cost_for_two,
max(Average_COst_for_two) max_cost_for_two
from Zomato_Dataset zd
inner join [Country-Code] cd
on cd.Country_Code=zd.CountryCode
where Country='India'
group by Price_range
order by 2 desc


--q4.  compare restaurant types based on service offerings in india.
-- online delivery vs dine-in

select Has_Online_delivery ,Has_Table_booking,
count(*) restaurant_count,
avg(Rating) avg_rating,
avg(Average_Cost_for_two) avg_cost,
avg(Votes) avg_votes
 from [Country-Code] cd
inner join Zomato_Dataset zd
on cd.Country_Code= zd.CountryCode
where country ='India'
group by Has_Online_delivery, Has_Table_booking


--q5. identify top 15 most popular cuisine types and their performance mertics in india.

 select Top 15 Cuisines, 
 count(*) restaurant_count,
 avg(Rating) avg_rating,
 avg(Average_Cost_for_two) avg_cost,
 avg(Votes) avg_votes
from Zomato_Dataset zd
join [Country-Code] cd
on zd.CountryCode=cd.Country_Code
where country='India'
group by Cuisines


--q6. budget vs premium restaurant segments in india.

select 
     case
         when Price_range in (1,2) then 'budget'
         when Price_range in (3,4) then 'premium'
     end as segment,
     count(*) restaurant_count,
      avg(Rating) avg_rating,
      avg(Average_Cost_for_two) avg_cost,
      avg(Votes) avg_votes,
      sum(case when Has_Online_delivery ='Yes' then 1 else 0 end ) online_delivery_count,
      sum(case when Has_Table_booking ='Yes' then 1 else 0 end ) table_booking_count
from [Country-Code] cd
join Zomato_Dataset zd
on cd.Country_Code = zd.CountryCode
where country ='India'
group by
     case
         when Price_range in (1,2) then 'budget'
         when Price_range in (3,4) then 'premium'
     end



--q7. city-wise rating distribution in top 5 indian cities

with top_cities as (
      select top 5 City
      from [Country-Code] cd
      join Zomato_Dataset zd
      on cd.Country_Code = zd.CountryCode
      where country ='India'
      group by City
      order by count(*) desc
)
select tc.City, count(*) restaurant_count,
       sum(case when Rating >=4 then 1 else 0 end) as excellent_rating,
       sum(case when Rating >=3 and rating <4 then 1 else 0 end) as good_rating,
       sum(case when Rating < 3 and rating >0  then 1 else 0 end) as poor_rating,
       sum(case when Rating =0 and rating is null  then 1 else 0 end) as no_rating
from top_cities tc
join Zomato_Dataset zd
on tc.City= zd.City
group by tc.City
order by 2 desc



-- Q8. Compare average dining costs across different countries */


select Country,
    avg(Average_Cost_for_two) avg_cost,
    Currency
from Zomato_Dataset zd
inner join [Country-Code] cd
on zd.CountryCode = cd.Country_Code
group by Country, Currency
order by 2 desc;


--Q09. India vs Other Countries - Service Features Comparison */


select case 
        when Country = 'India' then 'India'
        else 'Other Countries'
       end as region,
       count(*) restaurant_count,
       avg(Rating) avg_rating,
       avg(Votes) avg_votes,
       sum(case 
            when Has_Online_delivery = 'Yes' or Has_Table_booking = 'Yes' then 1 
            else 0 
        end) * 100 / count(*) as digital_adoption_percentage
from Zomato_Dataset zd 
join [Country-Code] cd 
on cd.Country_Code = zd.CountryCode 
group by 
    case 
        when Country = 'India' then 'India'
        else 'Other Countries'
    end ;
