/*

Cleaning Data in SQL Queries 

*/

select *

from PortifolioProject.dbo.NashvilleHousing

--Standrise date format
select SalesDateConverted,convert(date,SaleDate)


from PortifolioProject.dbo.NashvilleHousing

update NashvilleHousing

set SaleDate=convert(date,SaleDate)

alter table nashvillehousing
add SalesDateConverted Date;

update NashvilleHousing 
set SalesDateConverted=convert(date,SaleDate)


--populate property Address Data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.ParcelID,ISNULL(a.PropertyAddress,b.PropertyAddress)


from PortifolioProject.dbo.NashvilleHousing a 
Join PortifolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortifolioProject.dbo.NashvilleHousing a 
Join PortifolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

where a.PropertyAddress is null


---Breaking address into Individual Columns (Address,City,State)

select PropertyAddress

from PortifolioProject.dbo.NashvilleHousing

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address
from PortifolioProject.dbo.NashvilleHousing

alter table nashvillehousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing 
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

alter table nashvillehousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing 
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


select *

from PortifolioProject.dbo.NashvilleHousing

select 
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortifolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Change Y and N to Yes and No in "Sold as Vacant" field



select distinct(SoldAsVacant) ,count(SoldAsVacant)

from PortifolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,

case when SoldAsVacant ='Y' then 'YES'
     when SoldAsVacant ='N' then 'NO'
	 else SoldAsVacant
	 end 

from PortifolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant=case when SoldAsVacant ='Y' then 'YES'
     when SoldAsVacant ='N' then 'NO'
	 else SoldAsVacant
	 end 

	 -- Remove Duplicates

with RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortifolioProject.dbo.NashvilleHousing)
delete 
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns

Select *
From PortifolioProject.dbo.NashvilleHousing


ALTER TABLE PortifolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


