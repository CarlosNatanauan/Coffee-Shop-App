'use strict';

/**
 * food-add-on service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::food-add-on.food-add-on');
