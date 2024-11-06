'use strict';

/**
 * drink-item service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::drink-item.drink-item');
