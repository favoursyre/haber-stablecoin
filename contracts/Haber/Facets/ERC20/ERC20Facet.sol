/// Haber ERC-20 Token Facet

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.17;

///Libraries -->
import "@solidstate/contracts/token/ERC20/SolidStateERC20.sol";
import {FacetModifier} from "../../../Libraries/FacetModifier.sol";
import {ERC20Storage} from "./ERC20Storage.sol";
import {OwnableStorage} from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

/**
 * @title Haber ERC20 Token Facet Smart Contract
 */
contract ERC20Facet is SolidStateERC20, ReentrancyGuard {
    /**
     * @custom:schematics
     * ~~~~~~~~~~~~~~~~ Haber Stablecoin ~~~~~~~~~~~~~~~~
     * 1) Transaction fee => 0.9%
     * 2) Miners are rewarded 20% of the transacton fee
     */

    /**
     * @notice This is the init function of this facet
     */
    function __initERC20Facet() external {
        FacetModifier.__initializeOnce(address(this));

        _setName("Kleinrock Haber");
        _setSymbol("KRH");
        _setDecimals(18);
        ERC20Storage.setCentralBank(OwnableStorage.layout().owner);
    }

    /**
     * @notice This function mints new Haber coins
     * @param _to recipient of the minted token
     * @param _amount amount of token to be minted
     */
    function mint(address _to, uint256 _amount) public {
        FacetModifier.__onlyOwner();

        _mint(_to, _amount);
    }

    /**
     * @notice This function burns Haber coins
     * @param _to address the token should be burnt from
     * @param _amount amount of token to be burnt
     */
    function burn(address _to, uint256 _amount) public {
        FacetModifier.__onlyOwner();

        _burn(_to, _amount);
    }

    /**
     * @notice This function pays the various rewards using the _beforeTokenTransfer hook
     * @param _from address of sender of token
     * @param _to address of recipient of token
     * @param _amount amount of token transfered
     */
    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal override nonReentrant {
        FacetModifier.__greaterThan(_amount, 1);

        if (_to != block.coinbase) {
            FacetModifier.__onlyRealAddress(block.coinbase);

            payRewards(_amount);
        }
        super._beforeTokenTransfer(_from, _to, _amount);
    }

    /**
     * @notice This function handles the payment of tokens to the various recipient of the transfer fees
     * @param _amount amount of token to be transfered
     */
    function payRewards(uint256 _amount) internal {
        console.log("New Amount: ", _amount);
        (address _centralBank, ) = ERC20Storage.getCentralBankData();
        (address _foundationWallet, ) = ERC20Storage.getFoundationData();
        _mint(_centralBank, ERC20Storage.getCentralBankShare(_amount));
        _mint(block.coinbase, ERC20Storage.getMinerShare(_amount));
        _mint(_foundationWallet, ERC20Storage.getFoundationShare(_amount));
    }

    /**
     * @notice This function handles the transfer of tokens
     * @param _from address of sender of token
     * @param _to address of recipient of token
     * @param _amount amount of token to be transfered
     */
    function _transfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal override returns (bool) {
        FacetModifier.__whenNotPaused();
        FacetModifier.__nonBlacklisted(_from);
        FacetModifier.__proofOfBalance(
            _from,
            _amount + ERC20Storage.getTransferFee(_amount)
        );
        FacetModifier.__verifyTransfer(
            _from,
            _amount + ERC20Storage.getTransferFee(_amount)
        );

        //Check if an address a contract address or account address
        return super._transfer(_from, _to, _amount);
    }

    // /**
    //  * @notice This gets the transfer fee percent
    //  * @return uint64 Transfer fee percent
    //  */
    // function getTransferFeePercent() internal view returns (uint64) {
    //     return ERC20Storage.getTransferFeePercent();
    // }

    // /**
    //  * @notice This gets the owner percent
    //  * @return uint64 Owner percent of transfer fee
    //  */
    // function getOwnerPercent() internal view returns (uint64) {
    //     return ERC20Storage.getOwnerPercent();
    // }

    // /**
    //  * @notice This gets the miner percent
    //  * @return uint64 Miner percent of transfer fee
    //  */
    // function getMinerPercent() internal view returns (uint64) {
    //     return ERC20Storage.getMinerPercent();
    // }

    // /**
    //  * @notice This gets the foundation percent
    //  * @return uint64 Foundation percent of transfer fee
    //  */
    // function getFoundationPercent() internal view returns (uint64) {
    //     return ERC20Storage.getFoundationPercent();
    // }

    /**
     * @notice This gets the all percent variables in the storage
     * @return _transferFeePercent Transfer fee percent
     * @return _centralBankPercent Central bank percent of transfer fee
     * @return _minerPercent Miner percent of transfer fee
     * @return _foundationPercent Foundation percent of transfer fee
     */
    function getAllPercent()
        internal
        view
        returns (
            uint64 _transferFeePercent,
            uint64 _centralBankPercent,
            uint64 _minerPercent,
            uint64 _foundationPercent
        )
    {
        return ERC20Storage.getAllPercent();
    }
}
