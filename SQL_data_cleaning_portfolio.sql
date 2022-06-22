/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PorfolioProject1].[dbo].[nashville_housing]

SELECT *
FROM PorfolioProject1.dbo.nashville_housing


--Changing Date Format


Select SaleDateConverted, CONVERT(Date,SaleDate)
FROM PorfolioProject1.dbo.nashville_housing

Update dbo.nashville_housing
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table nashville_housing
Add SaleDateConverted Date;

Update nashville_housing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate Property Address Data

SELECT *
FROM PorfolioProject1.dbo.nashville_housing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PorfolioProject1.dbo.nashville_housing a
JOIN PorfolioProject1.dbo.nashville_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



SELECT *
FROM PorfolioProject1.dbo.nashville_housing
--WHERE PropertyAddress is null
ORDER BY ParcelID

-- Got rid of Null in Property Address by Joining the same table and linking same ParcelID's to the same property addresses


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PorfolioProject1.dbo.nashville_housing a
JOIN PorfolioProject1.dbo.nashville_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Changed formatting of Property Address to seperate Address and City


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
From PorfolioProject1.dbo.nashville_housing



Alter Table nashville_housing
Add PropertySplitAddress Nvarchar(255);

Update nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address

--UPDATE CITY
ALTER TABLE nashville_housing
Add PropertyCityAddress Nvarchar(255);

Update nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City

SELECT *
FROM PorfolioProject1.dbo.nashville_housing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM PorfolioProject1.dbo.nashville_housing


ALTER TABLE dbo.nashville_housing
ADD OwnerSplitAddress Nvarchar(255);

Update dbo.nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


ALTER TABLE dbo.nashville_housing
ADD OwnerCityAddress Nvarchar(255);

Update dbo.nashville_housing
SET OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)



ALTER TABLE dbo.nashville_housing
ADD OwnerSplitState Nvarchar(255);

Update dbo.nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


--CHANGING FORMAT OF SOLD AS VACANT COLUM TO YES AND NO ONLY


SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant)
FROM PorfolioProject1.dbo.nashville_housing
Group By SoldAsVacant
ORDER BY 2

SELECT(SoldAsVacant)
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant ='N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PorfolioProject1.dbo.nashville_housing

UPDATE dbo.nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
FROM PorfolioProject1.DBO.nashville_housing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress


--Unused Columns

SELECT *
FROM PorfolioProject1.dbo.nashville_housing

ALTER TABLE PorfolioProject1.dbo.nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
