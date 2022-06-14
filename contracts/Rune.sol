pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Rune is ERC721URIStorageUpgradeable {
    address marketAddress;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter tokenIds;

    struct Attributes {
        uint8 power;
        uint8 durability;
    }
    
    Attributes baseAttributes;
    Attributes attributes;

    mapping(uint256 => uint8) private id2Level;
    mapping(uint256 => Attributes) private id2BaseAttributes;
    mapping(uint256 => Attributes) private id2Attributes;

    function initialize(address _marketAddress) initializer public {
        __ERC721_init("Rune", "RUNE");
        marketAddress = _marketAddress;
    }

    //______________________________EVENTS_________________:
    event RuneCreated (
        uint256 indexed tokenId,
        address indexed nftAddress,
        string tokenURI,
        address indexed owner,
        uint8 level,
        uint8 power,
        uint8 durability
    );

    event UpdatedAttributes (
        uint256 indexed tokenId,
        uint8 power,
        uint8 durability
    );

    event LeveledUp (
        uint256 indexed tokenId,
        uint8 level
    );
    //-----------------------METHODS---------------------:

    //_______________________________GENERATION_____________________________:
    function createRune(string memory _uri, uint8 _power, uint8 _durability) public returns(uint256 id){
        tokenIds.increment();
        uint256 newId = tokenIds.current();

        id2Level[newId] = 0;
        id2BaseAttributes[newId] = Attributes(_power, _durability);
        id2Attributes[newId] = Attributes(_power, _durability);

        _safeMint(msg.sender, newId);
        _setTokenURI(newId, _uri);
        setApprovalForAll(marketAddress, true);

        emit RuneCreated (
            newId,
            address(this),
            _uri,
            msg.sender,
            0,
            _power, 
            _durability
        );

        return newId;
    }

    //_____________________LEVEL_________________________________________
    function levelUp(uint256 _tokenId) public returns(uint8 newLevel){
        id2Level[_tokenId]++;
        
        emit LeveledUp (
            _tokenId,
            id2Level[_tokenId]
        );

        return id2Level[_tokenId];
    }

    function getLevel(uint256 _tokenId) public view returns(uint8 level){
        return id2Level[_tokenId];
    }


    //_______________________________ATTRIBUTES_______________________________
    function getCurrentAttributes(uint256 _tokenId) 
        public 
        view 
        returns(Attributes memory currentAttributes){
            return id2Attributes[_tokenId];
    }

    function getBaseAttributes(uint256 _tokenId) 
        public 
        view 
        returns(Attributes memory base) {
            return id2BaseAttributes[_tokenId];
    }

    function updateAttributes(uint256 _tokenId, uint8 _newPower, uint8 _newDurability) 
        public 
        returns(Attributes memory newAttributes){
            uint8 prevPower = id2Attributes[_tokenId].power;
            uint8 prevDurability = id2Attributes[_tokenId].durability;
            uint16 newTotal = _newDurability+_newPower;
            uint16 baseTotal = id2BaseAttributes[_tokenId].power + id2BaseAttributes[_tokenId].durability;
            uint16 allowance = id2Level[_tokenId]*4 + baseTotal;
            
            require(_newPower >= prevPower, "New attribute must be greater than the previous one");
            require(_newDurability >= prevDurability, "New attribute must be greater than the previous one");
            require(newTotal <= allowance, "Not enough points!");

            id2Attributes[_tokenId] = Attributes(_newPower, _newDurability);

            emit UpdatedAttributes (
                _tokenId,
                _newPower,
                _newDurability
            );

            return id2Attributes[_tokenId];
    }

    //___________________________________________________________________________________________________________
}
