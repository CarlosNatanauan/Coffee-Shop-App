'use strict';

/**
 * food-category service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::food-category.food-category');
