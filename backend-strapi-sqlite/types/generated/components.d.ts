import type { Schema, Struct } from '@strapi/strapi';

export interface SizeOptionSizeOption extends Struct.ComponentSchema {
  collectionName: 'components_size_option_size_options';
  info: {
    displayName: 'Size Option';
  };
  attributes: {
    price: Schema.Attribute.Decimal & Schema.Attribute.Required;
    size: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'size-option.size-option': SizeOptionSizeOption;
    }
  }
}
