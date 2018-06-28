import { default as computed } from 'ember-addons/ember-computed-decorators';
import { staticRoutes } from '../lib/site-utilities';

export default Ember.Component.extend({
  tagName: 'ul',
  classNames: 'nav-pills',

  @computed('active')
  navItems(active) {
    return staticRoutes.map((type) => {
      return {
        type: type.name,
        listClass: `nav-item-${type.name}`,
        linkClass: type.name === active ? 'active' : '',
        label: type.label
      };
    });
  }
});
