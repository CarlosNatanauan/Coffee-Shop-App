'use strict';

/**
 * drink-add-on service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::drink-add-on.drink-add-on');
