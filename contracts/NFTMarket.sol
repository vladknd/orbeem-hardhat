pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract NFTMarket is ReentrancyGuardUpgradeable{
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private itemIds; 
    
    address payable owner;
    uint256 listingFee;

    // constructor() {
    //     owner = payable(msg.sender);
    // }

    function initialize() public initializer {
        owner = payable(msg.sender); //TO-DO change msg.sender
        listingFee = 0.05 ether;
    } 

    //______________MARKET-ITEM______________________
    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private tokenID2MarketItem;

    event MarketItemCreated (
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address payable seller,
        address payable owner,
        uint256 price,
        bool sold
    );

    event MarketSaleCreated (
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address payable seller,
        address payable owner,
        bool sold
    );

    
    //_______________METHODS____________________
    function getListingFee() public view returns(uint256) {
        return listingFee;
    }

    function createMarketItem(
        address _nftContract,
        uint256 _tokenId,
        uint256 _price 
    ) public payable nonReentrant {
        require(_price > 0, "Price must be at least one wei!");
        require(msg.value == listingFee, "INSFFICIENT LISTING FEE");

        itemIds.increment();
        uint256 _itemId = itemIds.current();
        tokenID2MarketItem[_itemId] = MarketItem (
            _itemId,
            _nftContract,
            _tokenId,
            payable(msg.sender),
            payable(address(0)),
            _price,
            false
        ); 
  
        IERC721Upgradeable(_nftContract).transferFrom(msg.sender, address(this), _tokenId);

        emit MarketItemCreated(
            _itemId, 
            _nftContract, 
            _tokenId, 
            payable(msg.sender), 
            payable(address(0)), 
            _price, 
            false
        );
    }

    function createMarketSale(
        address _nftContract,
        uint256 _itemId
    ) public payable nonReentrant {
        uint256 _price = tokenID2MarketItem[_itemId].price;
        uint256 _tokenId = tokenID2MarketItem[_itemId].tokenId;

        require(msg.value == _price,"SEND THE AMOUNT EQUAL TO PRICE OF THE ASSET");

        tokenID2MarketItem[_itemId].seller.transfer(msg.value);
        IERC721Upgradeable(_nftContract).transferFrom(address(this), msg.sender, _tokenId);
        
        tokenID2MarketItem[_itemId].owner = payable(msg.sender);
        tokenID2MarketItem[_itemId].sold = true;

        emit MarketSaleCreated (
            _itemId,
            _nftContract,
            _tokenId,
            payable(address(0)),
            payable(msg.sender),
            true
        );
    }

}
