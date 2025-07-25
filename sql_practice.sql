-- Creating Artist Table Using Csv File 

Create Table Artists ( 
	ArtistID Int,
	Name Varchar
    );

Copy Artists from 'D:\DA20\Artist.csv' DELIMITER ',' CSV HEADER;

Select * from Artists;

-- Adding primary key as we forgot to add we need to use alter to add now 

ALTER TABLE Artists
ADD PRIMARY KEY (ArtistID);

Select * from Artists;

-------------------------------------------------------------------------

-- Creating Albums Table From Csv File

Create Table Albums ( 
	AlbumID Int,
	Title Varchar,
	ArtistID Int,
	Primary Key (AlbumID),
    Foreign Key  (ArtistID) References Artists(ArtistID)
);

Copy Albums from 'D:\DA20\Album.csv' DELIMITER ',' CSV HEADER;

Select * from Albums;

-------------------------------------------------------------------------

-- Creating Albums Table From Csv File

Create Table Tracks( 
	TrackID Int,
	Name Varchar,
	AlbumID Int,
	Composer Varchar,
	Minutes time,
	UnitPrice Int,
	Primary Key (TrackID),
    Foreign Key  (AlbumID) References Albums(AlbumID)
);

Copy Tracks from 'D:\DA20\Tracks.csv' DELIMITER ',' CSV HEADER;

Select * from Tracks;

-------------------------------------------------------------------------
-- Applying Inner Join On Three Tables 

Select A.Name as Singer, AL.Title, T.Name as Track, T.Composer From Artists as A
Inner Join Albums as AL on A.ArtistID = AL.ArtistID
Inner Join Tracks as T On AL.AlbumID = T.AlbumID;

-------------------------------------------------------------------------

select * from Tracks

-- Now we solve some questions based on this data 

-- 1. Run Query: Find all the tracks that have a length of 2 minutes or more.
  select a.name, t.minutes from Artists as a  inner join tracks as t on a.ArtistID = t.AlbumID  where t.minutes>= '00:02:00';


-- 2. Run Query: Find all the tracks whose composer starts with 'Ed'.
select name from Tracks where composer Like 'Ed%'


-- 3. Find the albums with 5 or more tracks.

select A.Title, Count(T.TrackID) from Albums as A inner join Tracks as T 
on A.AlbumID = T.AlbumID Group by A.Title having Count(T.TrackID) >= 5 Order By Count(T.TrackID) Desc


-------------------------------------------------------------------------
-- Chinook Database is installed for practice

-- Dew to old tables we had created using csv their are complecations are arise we need to solve that first

-------------------------------------------------------------------------
-- Dropping Older Artists, Albums, Track Table of old data as we installed chinnok db 

drop table tracks;
drop table albums;
drop table artists;
------------------------------
-- Giving origional name to chinnok databse tables as old table are deleted

alter table artist rename to artists;
alter table track rename to tracks;
alter table album rename to albums;

---------------------------------
-- Now Changing column name to origenal one as chinnok db has 
alter table artists rename artist_id to artistId;
alter table albums rename artist_id to artistId;
alter table albums rename album_id to albumId;
alter table tracks rename album_id to albumId;
alter table tracks rename unit_price to unitPrice;

-------------------------------------------------------------------------

-- Practice Questions

-- 1. How many albums does the artist Led Zeppelin have? 

select AR.Name, Count(AL.Title) as NumberOfTitles from artist as AR inner join album as AL On 
AR.artist_Id = AL.artist_Id group by AR.Name having AR.Name = 'Led Zeppelin';
Ans - "Led Zeppelin"	14

--------------------------------------------------------------------------
-- 2. Create a list of album titles and the unit prices for the artist "Audioslave".
-- How many records are returned?

select ar.name, al.title, tr.Unit_Price from artist as ar 
inner join album as al on ar.artist_id = al.artist_id
inner join track as tr on al.album_id = tr.album_id
where ar.name = 'Audioslave';

-- Ans - Total rows: 40

----------------------------------------------------------------------------
--3. Find the first and last name of any customer who does not have an invoice. Are there any customers returned from the query?  

select * from customer

select c.first_Name, c.last_Name from customer as c left join invoice as i 
on c.customer_Id = i.customer_Id where i.invoice_Id is null

-- Ans- No

-----------------------------------------------------------------------------
--4. Creating View using Subquery to Find Invoices for Customers in Paris


Create View Paris_invoice As	
	SELECT *
	FROM invoice
	WHERE customer_id IN (SELECT customer_id FROM customer WHERE city = 'Paris');

Select * From Paris_invoice;

------------------------------------------------------------------------------

--5. Creating View For Top 10 Track Sold Most Using - 'Join with Group By And Order By'

Create View Top_10 As 
	Select t.name as Track_name,  count(i.invoice_line_id) as Times_sold from track as t 
	inner join invoice_line as i on t.track_id = i.track_id
	Group By t.name 
	Order BY Times_sold Desc Limit 10;

Select * From Top_10

------------------------------------------------------------------------------


-- 6. Creating View For Customer Who Buy More Then 1 Tracks Using - 'Join with Group By and Having'

Create View frequent_buyer As
	 select c.First_name as customer_name, count(t.track_id) as Total_track
	 from customer as c inner join track as t on c.customer_id = t.Track_id
	 group by customer_name 
	 having count(t.track_id) > 1;

Select * From frequent_buyer;

------------------------------------------------------------------------------
-- Changing column name

alter table frequent_buyer rename total_track to total_song;

Select * From frequent_buyer;
