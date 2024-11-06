'use strict';

/**
 * drink-category service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::drink-category.drink-category');
