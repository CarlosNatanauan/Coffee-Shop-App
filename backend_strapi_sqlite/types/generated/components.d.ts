import type { Schema, Struct } from '@strapi/strapi';

export interface SizeOptionSizeOption extends Struct.ComponentSchema {
  collectionName: 'components_size_option_size_options';
  info: {
    description: '';
    displayName: 'Size Option';
  };
  attributes: {
    drink_price: Schema.Attribute.Decimal & Schema.Attribute.Required;
    drink_size: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'size-option.size-option': SizeOptionSizeOption;
    }
  }
}
