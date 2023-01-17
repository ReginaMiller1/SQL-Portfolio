
--Cleaning Data in SQL 


SELECT *
  FROM PortfolioProject..NashvilleHousingData

--Standerdize Sale Date
SELECT SaleDate, CONVERT(Date,SaleDate)
  FROM PortfolioProject..NashvilleHousingData

UPDATE NashvilleHousingData
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousingData
ADD SaleDateConverted DATE;

UPDATE NashvilleHousingData
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM NashvilleHousingData


---------------------------------------------------------------------------------------------------------------------------------------
--Populate Property Adress Data

SELECT*
FROM NashvilleHousingData
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT #1.ParcelID, #1.PropertyAddress, #2.ParcelID, #2.PropertyAddress, ISNULL(#1.PropertyAddress,#2.PropertyAddress)
FROM NashvilleHousingData AS #1
JOIN NashvilleHousingData AS #2
	ON #1.ParcelID = #2.ParcelID
	AND #1.UniqueID <> #2.UniqueID
WHERE #1.PropertyAddress is null

UPDATE #1
SET PropertyAddress = ISNULL(#1.PropertyAddress,#2.PropertyAddress)
FROM NashvilleHousingData AS #1
JOIN NashvilleHousingData AS #2
	ON #1.ParcelID = #2.ParcelID
	AND #1.UniqueID <> #2.UniqueID
WHERE #1.PropertyAddress is null


------------------------------------
--Breaking out Address into Individual Columns (Adress, City, State)


SELECT PropertyAddress
FROM NashvilleHousingData

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address

FROM NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD PropertySplitAdress varchar(225)

UPDATE NashvilleHousingData
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE NashvilleHousingData
ADD PropertySplitCity Nvarchar(225);

UPDATE NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 


SElECT OwnerAddress
FROM NashvilleHousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD OwnerSplitAddress varchar(225)

UPDATE NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousingData
ADD OwnerSplitCity Nvarchar(225)

UPDATE NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousingData
ADD OwnerSplitState Nvarchar(225)

UPDATE NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousingData
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM NashvilleHousingData

UPDATE NashvilleHousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

--------------------------------------------------------------------------------------------------------

--Remove Duplucates

WITH RowNumCTE AS(
SELECT*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDateConverted,
			LegalReference
			ORDER BY
				UniqueID
				) row_num
FROM NashvilleHousingData
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


------------------------------------------------------------------------------------------

--Delete Unused Colums


ALTER TABLE NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress