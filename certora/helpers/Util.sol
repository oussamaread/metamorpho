// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.21;

import {
    MarketParams,
    MarketParamsLib,
    IERC20,
    SafeERC20,
    IMorphoHarness,
    SharesMathLib,
    Id,
    Market
} from "../munged/MetaMorpho.sol";

/// @title Utility contract for token and market operations
/// @notice Provides utility functions for interacting with ERC20 tokens and market calculations
contract Util {
    using SafeERC20 for IERC20;
    using SharesMathLib for uint256;
    using MarketParamsLib for MarketParams;

    /// @notice Returns the balance of a user for a given token
    /// @param token The address of the ERC20 token
    /// @param user The address of the user
    /// @return The balance of the user for the specified token
    function balanceOf(address token, address user) external view returns (uint256) {
        return IERC20(token).balanceOf(user);
    }

    /// @notice Returns the total supply of a given token
    /// @param token The address of the ERC20 token
    /// @return The total supply of the specified token
    function totalSupply(address token) external view returns (uint256) {
        return IERC20(token).totalSupply();
    }

    /// @notice Safely transfers tokens from one address to another
    /// @param token The address of the ERC20 token
    /// @param from The address to transfer tokens from
    /// @param to The address to transfer tokens to
    /// @param amount The amount of tokens to transfer
    function safeTransferFrom(address token, address from, address to, uint256 amount) external {
        IERC20(token).safeTransferFrom(from, to, amount);
    }

    /// @notice Calculates the withdrawn assets based on shares and assets
    /// @param morpho The address of the Morpho contract
    /// @param id The market ID
    /// @param assets The amount of assets
    /// @param shares The amount of shares
    /// @return The withdrawn assets
    function withdrawnAssets(IMorphoHarness morpho, Id id, uint256 assets, uint256 shares)
        external
        view
        returns (uint256)
    {
        if (shares == 0) {
            return assets;
        } else {
            Market memory market = morpho.market(id);
            return shares.toAssetsDown(market.totalSupplyAssets, market.totalSupplyShares);
        }
    }

    /// @notice Returns the market ID from market parameters
    /// @param marketParams The market parameters
    /// @return The market ID
    function libId(MarketParams memory marketParams) external pure returns (Id) {
        return marketParams.id();
    }
}
