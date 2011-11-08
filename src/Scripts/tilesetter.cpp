/***************************************************************************
 *   Copyright (C) 2010 by Tamino Dauth                                    *
 *   tamino@cdauth.de                                                      *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/
/*
Karte			Sollwert
Wsng (Fels 1)		ist Fdrg (Erde 3)
Ldro (Gras 1)		ist Wsnw (Tannennadeln 2)
Ldrg (Gras 2)		ist Bdrh (Straße 2)
Wrok (Fels 2)		ist Lrok (Gras 3)
Fdrt (Erde 1)		ist Fdro (Erde 2)
Bdrt (Straße 1)		ist Ldrg (Gras 2)
Fdro (Erde 2)		ist Wsng (Fels 1)
Fdrg (Erde 3)		ist Fdrt (Erde 1)
Wsnw (Tannennadeln 2)	ist Ldro (Gras 1)

folglich:
"Lgrs", // unchanged
"Wsng", // was Fdro (Erde 2)
"Fdro", // was Fdrt (Erde 1)
"Fdrt", // was Fdrg (Erde 3)
"Fdrg", // was Wsng (Fels 1)
"Lgrd", // unchanged
"Wdrt", // unchanged
"Wdro", // unchanged
"Wsnw", // was Ldro (Gras 1)
"Lrok", // was Wrok (Fels 2)
"Ldrg", // was Bdrt (Straße 1)
"Bdrh", // unchanged
"Ldro", // was Wsnw (Tannennadeln 2)
"Lrok", // unchanged
"Bdrh", // was Ldrg (Gras 2)
"Wgrs" // unchanged
*/

/**
* @todo FIXME: sizeof @struct Tilepoint isn't 7, it's 8?!
* @todo It seems that cliff texture types aren't replaced correctly.
*/

#include <iostream>
#include <cstdlib>
#include <cstring>
#include <stdint.h>
#include <vector>
#include <sstream>
#include <fstream>

// replacement data for map Talras.
static const uint32_t dmdfGroundTilesetNumber = 16;
static const uint8_t dmdfGroundTilesets[dmdfGroundTilesetNumber][5] =
{
	"Frok", // was Lgrs
	"Wsng", // was Fdro (Erde 2)
	"Fdro", // was Fdrt (Erde 1)
	"Fdrt", // was Fdrg (Erde 3)
	"Fdrg", // was Wsng (Fels 1)
	"Lgrd", // unchanged
	"Wdrt", // unchanged
	"Wdro", // unchanged
	"Wsnw", // was Ldro (Gras 1)
	"Lrok", // was Wrok (Fels 2)
	"Ldrg", // was Bdrt (Straße 1)
	"Fgrs", // was Bdrh
	"Ldro", // was Wsnw (Tannennadeln 2)
	"Wrok", // was Lrok
	"Bdrh", // was Ldrg (Gras 2)
	"Bdrt" // was Wgrs
};
/*
static const uint8_t dmdfGroundTilesets[dmdfGroundTilesetNumber][5] =
{
	"Ldrt",
	"Ldro",
	"Ldrg",
	"Lrok",
	"Lgrs",
	"Lgrd",
	"Wdrt",
	"Wdro",
	"Wsng",
	"Wrok",
	"Wgrs",
	"Wsnw",
	"Fdrt",
	"Fdrg",
	"Frok",
	"Fgrs"
};
*/
static const uint32_t dmdfCliffTilesetNumber = 2;
static const uint8_t dmdfCliffTilesets[dmdfCliffTilesetNumber][5] =
{
	"CLgr",
	"CWgr"
};



static const uint32_t currentVersion = 11;
static const uint32_t maxTilesets = 16;

static std::string tilesetIdToCString(uint32_t tilesetId)
{
	if (tilesetId == 0)
		return "0";
	
	unsigned char output[5];
	memcpy(reinterpret_cast<void*>(output), reinterpret_cast<const void*>(&tilesetId), 4);
	output[4] = '\0';
	
	return (char*)output;
}

enum Flags
{
	Ramp = 0x0010,
	Blight = 0x0020,
	Water = 0x0040,
	CameraBounds = 0x0080
};

struct TilepointData
{
	uint16_t groundHeight;
	unsigned int boundaryFlag:1;
	unsigned int waterLevel:15;
	unsigned int flags:4;
	unsigned int groundTextureType:4;
	uint8_t textureDetails;
	unsigned int cliffTextureType:4;
	unsigned int layerHeight:4;
};

static std::ostream& operator<<(std::ostream &ostream, const struct TilepointData &tilepointData)
{
	ostream
	<< "Size in bytes " << sizeof(tilepointData)
	<< "\nGround height " << tilepointData.groundHeight
	<< "\nBoundary flag " << tilepointData.boundaryFlag
	<< "\nWater level " << tilepointData.waterLevel
	<< "\nFlags " << tilepointData.flags
	<< "\nGround texture type " << tilepointData.groundTextureType
	<< "\nTexture Details " << tilepointData.textureDetails
	<< "\nCliff texture type " << tilepointData.cliffTextureType
	<< "\nLayer height " << tilepointData.layerHeight
	<< std::endl;
	
	return ostream;
}

static std::string compare(const struct TilepointData &tilepointData1, const struct TilepointData &tilepointData2)
{
	std::ostringstream sstream;
	
	if (tilepointData1.groundHeight != tilepointData2.groundHeight)
		sstream << "First ground height " << tilepointData1.groundHeight << " second ground height " << tilepointData2.groundHeight << std::endl;
	
	if (tilepointData1.boundaryFlag != tilepointData2.boundaryFlag)
		sstream << "First ground boundary flag " << tilepointData1.boundaryFlag << " second boundary flag " << tilepointData2.boundaryFlag << std::endl;
	
	if (tilepointData1.waterLevel != tilepointData2.waterLevel)
		sstream << "First water level " << tilepointData1.waterLevel << " second water level " << tilepointData2.waterLevel << std::endl;
	
	if (tilepointData1.flags != tilepointData2.flags)
		sstream << "First flags " << tilepointData1.flags << " second flags " << tilepointData2.flags << std::endl;
	
	if (tilepointData1.groundTextureType != tilepointData2.groundTextureType)
		sstream << "First ground texture type " << tilepointData1.groundTextureType << " second ground texture type " << tilepointData2.groundTextureType << std::endl;
	
	if (tilepointData1.textureDetails != tilepointData2.textureDetails)
		sstream << "First texture details " << tilepointData1.textureDetails << " second texture details " << tilepointData2.textureDetails << std::endl;
	
	if (tilepointData1.cliffTextureType != tilepointData2.cliffTextureType)
		sstream << "First cliff texture type " << tilepointData1.cliffTextureType << " second texture type " << tilepointData1.cliffTextureType << std::endl;
	
	if (tilepointData1.layerHeight != tilepointData2.layerHeight)
		sstream << "First layer height " << tilepointData1.layerHeight << " second layer height " << tilepointData2.layerHeight << std::endl;
	
	return sstream.str();
}

static std::ostream& operator<<(std::ostream &ostream, const struct Environment &environment);

class Environment
{
	public:
		Environment() : m_version(0), m_mainTileset(0), m_customTilesetsFlag(0), m_groundTilesetsNumber(0), m_cliffTilesetsNumber(0), m_maxX(0), m_maxY(0), m_centerOffsetX(0), m_centerOffsetY(0)
		{
			m_fileId[0] = 'W';
			m_fileId[1] = '3';
			m_fileId[2] = 'E';
			m_fileId[3] = '!';
		};
		
		~Environment()
		{
			for (std::vector<struct TilepointData*>::iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
				delete *iterator;
		};
		/*
		Environment(Environment &environment)
		{
			environment.m_fileId = this->m_fileId;
			environment.m_version = this->version;
			unsigned char m_mainTileset;
			uint32_t m_customTilesetsFlag;
			uint32_t m_groundTilesetsNumber;
			std::vector<uint32_t> m_groundTilesets;
			uint32_t m_cliffTilesetsNumber;
			std::vector<uint32_t> m_cliffTilesets;
			uint32_t m_maxX;
			uint32_t m_maxY;
			float m_centerOffsetX;
			float m_centerOffsetY;
			std::vector<struct TilepointData*> m_tilepoints;
		};
		*/
		
		std::streamsize read(std::istream &istream)
		{
			istream.read(reinterpret_cast<char*>(this->m_fileId), sizeof(this->m_fileId));
			std::streamsize bytes = istream.gcount();
	
			if (memcmp(this->m_fileId, "W3E!", sizeof(this->m_fileId)) != 0)
			{
				std::cerr << "Missing file id." << std::endl;
		
				return 0;
			}
	
			istream.read(reinterpret_cast<char*>(&this->m_version), sizeof(this->m_version));
			bytes += istream.gcount();
	
			if (this->m_version != currentVersion)
			{
				std::cerr << "Wrong version." << std::endl;
				
				return 0;
			}
	
			istream.read(reinterpret_cast<char*>(&this->m_mainTileset), sizeof(this->m_mainTileset));
			bytes += istream.gcount();
			istream.read(reinterpret_cast<char*>(&this->m_customTilesetsFlag), sizeof(this->m_customTilesetsFlag));
			bytes += istream.gcount();
			istream.read(reinterpret_cast<char*>(&this->m_groundTilesetsNumber), sizeof(this->m_groundTilesetsNumber));
			bytes += istream.gcount();
	
			if (this->m_groundTilesetsNumber > maxTilesets)
				std::cerr << "Too much ground tilesets: " << this->m_groundTilesetsNumber << "." << std::endl;
	
			this->m_groundTilesets = std::vector<uint32_t>(this->m_groundTilesetsNumber);
	
			for (std::size_t i = 0; i < this->m_groundTilesetsNumber; ++i)
			{
				uint32_t groundTilesetId;
				istream.read(reinterpret_cast<char*>(&groundTilesetId), sizeof(groundTilesetId));
				bytes += istream.gcount();
				this->m_groundTilesets[i] = groundTilesetId;
			}
	
			istream.read(reinterpret_cast<char*>(&this->m_cliffTilesetsNumber), sizeof(this->m_cliffTilesetsNumber));
			bytes += istream.gcount();
	
			if (this->m_cliffTilesetsNumber > maxTilesets)
				std::cerr << "Too much cliff tilesets " << this->m_cliffTilesetsNumber << "." << std::endl;
	
			this->m_cliffTilesets = std::vector<uint32_t>(this->m_cliffTilesetsNumber);
	
			for (std::size_t i = 0; i < this->m_cliffTilesetsNumber; ++i)
			{
				uint32_t cliffTilesetId;
				istream.read(reinterpret_cast<char*>(&cliffTilesetId), sizeof(cliffTilesetId));
				bytes += istream.gcount();
				this->m_cliffTilesets[i] = cliffTilesetId;
			}
	
			istream.read(reinterpret_cast<char*>(&this->m_maxX), sizeof(this->m_maxX));
			bytes += istream.gcount();
			istream.read(reinterpret_cast<char*>(&this->m_maxY), sizeof(this->m_maxY));
			bytes += istream.gcount();
			istream.read(reinterpret_cast<char*>(&this->m_centerOffsetX), sizeof(this->m_centerOffsetX));
			bytes += istream.gcount();
			istream.read(reinterpret_cast<char*>(&this->m_centerOffsetY), sizeof(this->m_centerOffsetY));
			bytes += istream.gcount();
	
			this->m_tilepoints = std::vector<struct TilepointData*>(this->m_maxX * this->m_maxY);
	
			// The first tilepoint defined in the file stands for the lower left corner of the map when looking from the top, then it goes line by line (horizontal).
			std::size_t i = 0;
			
			for (std::size_t y = 0; y < this->m_maxY; ++y)
			{
				for (std::size_t x = 0; x < this->m_maxX; ++x)
				{
					struct TilepointData *tilepointData = new TilepointData;
					istream.read(reinterpret_cast<char*>(&(*tilepointData)), 7); // sizeof(*tilepointData)
					
					/*
					if (istream.gcount() != sizeof(*tilepointData))
					{
						std::cerr << "Error while reading tilepoints.\nTilepoint " << y * maxX + x << " has " << istream.gcount() << " bytes (expected " << sizeof(*tilepointData) << ")." << std::endl;
						
						for (std::vector<struct TilepointData*>::iterator iterator = tilepoints.begin(); iterator != tilepoints.end(); ++iterator)
							delete *iterator;
						
						return EXIT_FAILURE;
					}
					*/
					
					bytes += istream.gcount();
					this->m_tilepoints[y * this->m_maxX + x] = tilepointData;
					//std::cout << "----- Tilepoint with index " << (y * maxX + x) << std::endl << *tilepointData;
					++i;
				}
			}
			
			// getting unnecessary bytes
	
			std::streampos unnecessaryBytes = istream.tellg();
			istream.seekg(0, std::ios_base::end);
			unnecessaryBytes = istream.tellg() - unnecessaryBytes;
			
			if (unnecessaryBytes > 0)
				std::cout << "Got " << unnecessaryBytes << " unnecessary bytes." << std::endl;
			
			return bytes;
		};
		
		std::streamsize write(std::ostream &ostream) const
		{
			ostream.write(reinterpret_cast<const char*>(this->m_fileId), 4);
			ostream.write(reinterpret_cast<const char*>(&this->m_version), sizeof(this->m_version));
			ostream.write(reinterpret_cast<const char*>(&this->m_mainTileset), sizeof(this->m_mainTileset));
			ostream.write(reinterpret_cast<const char*>(&this->m_customTilesetsFlag), sizeof(this->m_customTilesetsFlag));
			ostream.write(reinterpret_cast<const char*>(&this->m_groundTilesetsNumber), sizeof(this->m_groundTilesetsNumber));
			
			for (std::size_t i = 0; i < this->m_groundTilesets.size(); ++i)
				ostream.write(reinterpret_cast<const char*>(&this->m_groundTilesets[i]), sizeof(this->m_groundTilesets[i]));
			
			ostream.write(reinterpret_cast<const char*>(&this->m_cliffTilesetsNumber), sizeof(this->m_cliffTilesetsNumber));
			
			for (std::size_t i = 0; i < this->m_cliffTilesets.size(); ++i)
				ostream.write(reinterpret_cast<const char*>(&this->m_cliffTilesets[i]), sizeof(this->m_cliffTilesets[i]));
			
			ostream.write(reinterpret_cast<const char*>(&this->m_maxX), sizeof(this->m_maxX));
			ostream.write(reinterpret_cast<const char*>(&this->m_maxY), sizeof(this->m_maxY));
			ostream.write(reinterpret_cast<const char*>(&this->m_centerOffsetX), sizeof(this->m_centerOffsetX));
			ostream.write(reinterpret_cast<const char*>(&this->m_centerOffsetY), sizeof(this->m_centerOffsetY));
			std::size_t expectedSize = this->m_tilepoints.size() * sizeof(struct TilepointData);
			std::size_t realSize = 0;
			
			// The first tilepoint defined in the file stands for the lower left corner of the map when looking from the top, then it goes line by line (horizontal).
			for (std::size_t y = 0; y < this->m_maxY; ++y)
			{
				for (std::size_t x = 0; x < this->m_maxX; ++x)
				{
					ostream.write(reinterpret_cast<const char*>(&(*(this->m_tilepoints[y * this->m_maxX + x]))), 7); //sizeof(**iterator)
					realSize += sizeof(*(this->m_tilepoints[y * this->m_maxX + x]));
				}
			}
			
			std::cout << "Finished writing operation.\nExpected size: " << expectedSize << "\nReal size: " << realSize << std::endl;
			
			return this->size();
		};
		
		void setGroundTilesets(std::vector<uint32_t> &groundTilesets)
		{
			if (groundTilesets.size() > maxTilesets)
			{
				std::cerr << "Reached tilesets maximum." << std::endl;
				
				return;
			}
			
			this->m_groundTilesets = groundTilesets;
			this->m_groundTilesetsNumber = groundTilesets.size();
		};
		
		void setCliffTilesets(std::vector<uint32_t> &cliffTilesets)
		{
			if (cliffTilesets.size() > maxTilesets)
			{
				std::cerr << "Reached tilesets maximum." << std::endl;
				
				return;
			}
			
			this->m_cliffTilesets = cliffTilesets;
			this->m_cliffTilesetsNumber = cliffTilesets.size();
		};
		
		void setCliffTilesetIndexForAllTilepoints(uint8_t cliffTilesetIndex)
		{
			if (cliffTilesetIndex >= this->m_cliffTilesets.size())
			{
				std::cerr << "Index is outside of maximum." << std::endl;
				
				return;
			}
			
			std::size_t number = 0;
			
			for (std::vector<struct TilepointData*>::iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				(*iterator)->cliffTextureType = cliffTilesetIndex;
				++number;
			}
			
			std::cout << "Changed cliff tileset index of " << number << " tilepoints." << std::endl;
		};
		
		void setCliffTilesetForAllTilepoints(uint32_t cliffTileset)
		{
			uint8_t cliffTilesetIndex = -1;
			
			for (std::size_t i = 0; i < this->m_cliffTilesets.size(); ++i)
			{
				if (this->m_cliffTilesets[i] == cliffTileset)
				{
					cliffTilesetIndex = i;
					
					break;
				}
			}
			
			if (cliffTilesetIndex != -1)
			{
				this->setCliffTilesetIndexForAllTilepoints(cliffTilesetIndex);
				
				return;
			}
			
			std::cerr << "Unknown cliff tileset " << tilesetIdToCString(cliffTileset) << '.' << std::endl;
		};
		
		std::size_t fixTilepoints(uint8_t groundTilesetIndex, uint8_t cliffTilesetIndex)
		{
			/*
			if (groundTilesetIndex >= this->m_groundTilesets.size() || cliffTilesetIndex >= this->m_cliffTilesets.size())
			{
				std::cerr << "Invalid ground or cliff tileset index (" << groundTilesetIndex << " | " << cliffTilesetIndex << std::endl;
				
				return 0;
			}
			*/
			
			std::size_t number = 0;
			
			for (std::vector<struct TilepointData*>::iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				bool fixed = false;
				
				if ((*iterator)->groundTextureType >= this->m_groundTilesets.size())
				{
					(*iterator)->groundTextureType = groundTilesetIndex;
					fixed = true;
				}
				
				if ((*iterator)->cliffTextureType >= this->m_cliffTilesets.size())
				{
					(*iterator)->cliffTextureType = cliffTilesetIndex;
					fixed = true;
				}
				
				if (fixed)
					++number;
			}
			
			std::cout << "Fixed " << number << " tilepoints." << std::endl;
			
			return number;
		};
		
		std::size_t countWaterFlagTilepoints()
		{
			std::size_t result = 0;
			
			for (std::vector<struct TilepointData*>::const_iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				if ((*iterator)->flags & Water)
					++result;
			}
			
			return result;
		}
		
		std::size_t countNonWaterFlagTilepoints()
		{
			std::size_t result = 0;
			
			for (std::vector<struct TilepointData*>::const_iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				if (!((*iterator)->flags & Water))
					++result;
			}
			
			return result;
		}
		
		void addWaterLevel(unsigned int waterLevel)
		{
			for (std::vector<struct TilepointData*>::iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
				(*iterator)->waterLevel += waterLevel;
		};
		
		struct TilepointData* firstTilepointWithLayerHeight()
		{
			for (std::vector<struct TilepointData*>::iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				if ((*iterator)->layerHeight > 0)
					return *iterator;
			}
			
			return 0;
		}
		
		std::size_t countTilepointsWithLayerHeight() const
		{
			std::size_t result = 0;
			
			for (std::vector<struct TilepointData*>::const_iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				if ((*iterator)->layerHeight > 0)
					++result;
			}
			
			return result;
		}
		
		std::string listTilepointsWithLayerHeights() const
		{
			std::ostringstream sstream;
			
			for (std::vector<struct TilepointData*>::const_iterator iterator = this->m_tilepoints.begin(); iterator != this->m_tilepoints.end(); ++iterator)
			{
				if ((*iterator)->layerHeight > 0)
					sstream << **iterator << std::endl;
			}
			
			return sstream.str();
		}
		
		std::size_t size() const
		{
			return sizeof(this->m_fileId) +  sizeof(this->m_version) + sizeof(this->m_mainTileset) + sizeof(this->m_customTilesetsFlag) + sizeof(this->m_groundTilesetsNumber) + this->m_groundTilesets.size() * sizeof(uint32_t) + sizeof(this->m_cliffTilesetsNumber) + this->m_cliffTilesets.size() * sizeof(uint32_t) + sizeof(this->m_maxX) + sizeof(this->m_maxY) + sizeof(this->m_centerOffsetX) + sizeof(this->m_centerOffsetY) + this->m_tilepoints.size() * sizeof(struct TilepointData);
		};
		
		std::vector<struct TilepointData*>& tilepoints()
		{
			return this->m_tilepoints;
		};
		
	protected:
		friend std::ostream& operator<<(std::ostream &ostream, const struct Environment &environment);
		
		unsigned char m_fileId[4];
		uint32_t m_version;
		unsigned char m_mainTileset;
		uint32_t m_customTilesetsFlag;
		uint32_t m_groundTilesetsNumber;
		std::vector<uint32_t> m_groundTilesets;
		uint32_t m_cliffTilesetsNumber;
		std::vector<uint32_t> m_cliffTilesets;
		uint32_t m_maxX;
		uint32_t m_maxY;
		float m_centerOffsetX;
		float m_centerOffsetY;
		std::vector<struct TilepointData*> m_tilepoints;
};

static std::ostream& operator<<(std::ostream &ostream, const struct Environment &environment)
{
	ostream
	<< "Size in bytes " << environment.size()
	<< "\nFile id " << environment.m_fileId
	<< "\nVersion " << environment.m_version
	<< "\nMain tileset " << environment.m_mainTileset
	<< "\nCustom tilesets flag " << environment.m_customTilesetsFlag
	<< "\nGround tilesets number " << environment.m_groundTilesetsNumber << std::endl;
	
	for (std::vector<uint32_t>::const_iterator iterator = environment.m_groundTilesets.begin(); iterator != environment.m_groundTilesets.end(); ++iterator)
		ostream << "Ground tileset id " << tilesetIdToCString(*iterator) << std::endl;
	
	ostream << "Cliff tilesets number " << environment.m_cliffTilesetsNumber << std::endl;
	
	for (std::vector<uint32_t>::const_iterator iterator = environment.m_cliffTilesets.begin(); iterator != environment.m_cliffTilesets.end(); ++iterator)
		ostream << "Cliff tileset id " << tilesetIdToCString(*iterator) << std::endl;
	
	ostream
	<< "Max X " << environment.m_maxX << std::endl
	<< "Max Y " << environment.m_maxY << std::endl
	<< "Center offset X " << environment.m_centerOffsetX << std::endl
	<< "Center offset Y " << environment.m_centerOffsetY << std::endl
	<< "Tilepoints " << environment.m_tilepoints.size()
	;
	
	return ostream;
}

int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		std::cerr << "Missing arguments." << std::endl;
		
		return EXIT_FAILURE;
	}
	
	std::ifstream istream(argv[1], std::ios_base::in | std::ios_base::binary);
	
	if (!istream)
	{
		std::cerr << "Error while opening file \"" << argv[1] << "\"." << std::endl;
		
		return EXIT_FAILURE;
	}
	
	class Environment environment;
	std::streamsize size = environment.read(istream);
	
	if (size == 0)
	{
		std::cerr << "Error while reading first environment data." << std::endl;
		
		return EXIT_FAILURE;
	}
	
	// Holzbruck/Talras getting water flags
	std::cout << "Non-Water-Flag-Tilesets: " << environment.countNonWaterFlagTilepoints() << std::endl;
	
	/*
	struct TilepointData tilepoint;
	memcpy(reinterpret_cast<void*>(&tilepoint), reinterpret_cast<void*>(&(*environment.tilepoints().front())), sizeof(tilepoint));
	std::cout << "First tilepoint comparison:" << std::endl << compare(tilepoint, *environment.tilepoints().front()) << std::endl;
	
	std::cout << "Read " << size << " bytes of first environment data." << std::endl;
	std::cout << environment << std::endl;
	*/
	
	// replacement
	/*
	std::vector<uint32_t> groundTilesets(dmdfGroundTilesetNumber);
	
	for (std::size_t i = 0; i < dmdfGroundTilesetNumber; ++i)
		memcpy(reinterpret_cast<void*>(&groundTilesets[i]), dmdfGroundTilesets[i], sizeof(groundTilesets[i]));
	
	std::vector<uint32_t> cliffTilesets(0);
	*/
	
	/*
	for (std::size_t i = 0; i < dmdfCliffTilesetNumber; ++i)
		memcpy(reinterpret_cast<void*>(&cliffTilesets[i]), dmdfCliffTilesets[i], sizeof(cliffTilesets[i]));
	*/
	
	/*
	environment.setGroundTilesets(groundTilesets);
	environment.setCliffTilesets(cliffTilesets);
	environment.setCliffTilesetIndexForAllTilepoints(0); // 0 is not displayed in map?
	environment.fixTilepoints(0, 0);
	environment.addWaterLevel(-512); // 4 * displayed water level
	*/
	
	// end replacement
	
	/*
	std::cout << "New environment:\n" << environment << std::endl;
	std::cout << "First tilepoint comparison:" << std::endl << compare(tilepoint, *environment.tilepoints().front()) << std::endl;
	std::cout << "First tilepoint:\n" << *environment.tilepoints().front() << std::endl;
	*/
	//std::cout << "List layer height tilepoints (" << environment.countTilepointsWithLayerHeight() << ")\n" << environment.listTilepointsWithLayerHeights() << std::endl;
	
	/*
	std::cout << "Creating new environment file and replacing all data." << std::endl;
	std::ofstream ostream(std::string("war3map.w3e").append("new").c_str(), std::ios_base::out | std::ios_base::binary);
	
	if (!ostream)
	{
		std::cerr << "Error while creating new environment file." << std::endl;
		
		return EXIT_FAILURE;
	}
	
	environment.write(ostream);
	*/
	
	return EXIT_SUCCESS;
}
