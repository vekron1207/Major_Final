/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class ProductContract extends Contract {

    async productExists(ctx, productId) {
        const buffer = await ctx.stub.getState(productId);
        return (!!buffer && buffer.length > 0);
    }

    async createProduct(ctx, productId, value) {
        const exists = await this.productExists(ctx, productId);
        if (exists) {
            throw new Error(`The product ${productId} already exists`);
        }
        const asset = { value };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(productId, buffer);
    }

    async readProduct(ctx, productId) {
        const exists = await this.productExists(ctx, productId);
        if (!exists) {
            throw new Error(`The product ${productId} does not exist`);
        }
        const buffer = await ctx.stub.getState(productId);
        const asset = JSON.parse(buffer.toString());
        return asset;
    }

    async updateProduct(ctx, productId, newValue) {
        const exists = await this.productExists(ctx, productId);
        if (!exists) {
            throw new Error(`The product ${productId} does not exist`);
        }
        const asset = { value: newValue };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(productId, buffer);
    }

    async deleteProduct(ctx, productId) {
        const exists = await this.productExists(ctx, productId);
        if (!exists) {
            throw new Error(`The product ${productId} does not exist`);
        }
        await ctx.stub.deleteState(productId);
    }

}

module.exports = ProductContract;
